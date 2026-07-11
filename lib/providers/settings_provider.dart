import 'package:flutter/material.dart';
import 'package:milk_ledger/data/models/settings.dart';
import 'package:milk_ledger/data/repositories/settings_repository.dart';
import 'package:milk_ledger/core/constants.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository;
  
  AppSettings _settings = AppSettings(
    defaultMilkRate: AppConstants.defaultMilkRate,
    defaultDailySupply: AppConstants.defaultDailySupply,
    defaultDeliveryCharge: AppConstants.defaultDeliveryCharge,
    currencySymbol: AppConstants.defaultCurrencySymbol,
    isDarkMode: false,
  );

  bool _isLoading = true;

  SettingsProvider(this._repository) {
    _loadSettings();
  }

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _repository.getSettings();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _repository.saveSettings(newSettings);
  }

  Future<void> toggleTheme(bool isDark) async {
    await updateSettings(_settings.copyWith(isDarkMode: isDark));
  }

  Future<void> updateCurrencySymbol(String symbol) async {
    await updateSettings(_settings.copyWith(currencySymbol: symbol));
  }

  Future<void> updateDefaultMilkRate(double rate) async {
    await updateSettings(_settings.copyWith(defaultMilkRate: rate));
  }

  Future<void> updateDefaultDailySupply(double supply) async {
    await updateSettings(_settings.copyWith(defaultDailySupply: supply));
  }

  Future<void> updateDefaultDeliveryCharge(double charge) async {
    await updateSettings(_settings.copyWith(defaultDeliveryCharge: charge));
  }
}
