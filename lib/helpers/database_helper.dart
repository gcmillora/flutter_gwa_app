import 'dart:io';

import 'package:flutter_application_1/models/subject_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instace();
  static Database _db;

  DatabaseHelper._instace();

  String subjectTables = 'subject_Tables';
  String colId = 'id';
  String colTitle = 'title';
  String colUnit = 'unit';
  String colGrade = 'grade';

  //Subject Tables
  // Id || Title || Unit || Grade
  // 0      ''       ''       ''
  // 1      ''       ''       ''
  // 2      ''       ''       ''

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'subject_list.db';
    final subjectListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return subjectListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $subjectTables($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colUnit TEXT, $colGrade TEXT)',
    );
  }

  Future<List<Map<String, dynamic>>> getSubjectMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(subjectTables);
    return result;
  }

  Future<List<Subject>> getSubjectList() async {
    final List<Map<String, dynamic>> subjectMapList = await getSubjectMapList();
    final List<Subject> subjectList = [];
    subjectMapList.forEach((subjectMap) {
      subjectList.add(Subject.fromMap(subjectMap));
    });
    subjectList
        .sort((subjectA, subjectB) => subjectA.title.compareTo(subjectB.title));
    return subjectList;
  }

  Future<int> insertSubject(Subject subject) async {
    Database db = await this.db;
    final int result = await db.insert(subjectTables, subject.toMap());
    return result;
  }

  Future<int> updateSubject(Subject subject) async {
    Database db = await this.db;
    final int result = await db.update(subjectTables, subject.toMap(),
        where: '$colId = ?', whereArgs: [subject.id]);
    return result;
  }

  Future<int> deleteSubject(int id) async {
    Database db = await this.db;
    final int result =
        await db.delete(subjectTables, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
