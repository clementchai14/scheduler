
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:scheduler/model/schedule.dart';
import 'package:sqflite/sqflite.dart';
import 'const.dart' as constants;

class SQLiteDb {

  static final SQLiteDb _sqLiteDb = new SQLiteDb._internal();
  SQLiteDb._internal();
  static SQLiteDb get instance => _sqLiteDb;
  static Database _database;
  static const platform = const MethodChannel('exportDbChannel');

  Future<Database> _initDB() async {
    String databasePath = await getDatabasesPath();
    String databaseFilePath = path.join(databasePath, 'scheduler.db');
    return await openDatabase(
        databaseFilePath,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(constants.SQLiteConstants.CREATE_SCHEDULE_TABLE);
        }
    );
  }

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  static Future<bool> exportDatabase() async {
    if(await Permission.storage.isGranted){
      return await _exportDb();
    }else{
      return await Permission.storage.request().then((value) async {
        if(value.isGranted){
          return await _exportDb();
        }else{
          return false;
        }
      });
    }
  }

  static Future<bool> _exportDb() async {
    List<Schedule> list = await instance.getAllScheduleList();
    var json = jsonEncode(list.map((e) => e.toMap()).toList());
    try{
      var result = await platform.invokeMethod('exportDb', {"content": json});
      return result;
    } on PlatformException catch (e){
      print('Fail to export Db: ' + e.message);
      return false;
    }
  }

  Future<void> insertSchedule(Schedule schedule) async {
    final db = await database;
    await db.insert(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE, schedule.toMap());
  }

  Future<List<Schedule>> getAllScheduleList() async {
    final db = await database;
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list;
  }

  Future<List<Schedule>> getTodayScheduleList() async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String dateToday = dateFormat.format(DateTime.now());
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_DATE + ' = ? AND ' + constants.SQLiteConstants.KEY_STATUS + ' != ?',
        whereArgs: [dateToday, 'Done'],
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list;
  }

  Future<List<Schedule>> getToDoScheduleList() async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String dateToday = dateFormat.format(DateTime.now());
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_STATUS + ' != ? AND ' + constants.SQLiteConstants.KEY_DATE + ' >= ?',
        whereArgs: ['Done', dateToday],
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list;
  }

  Future<List<Schedule>> getDoneScheduleList() async {
    final db = await database;
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_STATUS + ' = ?',
        whereArgs: ['Done'],
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list;
  }

  Future<List<Schedule>> getOverDueScheduleList() async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String dateToday = dateFormat.format(DateTime.now());
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_STATUS + ' != ? AND ' + constants.SQLiteConstants.KEY_DATE + ' < ?',
        whereArgs: ['Done', dateToday],
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list;
  }

  Future<int> getTodayScheduleCount() async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String dateToday = dateFormat.format(DateTime.now());
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_DATE + ' = ? AND ' + constants.SQLiteConstants.KEY_STATUS + ' != ?',
        whereArgs: [dateToday, 'Done'],
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list.length;
  }

  Future<List<Schedule>> getReminderScheduleList() async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String dateToday = dateFormat.format(DateTime.now());
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_DATE + ' = ? AND ' + constants.SQLiteConstants.KEY_STATUS + ' != ? AND ' + constants.SQLiteConstants.KEY_REMINDER + ' = ?',
        whereArgs: [dateToday, 'Done', 1],
        orderBy: constants.SQLiteConstants.KEY_START_TIME + ' ASC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list;
  }

  Future<List<Schedule>> getScheduleListByDate(DateTime dateTime) async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String date = dateFormat.format(dateTime);
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_DATE  + ' = ?',
        whereArgs: [date]
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list;
  }

  Future<int> getDoneScheduleCount() async {
    final db = await database;
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_STATUS + ' = ?',
        whereArgs: ['Done'],
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list.length;
  }

  Future<int> getToDoScheduleCount() async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String dateToday = dateFormat.format(DateTime.now());
    var result = await db.query(
      constants.SQLiteConstants.DB_SCHEDULE_TABLE,
      where: constants.SQLiteConstants.KEY_STATUS + ' != ? AND ' + constants.SQLiteConstants.KEY_DATE + ' >= ?',
      whereArgs: ['Done', dateToday],
      orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list.length;
  }

  Future<int> getOverDueScheduleCount() async {
    final db = await database;
    DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    String dateToday = dateFormat.format(DateTime.now());
    var result = await db.query(
        constants.SQLiteConstants.DB_SCHEDULE_TABLE,
        where: constants.SQLiteConstants.KEY_STATUS + ' != ? AND ' + constants.SQLiteConstants.KEY_DATE + ' < ?',
        whereArgs: ['Done', dateToday],
        orderBy: constants.SQLiteConstants.KEY_DATE + ' DESC'
    );
    List<Schedule> list = result.isNotEmpty ? result.map((s) => Schedule.fromMap(s)).toList() : [];
    return list.length;
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final db = await database;
    await db.update(
      constants.SQLiteConstants.DB_SCHEDULE_TABLE,
      schedule.toMap(),
      where: constants.SQLiteConstants.KEY_GUID + ' = ?', whereArgs: [schedule.guid]);
  }

  Future<void> deleteSchedule(String guid) async {
    final db = await database;
    await db.delete(
      constants.SQLiteConstants.DB_SCHEDULE_TABLE,
      where: constants.SQLiteConstants.KEY_GUID + ' = ?', whereArgs: [guid]);
  }

  Future<void> doneSchedule(String guid) async {
    final db = await database;
    Map<String, dynamic> toMap() => {
      constants.SQLiteConstants.KEY_STATUS : 'Done'
    };
    await db.update(
      constants.SQLiteConstants.DB_SCHEDULE_TABLE,
      toMap(),
      where:  constants.SQLiteConstants.KEY_GUID + ' = ?', whereArgs: [guid]);
  }
}