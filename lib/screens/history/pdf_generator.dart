import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:milk_ledger/data/models/bill.dart';
import 'package:milk_ledger/core/extensions.dart';

class PdfGenerator {
  static Future<Uint8List> generateBillPdf(Bill bill, String symbol) async {
    final pdf = pw.Document();
    
    final String dateStr;
    if (bill.isCustomRange && bill.startDate != null && bill.endDate != null) {
      dateStr = '${DateFormat('dd MMM yyyy').format(bill.startDate!)} - ${DateFormat('dd MMM yyyy').format(bill.endDate!)}';
    } else {
      dateStr = DateFormat('MMMM yyyy').format(DateTime(bill.year, bill.month));
    }
    
    final issueDate = DateFormat('dd MMM yyyy').format(bill.savedAt);
    
    // We can load a font that supports Rupee symbol, 
    // but for simplicity, we'll try to use the default or a standard font.
    // If the symbol fails to render in standard font, it might show a box.
    // In production, we'd load a TTF font that supports the currency symbol.

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Text('MILK INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              
              // Meta info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Customer: ${bill.customerName}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Billing Month: $dateStr'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date Issued: $issueDate'),
                      pw.Text('Invoice ID: #${bill.id ?? 'DRAFT'}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              
              // Adjustments (if any)
              if (bill.adjustments != null && bill.adjustments!.isNotEmpty) ...[
                pw.Text('Exceptions / Adjustments:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.ListView.builder(
                  itemCount: bill.adjustments!.length,
                  itemBuilder: (context, index) {
                    final date = bill.adjustments!.keys.elementAt(index);
                    final qty = bill.adjustments![date]!;
                    final isAbsent = qty == 0;
                    return pw.Text('- ${DateFormat('dd MMM').format(date)}: ${isAbsent ? 'Absent (0 L)' : '${qty.toDisplayString()} L'}');
                  },
                ),
                pw.SizedBox(height: 20),
              ],
              
              // Table
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(width: 1, color: PdfColors.grey300),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
                cellAlignment: pw.Alignment.centerRight,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                },
                data: <List<String>>[
                  ['Description', 'Rate', 'Quantity/Days', 'Amount'],
                  [
                    'Total Milk Supply',
                    '$symbol${bill.milkRate.toDisplayString()}/L',
                    '${bill.totalMilk.toDisplayString()} L',
                    '$symbol${bill.milkCharges.toStringAsFixed(2)}',
                  ],
                  [
                    'Delivery Charges',
                    '$symbol${bill.dailyDeliveryCharge.toDisplayString()}/day',
                    '${(bill.deliveryCharges / (bill.dailyDeliveryCharge == 0 ? 1 : bill.dailyDeliveryCharge)).round()} days',
                    '$symbol${bill.deliveryCharges.toStringAsFixed(2)}',
                  ],
                ],
              ),
              
              pw.SizedBox(height: 20),
              
              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Grand Total: ', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text('$symbol${bill.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
                ],
              ),
              
              pw.Spacer(),
              
              // Footer
              pw.Center(
                child: pw.Text('Generated by Milk Ledger App', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
