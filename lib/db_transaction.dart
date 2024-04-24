import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tugas_besar/m_transaction.dart' as MyTransaction; // aliasing to avoid conflicts

class TransactionDatabase {
  static final TransactionDatabase _instance = TransactionDatabase._internal();
  factory TransactionDatabase() => _instance;

  static late Database _db;

  TransactionDatabase._internal();

  Future<void> initDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'transactions.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Transactions(
            id INTEGER PRIMARY KEY,
            customerName TEXT,
            itemName TEXT,
            itemBrand TEXT,
            itemPrice INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> insertTransaction(MyTransaction.Transaction transaction) async { // using fully qualified name
    return await _db.insert('Transactions', transaction.toMap());
  }

  Future<List<MyTransaction.Transaction>> getTransactions() async { // using fully qualified name
    final List<Map<String, dynamic>> maps = await _db.query('Transactions');
    return List.generate(maps.length, (i) {
      return MyTransaction.Transaction.fromMap(maps[i]); // using fully qualified name
    });
  }

  Future<int> updateTransaction(MyTransaction.Transaction transaction) async { // using fully qualified name
    return await _db.update(
      'Transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    return await _db.delete(
      'Transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
