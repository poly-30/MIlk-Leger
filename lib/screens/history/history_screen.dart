import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/core/extensions.dart';
import 'package:milk_ledger/providers/history_provider.dart';
import 'package:milk_ledger/providers/settings_provider.dart';
import 'bill_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final symbol = context.select((SettingsProvider s) => s.settings.currencySymbol);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Bills'),
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bills.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No saved bills yet',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Calculate and save a bill to see it here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: provider.bills.length,
            itemBuilder: (context, index) {
              final bill = provider.bills[index];
              final String dateStr;
              if (bill.isCustomRange && bill.startDate != null && bill.endDate != null) {
                dateStr = '${DateFormat('dd MMM').format(bill.startDate!)} - ${DateFormat('dd MMM yy').format(bill.endDate!)}';
              } else {
                dateStr = DateFormat('MMMM yyyy').format(DateTime(bill.year, bill.month));
              }
              return Dismissible(
                key: Key(bill.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text('Are you sure you wish to delete this saved bill?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  provider.deleteBill(bill.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bill for $dateStr deleted')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: const Icon(Icons.receipt_long),
                    ),
                    title: Text('${bill.customerName} - $dateStr', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Milk: ${bill.totalMilk.toDisplayString()}L',
                    ),
                    trailing: Text(
                      bill.totalAmount.toCurrency(symbol),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillDetailScreen(bill: bill),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
