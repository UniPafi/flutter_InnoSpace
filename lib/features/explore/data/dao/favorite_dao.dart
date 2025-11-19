import 'package:flutter_innospace/core/constants/database_constants.dart';
import 'package:flutter_innospace/core/databases/app_database.dart';
import 'package:flutter_innospace/features/explore/data/models/favorite_project_entity.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDao {
  
  Future<void> insert(FavoriteProjectEntity entity) async {
    final Database db = await AppDatabase().database;
    await db.insert(
      DatabaseConstants.favoriteProjectsTable, 
      entity.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(int id) async {
    final Database db = await AppDatabase().database;
    await db.delete(
      DatabaseConstants.favoriteProjectsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(int id) async {
    final Database db = await AppDatabase().database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.favoriteProjectsTable,
      where: "id = ?",
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

Future<List<int>> fetchAllIds() async {
  final Database db = await AppDatabase().database;
  final List<Map<String, dynamic>> maps = await db.query(
    DatabaseConstants.favoriteProjectsTable,
    columns: ['id'],
  );
  return maps.map((map) => map['id'] as int).toList();
}

}