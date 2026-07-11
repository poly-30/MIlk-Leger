import 'package:flutter/material.dart';
import 'package:milk_ledger/data/models/bill.dart';
import 'package:milk_ledger/data/repositories/bill_repository.dart';
import 'package:milk_ledger/core/extensions.dart'; // We can use this later for formatting group keys

class HistoryProvider extends ChangeNotifier {
  final BillRepository _repository;

  List<Bill> _bills = [];
  bool _isLoading = true;

  HistoryProvider(this._repository) {
    loadAll();
  }

  List<Bill> get bills => _bills;
  bool get isLoading => _isLoading;

  // Group bills by 'Month YYYY' for the UI
  Map<String, List<Bill>> get groupedBills {
    final Map<String, List<Bill>> map = {};
    for (var bill in _bills) {
      final date = DateTime(bill.year, bill.month);
      final key = date.toMonthYear(); // 'Oct 2023'
      
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(bill);
    }
    return map;
  }

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();

    _bills = await _repository.getAllBills();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadByCustomer(int customerId) async {
    _isLoading = true;
    notifyListeners();

    _bills = await _repository.getBillsByCustomer(customerId);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteBill(int id) async {
    await _repository.delete(id);
    await loadAll(); // refresh list
  }
}
