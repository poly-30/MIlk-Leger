import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:milk_ledger/providers/settings_provider.dart';

class PriceDetailsCard extends StatefulWidget {
  const PriceDetailsCard({super.key});

  @override
  State<PriceDetailsCard> createState() => _PriceDetailsCardState();
}

class _PriceDetailsCardState extends State<PriceDetailsCard> {
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _deliveryController = TextEditingController();
  final FocusNode _rateFocusNode = FocusNode();
  final FocusNode _deliveryFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _rateFocusNode.addListener(() {
      if (_rateFocusNode.hasFocus) {
        _rateController.selection = TextSelection(baseOffset: 0, extentOffset: _rateController.text.length);
      }
    });
    _deliveryFocusNode.addListener(() {
      if (_deliveryFocusNode.hasFocus) {
        _deliveryController.selection = TextSelection(baseOffset: 0, extentOffset: _deliveryController.text.length);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final calc = Provider.of<CalculatorProvider>(context);
    
    // Only update controller text if it differs (to avoid cursor jumping)
    if (_rateController.text != calc.milkRate.toString()) {
      _rateController.text = calc.milkRate == 0 ? '' : calc.milkRate.toString();
    }
    if (_deliveryController.text != calc.dailyDeliveryCharge.toString()) {
      _deliveryController.text = calc.dailyDeliveryCharge == 0 ? '' : calc.dailyDeliveryCharge.toString();
    }
  }

  @override
  void dispose() {
    _rateFocusNode.dispose();
    _deliveryFocusNode.dispose();
    _rateController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final symbol = context.select((SettingsProvider s) => s.settings.currencySymbol);
    final calc = context.read<CalculatorProvider>();

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Price Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppConstants.paddingMedium),
            
            TextFormField(
              controller: _rateController,
              focusNode: _rateFocusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Milk Rate (per Litre)',
                prefixText: '$symbol ',
                border: const OutlineInputBorder(),
              ),
              onChanged: (val) {
                calc.setMilkRate(double.tryParse(val) ?? 0.0);
              },
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            TextFormField(
              controller: _deliveryController,
              focusNode: _deliveryFocusNode,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Daily Fixed Delivery Charge',
                prefixText: '$symbol ',
                border: const OutlineInputBorder(),
                suffixIcon: const Tooltip(
                  message: 'Charged per day regardless of milk quantity',
                  child: Icon(Icons.info_outline),
                ),
              ),
              onChanged: (val) {
                calc.setDailyDeliveryCharge(double.tryParse(val) ?? 0.0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
