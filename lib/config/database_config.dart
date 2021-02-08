

import 'package:sangkuy/helper/table_helper.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DatabaseConfig {
  static DatabaseConfig _dbHelper = DatabaseConfig._singleton();
  factory DatabaseConfig() {
    return _dbHelper;
  }

  DatabaseConfig._singleton();
  final tables = [
    UserTable.CREATE_TABLE,
  ];

  Future<Database> openDB() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(path.join(dbPath, 'sangkuy.db'),
        onCreate: (db, version) {
          tables.forEach((table) async {
            await db.execute(table).then((value) {
              print("berashil $table");
            }).catchError((err) {
              print("errornya ${err.toString()}");
            });
          });
        }, version: 1);
  }

  Future<bool> insert(String table, Map<String, Object> data) async {
    try{
      final db = await openDB();
      await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> readData(String sql, [List<dynamic> arguments])async{
    final db = await openDB();
    var result = await db.rawQuery(sql,arguments);
    return result.toList();
  }

  Future<bool> update(String table, Map<String, Object> data) async {
    print("DATA $data");
    try{
      final db = await openDB();
      String id = data['id'];
      await  db.update(table, data,where: 'id = ?', whereArgs: [id],conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    }
    catch(_){
      return false;
    }
  }

  Future<bool> delete(table,column,value) async{
    try{
      final db = await openDB();
      await db.rawDelete('DELETE FROM $table WHERE $column=?', [value]);
      return true;
    }
    catch(_){
      return false;
    }
  }
  deleteAll(table) async{
    openDB().then((db) {
      db.execute("DELETE FROM $table");
    }).catchError((err) {
      print("error $err");
    });
  }


}