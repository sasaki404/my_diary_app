import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_diary_app/data/diary_entry.dart';

class DatabaseHelper {
  static final _databaseName = 'diary.db';
  static final _databaseVersion = 1;

  static final table = 'diary';

  static final columnId = 'id';
  static final columnDate = 'date';
  static final columnMemo = 'memo';
  static final columnMood = 'mood';

  // This is a singleton class, meaning that it can only be instantiated once.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only a single app-wide reference to the database.
  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  // Opens the database and creates the 'diary' table if it doesn't exist.
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Creates the 'diary' table.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnDate TEXT NOT NULL,
            $columnMemo TEXT NOT NULL,
            $columnMood TEXT NOT NULL
          )
          ''');
  }

  // Inserts a new diary entry into the database.
  Future<int> insert(DiaryEntry entry) async {
    Database db = await instance.database;
    return await db.insert(table, entry.toMap());
  }

  // Retrieves all diary entries from the database.
  Future<List<DiaryEntry>> getAllEntries() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table, orderBy: columnDate);
    return List.generate(maps.length, (i) {
      return DiaryEntry.fromMap(maps[i]);
    });
  }

  // Deletes a diary entry from the database.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Updates a diary entry in the database.
  Future<int> update(DiaryEntry entry) async {
    Database db = await instance.database;
    return await db.update(table, entry.toMap(),
        where: '$columnId = ?', whereArgs: [entry.id]);
  }
}
