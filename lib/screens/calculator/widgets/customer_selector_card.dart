import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/data/models/customer.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:milk_ledger/providers/customer_provider.dart';

class CustomerSelectorCard extends StatelessWidget {
  const CustomerSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Consumer2<CustomerProvider, CalculatorProvider>(
          builder: (context, customerProvider, calculatorProvider, child) {
            if (customerProvider.customers.isEmpty) {
              return const Text('No customers saved. Add one in the Customers tab.', style: TextStyle(color: Colors.grey));
            }

            return DropdownButtonFormField<Customer?>(
              decoration: const InputDecoration(
                labelText: 'Select Customer (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              value: calculatorProvider.selectedCustomer,
              items: [
                const DropdownMenuItem<Customer?>(
                  value: null,
                  child: Text('Custom (No customer)'),
                ),
                ...customerProvider.customers.map((c) {
                  return DropdownMenuItem<Customer?>(
                    value: c,
                    child: Text(c.name),
                  );
                }).toList(),
              ],
              onChanged: (Customer? newValue) {
                calculatorProvider.applyCustomer(newValue);
              },
            );
          },
        ),
      ),
    );
  }
}
