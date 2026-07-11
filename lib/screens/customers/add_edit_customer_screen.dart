import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/data/models/customer.dart';
import 'package:milk_ledger/providers/customer_provider.dart';
import 'package:milk_ledger/providers/settings_provider.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _rateController;
  late TextEditingController _supplyController;
  late TextEditingController _deliveryController;
  
  final FocusNode _rateFocusNode = FocusNode();
  final FocusNode _supplyFocusNode = FocusNode();
  final FocusNode _deliveryFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Use existing customer or fallback to global default settings
    final settings = context.read<SettingsProvider>().settings;
    
    _nameController = TextEditingController(text: widget.customer?.name ?? '');
    _rateController = TextEditingController(
      text: (widget.customer?.defaultMilkRate ?? settings.defaultMilkRate).toString(),
    );
    _supplyController = TextEditingController(
      text: (widget.customer?.defaultDailySupply ?? settings.defaultDailySupply).toString(),
    );
    _deliveryController = TextEditingController(
      text: (widget.customer?.defaultDeliveryCharge ?? settings.defaultDeliveryCharge).toString(),
    );

    _rateFocusNode.addListener(() {
      if (_rateFocusNode.hasFocus) {
        _rateController.selection = TextSelection(baseOffset: 0, extentOffset: _rateController.text.length);
      }
    });
    _supplyFocusNode.addListener(() {
      if (_supplyFocusNode.hasFocus) {
        _supplyController.selection = TextSelection(baseOffset: 0, extentOffset: _supplyController.text.length);
      }
    });
    _deliveryFocusNode.addListener(() {
      if (_deliveryFocusNode.hasFocus) {
        _deliveryController.selection = TextSelection(baseOffset: 0, extentOffset: _deliveryController.text.length);
      }
    });
  }

  @override
  void dispose() {
    _rateFocusNode.dispose();
    _supplyFocusNode.dispose();
    _deliveryFocusNode.dispose();
    _nameController.dispose();
    _rateController.dispose();
    _supplyController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final customer = Customer(
        id: widget.customer?.id,
        name: _nameController.text.trim(),
        defaultMilkRate: double.tryParse(_rateController.text) ?? 0.0,
        defaultDailySupply: double.tryParse(_supplyController.text) ?? 0.0,
        defaultDeliveryCharge: double.tryParse(_deliveryController.text) ?? 0.0,
        createdAt: widget.customer?.createdAt ?? DateTime.now(),
      );

      final provider = context.read<CustomerProvider>();
      if (widget.customer == null) {
        provider.addCustomer(customer);
      } else {
        provider.updateCustomer(customer);
      }

      Navigator.pop(context);
    }
  }

  void _delete() {
    if (widget.customer != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you wish to delete this customer?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  context.read<CustomerProvider>().deleteCustomer(widget.customer!.id!);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${widget.customer!.name} deleted')),
                  );
                },
                child: const Text('DELETE', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final symbol = context.select((SettingsProvider s) => s.settings.currencySymbol);
    final isEditing = widget.customer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Customer' : 'Add Customer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              TextFormField(
                controller: _rateController,
                focusNode: _rateFocusNode,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Default Milk Rate (per Litre)',
                  prefixText: '$symbol ',
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter a rate';
                  if (double.tryParse(val) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              TextFormField(
                controller: _supplyController,
                focusNode: _supplyFocusNode,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Default Daily Supply (Litres)',
                  border: OutlineInputBorder(),
                  suffixText: 'L',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter supply';
                  if (double.tryParse(val) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              TextFormField(
                controller: _deliveryController,
                focusNode: _deliveryFocusNode,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Default Daily Delivery Charge',
                  prefixText: '$symbol ',
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter delivery charge';
                  if (double.tryParse(val) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Customer'),
              ),
              if (isEditing) ...[
                const SizedBox(height: AppConstants.paddingMedium),
                OutlinedButton(
                  onPressed: _delete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Delete Customer'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
