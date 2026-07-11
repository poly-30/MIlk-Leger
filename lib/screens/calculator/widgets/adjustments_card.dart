import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/core/extensions.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'adjustment_dialog.dart';

class AdjustmentsCard extends StatelessWidget {
  const AdjustmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Consumer<CalculatorProvider>(
          builder: (context, calc, child) {
            final adjustments = calc.adjustments;
            
            // Sort by date for display
            final sortedDates = adjustments.keys.toList()
              ..sort((a, b) => a.compareTo(b));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Exceptions & Adjustments', 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    if (adjustments.isNotEmpty)
                      Chip(
                        label: Text('${adjustments.length} days'),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      ),
                  ],
                ),
                if (adjustments.isEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'No exceptions this month. (e.g. absent days or extra milk)',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ],
                if (adjustments.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final date = sortedDates[index];
                      final qty = adjustments[date]!;
                      final isAbsent = qty == 0;
                      
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: Icon(
                          isAbsent ? Icons.event_busy : Icons.event_available,
                          color: isAbsent ? Colors.red : Colors.green,
                        ),
                        title: Text(DateFormat('dd MMM').format(date)),
                        subtitle: Text(
                          isAbsent ? 'Absent (0 L)' : 'Custom: ${qty.toDisplayString()} L',
                          style: TextStyle(
                            color: isAbsent ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => calc.removeAdjustment(date),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (context) => AdjustmentDialog(
                        month: calc.month,
                        year: calc.year,
                      ),
                    );
                    if (result != null) {
                      calc.addAdjustment(result['date'] as DateTime, result['quantity'] as double);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Exception (Absent/Extra)'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
