import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)');
  }

  Future<int> saveUser(String username, String password) async {
    var client = await db;
    return client!.insert('User', {'username': username, 'password': password});
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    var client = await db;
    return client!.query('User');
  }
}
