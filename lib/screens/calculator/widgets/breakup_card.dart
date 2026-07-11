import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/core/extensions.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:milk_ledger/providers/settings_provider.dart';

class BreakupCard extends StatelessWidget {
  const BreakupCard({super.key});

  @override
  Widget build(BuildContext context) {
    final symbol = context.select((SettingsProvider s) => s.settings.currencySymbol);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Consumer<CalculatorProvider>(
          builder: (context, calc, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Calculation Breakup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 12),
                
                // Milk Charges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Milk: ${calc.totalMilk.toDisplayString()}L × $symbol${calc.milkRate.toDisplayString()}'),
                    Text(calc.milkCharges.toCurrency(symbol)),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Delivery Charges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery: ${calc.deliveryDays}d × $symbol${calc.dailyDeliveryCharge.toDisplayString()}'),
                    Text(calc.deliveryCharges.toCurrency(symbol)),
                  ],
                ),
                
                const Divider(height: 24, thickness: 1),
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      calc.monthEndTotal.toCurrency(symbol),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
