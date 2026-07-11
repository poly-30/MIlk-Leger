import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/app.dart';
import 'package:milk_ledger/data/repositories/settings_repository.dart';
import 'package:milk_ledger/data/repositories/customer_repository.dart';
import 'package:milk_ledger/data/repositories/bill_repository.dart';
import 'package:milk_ledger/providers/settings_provider.dart';
import 'package:milk_ledger/providers/customer_provider.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:milk_ledger/providers/history_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Repositories
  final settingsRepo = SettingsRepository();
  final customerRepo = CustomerRepository();
  final billRepo = BillRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(settingsRepo)),
        ChangeNotifierProvider(create: (_) => CustomerProvider(customerRepo)),
        ChangeNotifierProvider(create: (_) => CalculatorProvider(billRepo)),
        ChangeNotifierProvider(create: (_) => HistoryProvider(billRepo)),
      ],
      child: const MilkLedgerApp(),
    ),
  );
}
