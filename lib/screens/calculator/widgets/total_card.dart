import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/core/theme.dart';
import 'package:milk_ledger/core/extensions.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:milk_ledger/providers/settings_provider.dart';

class TotalCard extends StatelessWidget {
  const TotalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final symbol = context.select((SettingsProvider s) => s.settings.currencySymbol);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      color: isDark ? AppTheme.darkGreenBg : AppTheme.lightGreenBg,
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Consumer<CalculatorProvider>(
          builder: (context, calc, child) {
            return Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calculate, color: AppTheme.primaryGreen),
                    SizedBox(width: 8),
                    Text(
                      'Month End Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    calc.monthEndTotal.toCurrency(symbol),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppTheme.primaryGreen,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
