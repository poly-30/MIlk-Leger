import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:milk_ledger/providers/history_provider.dart';

class SaveBillButton extends StatelessWidget {
  const SaveBillButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
      child: ElevatedButton.icon(
        onPressed: () async {
          final calc = context.read<CalculatorProvider>();
          
          if (calc.milkRate <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a valid Milk Rate')),
            );
            return;
          }

          try {
            await calc.saveBill();
            
            // Refresh history
            if (context.mounted) {
              context.read<HistoryProvider>().loadAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bill saved to History successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error saving bill: $e'), backgroundColor: Colors.red),
              );
            }
          }
        },
        icon: const Icon(Icons.save),
        label: const Text('Save this Bill'),
      ),
    );
  }
}
