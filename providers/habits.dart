import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hatsoff/providers/localNotification.dart';
import 'package:hatsoff/providers/notificationsProvider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class Habit {
  String id;
  String name;
  int streek;
  bool isDone;
  String treat;
  TimeOfDay reminderTime;

  Habit(this.id, this.name, this.streek, this.isDone, this.treat,
      {this.reminderTime});
}

class HabitProvider with ChangeNotifier {
  // This is the main list where habits are stored into and are retreived
  List<Habit> _habits = [];

  // This is the list of records of each habit with
  // its history
  List<NotificationData> _recordsList = [];

  List<NotificationData> get records {
    return _recordsList;
  }

  // This get method is used to fetch all the habits
  // to anywhere in the application
  List<Habit> get habits {
    return _habits;
  }

  Habit getHabitById(String id) {
    int index = _habits.indexWhere((each) => each.id == id);
    return _habits[index];
  }

  // This method is used to check if the habit is done for the day.
  // it does not do anything in paticular than just fetching!
  // it uses 'id' to fetch the habit from the _habit list
  // then it returns the 'isDone' property of the habit.
  bool isDone(String id) {
    return _habits[_habits.indexWhere((each) => each.id == id)].isDone;
  }

  // This method is used to instantiate the datadase for habits.
  // In this database, all the information about the habits are stored.
  // database name: habits.db
  // it has one table: habits(id TEXT PRIMARY KEY, name TEXT, streek INT, treat TEXT, reminderTime TEXT)
  // if the database is not available, it is created with the table
  static Future<sql.Database> habitdatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'habits.db'), version: 1,
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE habits(id TEXT PRIMARY KEY, name TEXT, streek INT, treat TEXT, reminderTime TEXT)');
    });
  }

  // This method is used to instantiate the datadase for habit's daily record.
  // It has information about the habit, and the date and status of the habit on the particular day.
  // It will not store the records of the dates when the app is not even opened
  // so if there is no data in a particular date, it means the user havenot completed the task on
  // that particular day.

  // database name: habitrecords.db
  // it has one table: records(habitid TEXT, date TEXT, isDone INT)
  // if the database is not available, it is created with the table
  static Future<sql.Database> habitrecorddatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'habitrecord.db'), version: 1,
        onCreate: (db, version) {
      db.execute('CREATE TABLE records(habitid TEXT, date TEXT, isDone INT)');
    });
  }

  // This method is used to instantiate the datadase for habit's notification record.
  // it has the pairs of habit id and notification id
  // notification is handled by flutter_local_notification. Each notification in it has a
  // seperate set of data for itself and it can be
  // added, deleted or edited using the notification id.

  // database name: notificationDb.db
  // it has one table: notifiications(habitid TEXT PRIMARY KEY, notificationid INT)
  // if the database is not available, it is created with the table
  static Future<sql.Database> notificationdatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'notificationDb.db'), version: 1,
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE notifiications(habitid TEXT PRIMARY KEY, notificationid INT)');
    });
  }

  Future getRecords(String id) async {
    final db = await habitrecorddatabase();
    NotificationData _tempNotificationData;
    final records =
        await db.query('records', where: 'habitid = ?', whereArgs: [id]);
    List<Records> _tempRecordsList = [];
    records.forEach((f) {
      final splittedData = f['date'].split('-');
      DateTime dateTime = DateTime(int.parse(splittedData[0]),
          int.parse(splittedData[1]), int.parse(splittedData[2]));
      _tempRecordsList.add(Records(dateTime, f['isDone'] == 1));
    });
    _tempNotificationData = NotificationData(id, _tempRecordsList);
    _recordsList.add(_tempNotificationData);
    notifyListeners();
  }

//add habit
  Future addHabit(Habit newHabit, [bool isEdit = false]) async {
    try {
      // fetch all the database instances
      final habitDb = await habitdatabase();
      final recordDb = await habitrecorddatabase();
      final notificationDb = await notificationdatabase();

      // initialise notification id
      int notificationId;

      // if the habit already has a notification data,
      // the notification id is fetched
      final notificationRecord = await notificationDb.rawQuery(
          'SELECT notificationId FROM notifiications WHERE habitid = ?',
          [newHabit.id]);

      // check if the reminder time is set for the habit
      // that is to know if we have to schedule notiication
      if (newHabit.reminderTime != null) {
        // reminderTime will not be null so,
        // the TimeofDay is converted to time
        Time _time =
            Time(newHabit.reminderTime.hour, newHabit.reminderTime.minute);

        // checking if the habit has notification record already
        if (notificationRecord.length == 0 || notificationRecord == null) {
          // if it does not have, we create a new notification id
          notificationId =
              DateTime.now().day * 1000 + DateTime.now().millisecond;
        } else {
          // or else we will use the already existsing notification id
          notificationId = notificationRecord[0]['notificationid'];
        }

        // schedule a daily notification with the
        // notification id, time to notify, key word 'reminder' and the habit data itself
        await LocalNotification()
            .addNotification(notificationId, _time, 'reminder', newHabit);

        // the notification record is then added to the notification record database
        await notificationDb.insert('notifiications',
            {'habitid': newHabit.id, 'notificationid': notificationId},
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      } else {
        // if the reminder time is null, it means that, the reminder time is not set
        // but if the user already has a notification scheduled, we must delete it
        if (isEdit && notificationRecord.length != 0) {
          await LocalNotification()
              .deleteNotification(notificationRecord[0]['notificationid']);
        }
      }

      // thus with all the initial stuffs done,
      // we insert the habit information into the habits database
      await habitDb.insert(
        'habits',
        {
          'id': newHabit.id,
          'name': newHabit.name,
          'streek': newHabit.streek,
          'treat': newHabit.treat,
          'reminderTime': newHabit.reminderTime != null
              ? newHabit.reminderTime.toString()
              : 'nun',
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
        nullColumnHack: 'nun',
      );

      // if user is not in edit mode,
      // if yes, we have to add the notification record into
      // the notification record database
      if (!isEdit) {
        recordDb.insert('records', {
          'habitid': newHabit.id,
          'date': DateTime.now().toString().substring(0, 10),
          'isDone': 0
        });
      }

      // finally we update the _habit list by getting habit datas from the database
      await getHabit();
    } catch (e) {
      throw (e);
    }
  }

  //calculate streek
  Future<int> calculateStreek(String habitId) async {
    // open database
    final habitRecorddb = await habitrecorddatabase();
    // check the records by habit and arrange them by date
    final records = await habitRecorddb.query('records',
        where: 'habitid = ? and isDone =? ', whereArgs: [habitId,1], orderBy: 'date');
    if(records.length ==0) {
      return 0;
    }
    // find the last data entried date
    final splittedData = records[records.length - 1]['date'].split('-');
    DateTime dateTime = DateTime(int.parse(splittedData[0]),
        int.parse(splittedData[1]), int.parse(splittedData[2]));
    // find the difference between that date to now
    final daysDifference = dateTime.difference(DateTime.now()).inDays;
    // if difference is one, then difference in streeks should be zero.
    // and for each not done day, 5 streeks has to be reduced!
    if (daysDifference.abs() == 1) {
      return 0;
    } else {
      return (daysDifference * 2);
    }
  }

  // gets habit from the database and store it in the _habits list
  Future getHabit() async {
    try {
      // we get the database references
      final habitDb = await habitdatabase();
      final recordDb = await habitrecorddatabase();
      _recordsList.clear();

      // create a tempHabit list to store data for now,
      // this is then transfered to the main _habits list
      List<Habit> _tempHabitList = [];

      // we get the list ordered by the number of streeks
      final list = await habitDb.query('habits', orderBy: 'id desc');

      // for each habit from the databse
      //  some fuctions are performed and
      // then they are added to the _habits list
      await Future.forEach(list, (f) async {
        int totalStreek;
        String remTime;
        final String id = f['id'];
        int isDone = 0;

        // total streek for each habit is calculated
        int resultfromCalcStreek = await calculateStreek(id);
        totalStreek = f['streek'] + resultfromCalcStreek >= 0
            ? f['streek'] + resultfromCalcStreek
            : 0;

        await getRecords(id);

        // check if the habit is done for today
        // it doesnt mean yes/no
        // it check if we have any information about it in the DB
        await recordDb.rawQuery(
            'SELECT * FROM records where Date= ? AND habitid=?',
            [DateTime.now().toString().substring(0, 10), id]).then((val) {
          if (val == null || val.length == 0) {
            // if not, the habit is set not done
            isDone = 0;
            recordDb.insert('records', {
              'habitid': id,
              'date': DateTime.now().toString().substring(0, 10),
              'isDone': 0
            });
            int i = _recordsList.indexWhere((element) => element.habitId == id);
            _recordsList[i].records.add(Records(DateTime.now(), false));
          } else {
            // if we have something in DB, that value is set to isDone
            isDone = val[0]['isDone'];
          }
        });

        // check if reminder time is set for that particular habit
        //  and push it to _tempHabitList accordingly
        if (f['reminderTime'] != 'nun') {
          // having notification timing
          remTime = f['reminderTime'];
          var hourString = remTime.split(":")[0];
          var minString = remTime.split(":")[1];
          _tempHabitList.add(Habit(
            f['id'],
            f['name'],
            totalStreek,
            isDone == 1,
            f['treat'],
            reminderTime: TimeOfDay(
              hour: int.parse(hourString.substring(hourString.length - 2)),
              minute: int.parse(
                minString.substring(0, minString.length - 1),
              ),
            ),
          ));
        } else {
          // not having notification timing
          _tempHabitList.add(Habit(
            f['id'],
            f['name'],
            totalStreek,
            isDone == 1,
            f['treat'],
          ));
        }
      });
      final list1 = _tempHabitList.where((element) => element.isDone).toList();
      final list2 = _tempHabitList.where((element) => !element.isDone).toList();
      list2.insertAll(list2.length, list1);
      // finally _habit list is updated and notified listeners
      _habits = list2;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  // edit habit. As any redundant column is said to be replaced in the add habit section,
  // even the edit habit might use the same code.
  Future editHabit(Habit newhabit) async {
    try {
      await addHabit(newhabit, true);
    } catch (e) {
      throw (e);
    }
  }

  //delete habit
  Future deleteHabit(String id) async {
    try {
      final db = await habitdatabase();
      final notificationdb = await notificationdatabase();
      final idMap = await notificationdb.rawQuery(
          'SELECT notificationid from notifiications where habitid= ?', [id]);
      if (idMap.length != 0) {
        await LocalNotification()
            .deleteNotification(idMap[0]['notificationid']);
        await notificationdb
            .delete('notifiications', where: 'habitid = ?', whereArgs: [id]);
      }
      await db
          .delete('habits', where: 'id= ?', whereArgs: [id]).then((_) async {
        await getHabit();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<bool> setDone(String id) async {
    try {
      final recordDb = await habitrecorddatabase();
      final habitDb = await habitdatabase();

      //get the record for today
      final val = await recordDb.rawQuery(
          'SELECT * FROM records where Date= ? and habitid=?',
          [DateTime.now().toString().substring(0, 10), id]);

      // check if there is a record for today
      if (val == null || val.length == 0) {
        // if not, a record is created
        await recordDb.insert('records', {
          'habitid': id,
          'date': DateTime.now().toString().substring(0, 10),
          'isDone': 0
        });
      }

      // if yes and the habit is done, function terminates
      if (val[0]['isDone'] == 1) return false;

      // if no, the record is updated
      await recordDb.rawUpdate(
          'UPDATE records SET  isDone = ? WHERE habitid = ? and date = ?',
          [1, id, DateTime.now().toString().substring(0, 10)]);

      final streek =
          _habits[_habits.indexWhere((each) => each.id == id)].streek;

      // streek is raised
      await habitDb.rawUpdate(
          'UPDATE habits SET streek = ? WHERE id = ?', [streek + 1, id]);
      await getHabit();
      // int index = _habits.indexWhere((test) => test.id == id);
      // _habits[index].isDone = true;
      notifyListeners();
      return true;
    } catch (e) {
      throw (e);
    }
  }

  Future setNotDone(String id) async {
    try {
      final recordDb = await habitrecorddatabase();
      final habitDb = await habitdatabase();
      final val = await recordDb.query('records',
          where: 'Date= ? and habitid=?',
          whereArgs: [DateTime.now().toString().substring(0, 10), id]);
      if (val == null || val.length == 0) {
        await recordDb.insert(
          'records',
          {
            'habitid': id,
            'date': DateTime.now().toString().substring(0, 10),
            'isDone': 0
          },
          conflictAlgorithm: sql.ConflictAlgorithm.replace,
        );
      }
      if (val[0]['isDone'] == 0) return;
      await recordDb.rawUpdate(
          'UPDATE records SET  isDone = ? WHERE habitid = ? and date = ?',
          [0, id, DateTime.now().toString().substring(0, 10)]);

      final streek =
          _habits[_habits.indexWhere((each) => each.id == id)].streek;

      await habitDb.rawUpdate(
          'UPDATE habits SET streek = ? WHERE id = ?', [streek - 1, id]);
      await getHabit();
      int index = _habits.indexWhere((test) => test.id == id);
      _habits[index].isDone = false;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  bool checkIftheNameAlreadyExists(String name) {
    final record = _habits.where((element) => element.name == name);
    return record.length == 1;
  }
}
