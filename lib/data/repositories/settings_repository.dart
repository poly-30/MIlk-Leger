import 'package:shared_preferences/shared_preferences.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/data/models/settings.dart';

class SettingsRepository {
  static const String _keyMilkRate = 'defaultMilkRate';
  static const String _keyDailySupply = 'defaultDailySupply';
  static const String _keyDeliveryCharge = 'defaultDeliveryCharge';
  static const String _keyCurrencySymbol = 'currencySymbol';
  static const String _keyIsDarkMode = 'isDarkMode';

  Future<AppSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    return AppSettings(
      defaultMilkRate: prefs.getDouble(_keyMilkRate) ?? AppConstants.defaultMilkRate,
      defaultDailySupply: prefs.getDouble(_keyDailySupply) ?? AppConstants.defaultDailySupply,
      defaultDeliveryCharge: prefs.getDouble(_keyDeliveryCharge) ?? AppConstants.defaultDeliveryCharge,
      currencySymbol: prefs.getString(_keyCurrencySymbol) ?? AppConstants.defaultCurrencySymbol,
      isDarkMode: prefs.getBool(_keyIsDarkMode) ?? false,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setDouble(_keyMilkRate, settings.defaultMilkRate);
    await prefs.setDouble(_keyDailySupply, settings.defaultDailySupply);
    await prefs.setDouble(_keyDeliveryCharge, settings.defaultDeliveryCharge);
    await prefs.setString(_keyCurrencySymbol, settings.currencySymbol);
    await prefs.setBool(_keyIsDarkMode, settings.isDarkMode);
  }
}
