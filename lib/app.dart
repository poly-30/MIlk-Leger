import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/theme.dart';
import 'package:milk_ledger/providers/settings_provider.dart';
import 'package:milk_ledger/screens/main_scaffold.dart';

class MilkLedgerApp extends StatelessWidget {
  const MilkLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'Milk Ledger',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settingsProvider.settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainScaffold(),
        );
      },
    );
  }
}
