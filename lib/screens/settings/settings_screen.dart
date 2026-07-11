import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currencyController;
  late TextEditingController _rateController;
  late TextEditingController _supplyController;
  late TextEditingController _deliveryController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _currencyController = TextEditingController(text: settings.currencySymbol);
    _rateController = TextEditingController(text: settings.defaultMilkRate.toString());
    _supplyController = TextEditingController(text: settings.defaultDailySupply.toString());
    _deliveryController = TextEditingController(text: settings.defaultDeliveryCharge.toString());
  }

  @override
  void dispose() {
    _currencyController.dispose();
    _rateController.dispose();
    _supplyController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<SettingsProvider>();
      
      provider.updateCurrencySymbol(_currencyController.text.trim());
      provider.updateDefaultMilkRate(double.tryParse(_rateController.text) ?? 0.0);
      provider.updateDefaultDailySupply(double.tryParse(_supplyController.text) ?? 0.0);
      provider.updateDefaultDeliveryCharge(double.tryParse(_deliveryController.text) ?? 0.0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Appearance Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Appearance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      Consumer<SettingsProvider>(
                        builder: (context, provider, child) {
                          return SwitchListTile(
                            title: const Text('Dark Mode'),
                            subtitle: const Text('Switch between light and dark themes'),
                            value: provider.settings.isDarkMode,
                            onChanged: (value) {
                              provider.toggleTheme(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Defaults Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('App Defaults', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('These values will be pre-filled when you add a new customer or calculate a bill.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const Divider(),
                      const SizedBox(height: 8),
                      
                      TextFormField(
                        controller: _currencyController,
                        decoration: const InputDecoration(
                          labelText: 'Currency Symbol',
                          border: OutlineInputBorder(),
                          hintText: 'e.g. ₹, \$, £',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a symbol' : null,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      TextFormField(
                        controller: _rateController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Default Milk Rate (per Litre)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => (val == null || double.tryParse(val) == null) ? 'Invalid number' : null,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      TextFormField(
                        controller: _supplyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Default Daily Supply (Litres)',
                          border: OutlineInputBorder(),
                          suffixText: 'L',
                        ),
                        validator: (val) => (val == null || double.tryParse(val) == null) ? 'Invalid number' : null,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      TextFormField(
                        controller: _deliveryController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Default Daily Delivery Charge',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => (val == null || double.tryParse(val) == null) ? 'Invalid number' : null,
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Defaults'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // App Info
              const Center(
                child: Column(
                  children: [
                    Icon(Icons.water_drop, color: Colors.blue, size: 40),
                    SizedBox(height: 8),
                    Text('Milk Ledger App', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    Text('Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
