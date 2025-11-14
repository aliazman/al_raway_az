import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static const _dbName = 'al_raway.db';
  static const _dbVersion = 1;

  late final Database _database;

  Database get db => _database;

  DatabaseService._();

  static Future<DatabaseService> init() async {
    final service = DatabaseService._();
    final path = join(await getDatabasesPath(), _dbName);
    service._database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            type TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        await database.execute('''
          CREATE TABLE sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            account_id INTEGER NOT NULL,
            quantity REAL NOT NULL,
            price_per_unit REAL NOT NULL,
            created_at TEXT NOT NULL,
            note TEXT,
            FOREIGN KEY(account_id) REFERENCES accounts(id) ON DELETE CASCADE
          )
        ''');
        await database.execute('''
          CREATE TABLE activation (
            id INTEGER PRIMARY KEY,
            device_code TEXT NOT NULL,
            activated_until TEXT
          )
        ''');
        await database.insert('activation', {
          'id': 1,
          'device_code': generateDeviceCodeSeed(),
          'activated_until': null,
        });
      },
    );
    return service;
  }

  Future<List<Map<String, dynamic>>> queryAccounts() async {
    return db.query('accounts', orderBy: 'name COLLATE NOCASE');
  }

  Future<int> insertAccount(Map<String, dynamic> data) async {
    return db.insert('accounts', data);
  }

  Future<int> deleteAccount(int id) async {
    return db.delete('accounts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> querySalesByAccount(int accountId) {
    return db.query(
      'sales',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> queryJournalEntries() {
    return db.rawQuery('''
      SELECT sales.*, accounts.name AS account_name, accounts.type AS account_type
      FROM sales
      INNER JOIN accounts ON accounts.id = sales.account_id
      ORDER BY created_at DESC
    ''');
  }

  Future<int> insertSale(Map<String, dynamic> data) {
    return db.insert('sales', data);
  }

  Future<int> salesCount() async {
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM sales');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, dynamic>?> readActivation() async {
    final result = await db.query('activation', where: 'id = 1');
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<void> updateActivation(Map<String, dynamic> data) async {
    await db.update('activation', data, where: 'id = 1');
  }

  static String generateDeviceCodeSeed() {
    final now = DateTime.now();
    return 'AR-${now.year}${now.month}${now.day}${now.millisecondsSinceEpoch % 10000}';
  }
}
