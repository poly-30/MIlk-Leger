import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdjustmentDialog extends StatefulWidget {
  final int month;
  final int year;
  
  const AdjustmentDialog({
    super.key,
    required this.month,
    required this.year,
  });

  @override
  State<AdjustmentDialog> createState() => _AdjustmentDialogState();
}

class _AdjustmentDialogState extends State<AdjustmentDialog> {
  late DateTime _selectedDate;
  final _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default to today if today is in the selected month/year, else 1st of month
    final now = DateTime.now();
    if (now.month == widget.month && now.year == widget.year) {
      _selectedDate = DateTime(now.year, now.month, now.day);
    } else {
      _selectedDate = DateTime(widget.year, widget.month, 1);
    }
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final firstDay = DateTime(widget.year, widget.month, 1);
    final lastDay = DateTime(widget.year, widget.month + 1, 0);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDay,
      lastDate: lastDay,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Adjustment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Date:', style: TextStyle(fontWeight: FontWeight.bold)),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month),
            label: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
          ),
          const SizedBox(height: 16),
          const Text('Milk Quantity (Litres):', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'e.g. 0 for Absent, or 3.5',
              border: OutlineInputBorder(),
              suffixText: 'L',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tip: Enter 0 if the milkman was absent.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final qty = double.tryParse(_qtyController.text);
            if (qty == null || qty < 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid quantity (0 or more)')),
              );
              return;
            }
            Navigator.pop(context, {'date': _selectedDate, 'quantity': qty});
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
