import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_innospace/core/constants/database_constants.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase _instance = AppDatabase._();

  factory AppDatabase() {
    return _instance;
  }

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database as Database;
  }

  Future<Database> _initDatabase() async {
    final String path = join(
      await getDatabasesPath(),
      DatabaseConstants.databaseName,
    );
  
  return await openDatabase(
  path,
  version: DatabaseConstants.databaseVersion,
  onCreate: (db, version) {
   
    db.execute('''CREATE TABLE ${DatabaseConstants.favoriteProjectsTable} (
      id INTEGER PRIMARY KEY)'''); 
  },
  
);
  }
}