import 'package:flutter/foundation.dart';
import 'package:milk_ledger/data/database.dart';
import 'package:milk_ledger/data/models/bill.dart';

class BillRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // In-memory fallback for Web testing
  int _mockIdCounter = 1;
  final List<Bill> _mockBills = [];

  Future<Bill> create(Bill bill) async {
    if (kIsWeb) {
      final newBill = bill.copyWith(id: _mockIdCounter++);
      _mockBills.add(newBill);
      return newBill;
    }
    final db = await _dbHelper.database;
    final id = await db.insert('bills', bill.toMap());
    return bill.copyWith(id: id);
  }

  Future<Bill?> getBill(int id) async {
    if (kIsWeb) {
      try {
        return _mockBills.firstWhere((b) => b.id == id);
      } catch (e) {
        return null;
      }
    }
    final db = await _dbHelper.database;
    final maps = await db.query(
      'bills',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Bill.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Bill>> getAllBills() async {
    if (kIsWeb) {
      final list = List<Bill>.from(_mockBills);
      list.sort((a, b) {
        int cmp = b.year.compareTo(a.year);
        if (cmp != 0) return cmp;
        cmp = b.month.compareTo(a.month);
        if (cmp != 0) return cmp;
        return b.savedAt.compareTo(a.savedAt);
      });
      return list;
    }
    final db = await _dbHelper.database;
    // Order by year DESC, month DESC, then savedAt DESC
    const orderBy = 'year DESC, month DESC, savedAt DESC';
    final result = await db.query('bills', orderBy: orderBy);

    return result.map((json) => Bill.fromMap(json)).toList();
  }

  Future<List<Bill>> getBillsByCustomer(int customerId) async {
    if (kIsWeb) {
      final list = _mockBills.where((b) => b.customerId == customerId).toList();
      list.sort((a, b) {
        int cmp = b.year.compareTo(a.year);
        if (cmp != 0) return cmp;
        return b.month.compareTo(a.month);
      });
      return list;
    }
    final db = await _dbHelper.database;
    final result = await db.query(
      'bills',
      where: 'customerId = ?',
      whereArgs: [customerId],
      orderBy: 'year DESC, month DESC',
    );

    return result.map((json) => Bill.fromMap(json)).toList();
  }

  Future<int> update(Bill bill) async {
    if (kIsWeb) {
      final index = _mockBills.indexWhere((b) => b.id == bill.id);
      if (index != -1) {
        _mockBills[index] = bill;
        return 1;
      }
      return 0;
    }
    final db = await _dbHelper.database;
    return db.update(
      'bills',
      bill.toMap(),
      where: 'id = ?',
      whereArgs: [bill.id],
    );
  }

  Future<int> delete(int id) async {
    if (kIsWeb) {
      _mockBills.removeWhere((b) => b.id == id);
      return 1;
    }
    final db = await _dbHelper.database;
    return await db.delete(
      'bills',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
