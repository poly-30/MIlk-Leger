import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/core/theme.dart';
import 'package:milk_ledger/core/extensions.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';

class SupplyDetailsCard extends StatelessWidget {
  const SupplyDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Consumer<CalculatorProvider>(
          builder: (context, calc, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Milk Supply Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppConstants.paddingMedium),
                
                // Stepper Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daily Avg (Litres):', style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            calc.setDailySupply(calc.dailySupply - 0.5);
                          },
                          icon: const Icon(Icons.remove_circle_outline, size: 32),
                          color: AppTheme.primaryBlue,
                        ),
                        Container(
                          width: 60,
                          alignment: Alignment.center,
                          child: Text(
                            calc.dailySupply.toDisplayString(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            calc.setDailySupply(calc.dailySupply + 0.5);
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 32),
                          color: AppTheme.primaryBlue,
                        ),
                      ],
                    ),
                  ],
                ),
                
                const Divider(height: AppConstants.paddingLarge),
                
                // Total Milk Computed
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Milk:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Text(
                      '${calc.totalMilk.toDisplayString()} L',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
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
