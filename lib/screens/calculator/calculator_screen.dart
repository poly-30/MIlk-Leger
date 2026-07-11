import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:milk_ledger/providers/settings_provider.dart';

import 'widgets/customer_selector_card.dart';
import 'widgets/month_selector_card.dart';
import 'widgets/price_details_card.dart';
import 'widgets/supply_details_card.dart';
import 'widgets/adjustments_card.dart';
import 'widgets/total_card.dart';
import 'widgets/breakup_card.dart';
import 'widgets/save_bill_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  void initState() {
    super.initState();
    // Pre-fill with default settings when opening the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsProvider>().settings;
      context.read<CalculatorProvider>().applyDefaults(settings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Month End Total'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Calculator',
            onPressed: () {
              final calc = context.read<CalculatorProvider>();
              final settings = context.read<SettingsProvider>().settings;
              calc.reset();
              calc.applyDefaults(settings);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomerSelectorCard(),
              MonthSelectorCard(),
              PriceDetailsCard(),
              SupplyDetailsCard(),
              AdjustmentsCard(),
              TotalCard(),
              BreakupCard(),
              SaveBillButton(),
            ],
          ),
        ),
      ),
    );
  }
}
