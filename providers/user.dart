import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class User {
  String name;

  User({this.name});
}

class UserProvider extends ChangeNotifier {
  User _user = User();

  String get name {
    return _user.name;
  }

  Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'user.db'), version: 1,
        onCreate: (db, version) {
      db.execute('CREATE TABLE user(name TEXT PRIMARYKEY)');
    });
  }

  Future checkandsetName() async {
    final db = await database();
    return db.query('user').then((val) {
      if(val==null || val.length==0) return;
      _user.name = val[0]['name'];
      notifyListeners();
    });
  }

  void setName(String newName) async {
    final db = await database();
    db.delete('user');
    db.insert('user', {'name': newName},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    _user.name = newName;
    notifyListeners();
  }
}
