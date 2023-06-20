import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Tarif.dart';

class DbUtils {
  static final DbUtils _dbUtils = DbUtils._internal();
  DbUtils._internal();

  factory DbUtils() {
    return _dbUtils;
  }
  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db!;
  }



  Future<Database> initializeDb() async {
    String path=join(await getDatabasesPath(), 'tarifler_database.db');
    var dbTarifler = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTarifler;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE tarifler(tarifname TEXT, yayinlayanName TEXT)");
  }

  Future<void> deleteTable() async {
    final Database db = await this.db;
    db.delete('tarifler');
  }

  Future<void> insertTarif(Tarif tarif) async {
    final Database db = await this.db;
    await db.insert(
      'tarifler',
      tarif.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tarif>> tarifler() async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query('tarifler');
    return List.generate(maps.length, (i) {
      return Tarif(
        tarifname: maps[i]['tarifname'],
        yayinlayanName:maps[i]['yayinlayanName'],
      );
    });
  }

  Future<void> updateTarif(Tarif tarif) async {
    final db = await this.db;
    await db.update(
      'tarifler',
      tarif.toMap(),
      where: "tarifname = ?",
      whereArgs: [tarif.tarifname],
    );
  }

  Future<void> deleteTarif(String tarifname) async {
    final db = await this.db;
    await db.delete(
      'tarifler',
      where: "tarifname = ?",
      whereArgs: [tarifname],
    );
  }



}