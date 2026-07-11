import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('milk_ledger.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      // Use web implementation (IndexedDB)
      var factory = databaseFactoryFfiWeb;
      return await factory.openDatabase(
        filePath, 
        options: OpenDatabaseOptions(
          version: 2, 
          onCreate: _createDB,
          onUpgrade: _upgradeDB,
        )
      );
    } else {
      // Use native mobile/desktop implementation
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      );
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const nullableIntegerType = 'INTEGER';

    await db.execute('''
CREATE TABLE customers (
  id $idType,
  name $textType,
  defaultMilkRate $realType,
  defaultDailySupply $realType,
  defaultDeliveryCharge $realType,
  createdAt $textType
)
''');

    await db.execute('''
CREATE TABLE bills (
  id $idType,
  customerId $nullableIntegerType,
  customerName $textType,
  month $integerType,
  year $integerType,
  milkRate $realType,
  dailyDeliveryCharge $realType,
  dailySupply $realType,
  daysInMonth $integerType,
  totalMilk $realType,
  milkCharges $realType,
  deliveryCharges $realType,
  totalAmount $realType,
  savedAt $textType,
  adjustments TEXT,
  startDate TEXT,
  endDate TEXT,
  isCustomRange INTEGER,
  FOREIGN KEY (customerId) REFERENCES customers (id) ON DELETE SET NULL
)
''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE bills ADD COLUMN startDate TEXT');
      await db.execute('ALTER TABLE bills ADD COLUMN endDate TEXT');
      await db.execute('ALTER TABLE bills ADD COLUMN isCustomRange INTEGER DEFAULT 0');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
