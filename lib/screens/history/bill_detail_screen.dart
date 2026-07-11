import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/core/extensions.dart';
import 'package:milk_ledger/data/models/bill.dart';
import 'package:milk_ledger/providers/settings_provider.dart';
import 'pdf_generator.dart';

class BillDetailScreen extends StatelessWidget {
  final Bill bill;

  const BillDetailScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final symbol = context.select((SettingsProvider s) => s.settings.currencySymbol);
    
    final String dateStr;
    if (bill.isCustomRange && bill.startDate != null && bill.endDate != null) {
      dateStr = '${DateFormat('dd MMM yyyy').format(bill.startDate!)} - ${DateFormat('dd MMM yyyy').format(bill.endDate!)}';
    } else {
      dateStr = DateFormat('MMMM yyyy').format(DateTime(bill.year, bill.month));
    }

    // Calculate delivery days safely
    int deliveryDays = bill.daysInMonth;
    if (bill.dailyDeliveryCharge > 0) {
      deliveryDays = (bill.deliveryCharges / bill.dailyDeliveryCharge).round();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share PDF',
            onPressed: () async {
              try {
                final pdfBytes = await PdfGenerator.generateBillPdf(bill, symbol);
                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: 'Milk_Bill_${bill.customerName}_$dateStr.pdf'.replaceAll(' ', '_'),
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error generating PDF: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Print',
            onPressed: () async {
              try {
                final pdfBytes = await PdfGenerator.generateBillPdf(bill, symbol);
                await Printing.layoutPdf(
                  onLayout: (format) async => pdfBytes,
                  name: 'Milk_Bill_${bill.customerName}_$dateStr.pdf',
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error printing PDF: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    const Icon(Icons.receipt, size: 48, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      bill.customerName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dateStr,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Adjustments
            if (bill.adjustments != null && bill.adjustments!.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Exceptions & Adjustments',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      ...bill.adjustments!.entries.map((entry) {
                        final isAbsent = entry.value == 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('dd MMM yyyy').format(entry.key)),
                              Text(
                                isAbsent ? 'Absent (0 L)' : '${entry.value.toDisplayString()} L',
                                style: TextStyle(
                                  color: isAbsent ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
            ],

            // Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Calculation Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildRow('Total Milk Supply', '${bill.totalMilk.toDisplayString()} L'),
                    _buildRow('Milk Rate', '$symbol${bill.milkRate.toDisplayString()}/L'),
                    _buildRow('Milk Charges', bill.milkCharges.toCurrency(symbol), isBold: true),
                    const SizedBox(height: 16),
                    _buildRow('Delivery Days', '$deliveryDays days'),
                    _buildRow('Delivery Rate', '$symbol${bill.dailyDeliveryCharge.toDisplayString()}/day'),
                    _buildRow('Delivery Charges', bill.deliveryCharges.toCurrency(symbol), isBold: true),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Total Card
            Card(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.green.shade900 
                  : Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    const Text('Grand Total', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(
                      bill.totalAmount.toCurrency(symbol),
                      style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
