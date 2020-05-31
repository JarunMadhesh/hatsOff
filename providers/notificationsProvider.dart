class Records {
  DateTime date;
  bool isDone;

  Records(this.date, this.isDone);
}

class NotificationData{ 
  String habitId;
  List<Records> records;

  NotificationData(this.habitId,this.records);
}
