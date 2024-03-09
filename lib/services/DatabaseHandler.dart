import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import '../dbModels.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'csv.db'),
      onCreate: (database, version) {
        database.execute(
          'CREATE TABLE csvLines(id INTEGER PRIMARY KEY NOT NULL, yes INTEGER NOT NULL, no INTEGER NOT NULL, statment TEXT NOT NULL, question TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertCSV(List<CSVdb> lines) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var line in lines) {
      result = await db.insert('csvLines', line.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    return result;
  }

  Future<dynamic> getDBvalue(dynamic id, dynamic next) async {
    final Database db = await initializeDB();
    if (id.runtimeType == String) {
      List<Map> query =
          await db.rawQuery('SELECT id FROM csvLines WHERE $id=?', [next]);
      return query[0]['id'];
    } else {
      List<Map> query =
          await db.rawQuery('SELECT $next FROM csvLines WHERE id=?', [id]);
      return query[0][next];
    }
  }
}