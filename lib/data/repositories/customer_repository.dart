import 'package:flutter/foundation.dart';
import 'package:milk_ledger/data/database.dart';
import 'package:milk_ledger/data/models/customer.dart';

class CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // In-memory fallback for Web testing
  int _mockIdCounter = 1;
  final List<Customer> _mockCustomers = [];

  Future<Customer> create(Customer customer) async {
    if (kIsWeb) {
      final newCustomer = customer.copyWith(id: _mockIdCounter++);
      _mockCustomers.add(newCustomer);
      return newCustomer;
    }
    final db = await _dbHelper.database;
    final id = await db.insert('customers', customer.toMap());
    return customer.copyWith(id: id);
  }

  Future<Customer?> getCustomer(int id) async {
    if (kIsWeb) {
      try {
        return _mockCustomers.firstWhere((c) => c.id == id);
      } catch (e) {
        return null;
      }
    }
    final db = await _dbHelper.database;
    final maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    if (kIsWeb) {
      final list = List<Customer>.from(_mockCustomers);
      list.sort((a, b) => a.name.compareTo(b.name));
      return list;
    }
    final db = await _dbHelper.database;
    const orderBy = 'name ASC';
    final result = await db.query('customers', orderBy: orderBy);

    return result.map((json) => Customer.fromMap(json)).toList();
  }

  Future<int> update(Customer customer) async {
    if (kIsWeb) {
      final index = _mockCustomers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        _mockCustomers[index] = customer;
        return 1;
      }
      return 0;
    }
    final db = await _dbHelper.database;
    return db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> delete(int id) async {
    if (kIsWeb) {
      _mockCustomers.removeWhere((c) => c.id == id);
      return 1;
    }
    final db = await _dbHelper.database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
