import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hatsoff/providers/toDo.dart';
import 'habits.dart';

class LocalNotification {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future addNotification(int id, Time time, String purpose, Habit habit) async {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = AndroidNotificationDetails('repeatdaily channel id',
        'repeatdaily channel name', 'repeatdaily channel desc',
        enableVibration: true,
        enableLights: true,
        playSound: true,
        icon: 'logo',
        ongoing: true,
        importance: Importance.Max,
        priority: Priority.High);
    var ios = IOSNotificationDetails(presentSound: true);
    var platform = NotificationDetails(android, ios);
    await _flutterLocalNotificationsPlugin.showDailyAtTime(
        id, 'Reminder', "Its time to do your activity '${habit.name}'", time, platform,
        payload: 'habit:${habit.id}');
  }

  Future scheduleNotification(int id, DateTime time, String purpose, ToDo task) async {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = AndroidNotificationDetails('repeatdaily channel id',
        'repeatdaily channel name', 'repeatdaily channel desc',
        enableVibration: true,
        enableLights: true,
        playSound: true,
        icon: 'logo',
        ongoing: true,
        importance: Importance.Max,
        priority: Priority.High);
    var ios = IOSNotificationDetails(presentSound: true);
    var platform = NotificationDetails(android, ios);
    await _flutterLocalNotificationsPlugin.schedule(
        id, 'Reminder', "Its time to do your task '${task.name}'", time, platform,
        payload: 'tasks:${task.id}');
  }

  Future deleteNotification(int id) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future deleteallNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
