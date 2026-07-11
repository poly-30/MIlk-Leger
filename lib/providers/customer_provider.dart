import 'package:flutter/material.dart';
import 'package:milk_ledger/data/models/customer.dart';
import 'package:milk_ledger/data/repositories/customer_repository.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _repository;
  
  List<Customer> _customers = [];
  bool _isLoading = true;
  Customer? _selectedCustomer;

  CustomerProvider(this._repository) {
    loadAll();
  }

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  Customer? get selectedCustomer => _selectedCustomer;

  Future<void> loadAll() async {
    _isLoading = true;
    notifyListeners();

    _customers = await _repository.getAllCustomers();
    
    // Validate if selected customer still exists
    if (_selectedCustomer != null && !_customers.any((c) => c.id == _selectedCustomer!.id)) {
      _selectedCustomer = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    await _repository.create(customer);
    await loadAll();
  }

  Future<void> updateCustomer(Customer customer) async {
    await _repository.update(customer);
    
    // Update selected customer if it was the one modified
    if (_selectedCustomer?.id == customer.id) {
      _selectedCustomer = customer;
    }
    
    await loadAll();
  }

  Future<void> deleteCustomer(int id) async {
    await _repository.delete(id);
    await loadAll();
  }

  void selectCustomer(Customer? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }
}
