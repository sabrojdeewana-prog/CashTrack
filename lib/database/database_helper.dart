import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final instance = DatabaseHelper._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(
      await getDatabasesPath(),
      'cashtrack.db',
    );

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            note TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insert(CashTransaction tx) async {
    return (await database).insert(
      'transactions',
      tx.toMap(),
    );
  }

  Future<List<CashTransaction>> getAll() async {
    final rows = await (await database).query(
      'transactions',
      orderBy: 'date DESC',
    );

    return rows.map(CashTransaction.fromMap).toList();
  }

  Future<int> delete(int id) async {
    return (await database).delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> replaceAll(
    List<CashTransaction> transactions,
  ) async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete('transactions');

      for (final tx in transactions) {
        final map = Map<String, Object?>.from(tx.toMap());
        map.remove('id');

        await txn.insert(
          'transactions',
          map,
        );
      }
    });
  }
}
