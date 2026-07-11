import 'package:flutter/material.dart';
import 'package:milk_ledger/data/models/bill.dart';
import 'package:milk_ledger/data/models/customer.dart';
import 'package:milk_ledger/data/models/settings.dart';
import 'package:milk_ledger/data/repositories/bill_repository.dart';

class CalculatorProvider extends ChangeNotifier {
  final BillRepository _repository;

  // Selected date
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;
  
  // Custom date range
  bool _isCustomRange = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  // Inputs
  double _milkRate = 0;
  double _dailySupply = 0;
  double _dailyDeliveryCharge = 0;
  
  // Selected Customer (if any)
  Customer? _selectedCustomer;

  // Daily Adjustments (Exceptions)
  final Map<DateTime, double> _adjustments = {};

  CalculatorProvider(this._repository);

  // Getters
  int get month => _month;
  int get year => _year;
  bool get isCustomRange => _isCustomRange;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  double get milkRate => _milkRate;
  double get dailySupply => _dailySupply;
  double get dailyDeliveryCharge => _dailyDeliveryCharge;
  Customer? get selectedCustomer => _selectedCustomer;
  Map<DateTime, double> get adjustments => Map.unmodifiable(_adjustments);

  // Computed Values
  int get daysInRange {
    if (_isCustomRange) {
      // +1 to include both start and end days
      final end = DateTime(_endDate.year, _endDate.month, _endDate.day);
      final start = DateTime(_startDate.year, _startDate.month, _startDate.day);
      return end.difference(start).inDays + 1;
    }
    return DateTime(_year, _month + 1, 0).day;
  }

  List<DateTime> get _dateList {
    List<DateTime> dates = [];
    if (_isCustomRange) {
      DateTime current = DateTime(_startDate.year, _startDate.month, _startDate.day);
      DateTime end = DateTime(_endDate.year, _endDate.month, _endDate.day);
      while (current.isBefore(end.add(const Duration(days: 1)))) {
        dates.add(current);
        current = current.add(const Duration(days: 1));
      }
    } else {
      for (int i = 1; i <= daysInRange; i++) {
        dates.add(DateTime(_year, _month, i));
      }
    }
    return dates;
  }
  
  double get totalMilk {
    double total = 0;
    for (var date in _dateList) {
      total += _adjustments.containsKey(date) ? _adjustments[date]! : _dailySupply;
    }
    return total;
  }

  double get milkCharges => totalMilk * _milkRate;
  
  int get deliveryDays {
    int count = 0;
    for (var date in _dateList) {
      final milkToday = _adjustments.containsKey(date) ? _adjustments[date]! : _dailySupply;
      if (milkToday > 0) {
        count++;
      }
    }
    return count;
  }

  double get deliveryCharges {
    return deliveryDays * _dailyDeliveryCharge;
  }
  
  double get monthEndTotal => milkCharges + deliveryCharges;

  // Setters
  void setDate(int month, int year) {
    _month = month;
    _year = year;
    _isCustomRange = false;
    _adjustments.clear(); // Reset adjustments on month change
    notifyListeners();
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    _startDate = start;
    _endDate = end;
    _isCustomRange = true;
    _adjustments.clear(); // Reset adjustments on range change
    notifyListeners();
  }

  void setMilkRate(double rate) {
    _milkRate = rate;
    notifyListeners();
  }

  void setDailySupply(double supply) {
    _dailySupply = supply > 0 ? supply : 0;
    notifyListeners();
  }

  void setDailyDeliveryCharge(double charge) {
    _dailyDeliveryCharge = charge;
    notifyListeners();
  }

  void addAdjustment(DateTime date, double quantity) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _adjustments[normalizedDate] = quantity > 0 ? quantity : 0;
    notifyListeners();
  }

  void removeAdjustment(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _adjustments.remove(normalizedDate);
    notifyListeners();
  }

  // Pre-fill from defaults or customer
  void applyDefaults(AppSettings settings) {
    if (_selectedCustomer == null) {
      _milkRate = settings.defaultMilkRate;
      _dailySupply = settings.defaultDailySupply;
      _dailyDeliveryCharge = settings.defaultDeliveryCharge;
      notifyListeners();
    }
  }

  void applyCustomer(Customer? customer) {
    _selectedCustomer = customer;
    if (customer != null) {
      _milkRate = customer.defaultMilkRate;
      _dailySupply = customer.defaultDailySupply;
      _dailyDeliveryCharge = customer.defaultDeliveryCharge;
    }
    notifyListeners();
  }

  void reset() {
    _selectedCustomer = null;
    _adjustments.clear();
    notifyListeners();
  }

  // Save the calculated bill
  Future<Bill> saveBill() async {
    final bill = Bill(
      customerId: _selectedCustomer?.id,
      customerName: _selectedCustomer?.name ?? 'Self',
      month: _month,
      year: _year,
      milkRate: _milkRate,
      dailyDeliveryCharge: _dailyDeliveryCharge,
      dailySupply: _dailySupply,
      daysInMonth: daysInRange, // Maps correctly to old property for backwards compatibility
      totalMilk: totalMilk,
      milkCharges: milkCharges,
      deliveryCharges: deliveryCharges,
      totalAmount: monthEndTotal,
      savedAt: DateTime.now(),
      adjustments: _adjustments.isNotEmpty ? Map.from(_adjustments) : null,
      isCustomRange: _isCustomRange,
      startDate: _isCustomRange ? _startDate : null,
      endDate: _isCustomRange ? _endDate : null,
    );

    return await _repository.create(bill);
  }
}
