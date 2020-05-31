import 'package:flutter/cupertino.dart';
import 'package:hatsoff/providers/localNotification.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class ToDo {
  String id;
  String name;
  bool isReminderOn;
  DateTime dueDate;
  DateTime startTime;
  DateTime doneTime;
  String treat;

  ToDo(this.id, this.name, this.isReminderOn, this.dueDate, this.startTime,
      this.treat,
      {this.doneTime});
}

class ToDoProvider with ChangeNotifier {
  List<ToDo> _list = [];

  List<ToDo> _recordsList = [];

  List<ToDo> get toDolist {
    return _list;
  }

  List<ToDo> get records {
    return _recordsList;
  }

  static Future<sql.Database> taskDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
        path.join(
          dbPath,
          'task.db',
        ),
        version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, isReminderOn INT, dueTime TEXT, startTime TEXT, treat TEXT, doneTime TEXT)');
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

  Future addTask(ToDo task, [isEdit = false]) async {
    try {
      final tasksdb = await taskDatabase();
      final notificationdb = await notificationdatabase();

      // initialise notification id
      int notificationId;

      // if the habit already has a notification data,
      // the notification id is fetched
      final notificationRecord = await notificationdb.rawQuery(
          'SELECT notificationId FROM notifiications WHERE habitid = ?',
          [task.id]);

      if (task.isReminderOn) {
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
        await LocalNotification().scheduleNotification(
            notificationId, task.dueDate, 'reminder', task);

        // the notification record is then added to the notification record database
        await notificationdb.insert('notifiications',
            {'habitid': task.id, 'notificationid': notificationId},
            conflictAlgorithm: sql.ConflictAlgorithm.replace);
      } else {
        // if the reminder time is null, it means that, the reminder time is not set
        // but if the user already has a notification scheduled, we must delete it
        if (isEdit && notificationRecord.length != 0) {
          await LocalNotification()
              .deleteNotification(notificationRecord[0]['notificationid']);
        }
      }

      await tasksdb.insert(
        'tasks',
        {
          'id': task.id,
          'name': task.name,
          'isReminderOn': task.isReminderOn ? 1 : 0,
          'dueTime': task.dueDate.toString(),
          'startTime': task.startTime.toString(),
          'treat': task.treat,
          'doneTime': 'nun',
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
        nullColumnHack: 'nun',
      );

      await getTasks();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future getRecords() async {
    try {
      final tasksdb = await taskDatabase();
      final tasksdbMaps = await tasksdb.query('tasks', orderBy: 'dueTime ASC');
      List<ToDo> _tempList = [];
      tasksdbMaps.forEach((each) {
        _tempList.add(ToDo(
          each['id'],
          each['name'],
          each['isReminderOn'] == 1,
          DateTime.parse(each['dueTime']),
          DateTime.parse(each['startTime']),
          each['treat'],
          doneTime: each['doneTime'] == 'nun'
              ? null
              : DateTime.parse(each['doneTime']),
        ));
      });
      final list1 =
          _tempList.where((element) => element.doneTime == null).toList();
      final list2 = _tempList
          .where((element) => element.doneTime != null)
          .toList()
          .reversed
          .toList();
      list1.insertAll(list1.length, list2);
      _recordsList = list1.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future getTasks() async {
    try {
      final tasksdb = await taskDatabase();
      final tasksdbMaps = await tasksdb.query('tasks',
          orderBy: 'dueTime', where: 'doneTime = ?', whereArgs: ['nun']);
      List<ToDo> _tempList = [];
      tasksdbMaps.forEach((each) {
        _tempList.add(ToDo(
          each['id'],
          each['name'],
          each['isReminderOn'] == 1,
          DateTime.parse(each['dueTime']),
          DateTime.parse(each['startTime']),
          each['treat'],
          doneTime: each['doneTime'] == 'nun'
              ? null
              : DateTime.parse(each['doneTime']),
        ));
      });
      _list = _tempList;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  // edit habit. As any redundant column is said to be replaced in the add habit section,
  // even the edit habit might use the same code.
  Future editTask(ToDo newTask) async {
    try {
      await addTask(newTask, true);
    } catch (e) {
      throw (e);
    }
  }

  Future deleteTask(ToDo toDo) async {
    try {
      final taskdb = await taskDatabase();
      final notificationdb = await notificationdatabase();
      final idMap = await notificationdb.rawQuery(
          'SELECT notificationid from notifiications where habitid= ?',
          [toDo.id]);
      if (idMap.length != 0) {
        await LocalNotification()
            .deleteNotification(idMap[0]['notificationid']);
        await notificationdb.delete('notifiications',
            where: 'habitid = ?', whereArgs: [toDo.id]);
      }
      await taskdb.delete('tasks', where: 'id = ?', whereArgs: [toDo.id]);
      getTasks();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future setDone(ToDo task) async {
    final taskdb = await taskDatabase();
    final notificationdb = await notificationdatabase();
    final idMap = await notificationdb.rawQuery(
        'SELECT notificationid from notifiications where habitid= ?',
        [task.id]);
    if (idMap.length != 0) {
      await LocalNotification().deleteNotification(idMap[0]['notificationid']);
      await notificationdb
          .delete('notifiications', where: 'habitid = ?', whereArgs: [task.id]);
    }
    taskdb.update('tasks', {'doneTime': DateTime.now().toString()},
        where: 'id = ?', whereArgs: [task.id]);
    await getTasks();
  }
}
