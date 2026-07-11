import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:milk_ledger/core/constants.dart';
import 'package:milk_ledger/providers/calculator_provider.dart';
import 'package:intl/intl.dart';

class MonthSelectorCard extends StatelessWidget {
  const MonthSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Consumer<CalculatorProvider>(
          builder: (context, provider, child) {
            return Row(
              children: [
                const Icon(Icons.calendar_today, size: 32, color: Colors.blue),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(provider.isCustomRange ? 'Custom Date Range' : 'Select Month', 
                               style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          PopupMenuButton<bool>(
                            icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
                            padding: EdgeInsets.zero,
                            onSelected: (isCustom) {
                              if (isCustom && !provider.isCustomRange) {
                                provider.setCustomDateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
                              } else if (!isCustom && provider.isCustomRange) {
                                provider.setDate(DateTime.now().month, DateTime.now().year);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: false, child: Text('Monthly Billing')),
                              const PopupMenuItem(value: true, child: Text('Custom Date Range')),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (provider.isCustomRange) {
                            final range = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDateRange: DateTimeRange(start: provider.startDate, end: provider.endDate),
                            );
                            if (range != null) {
                              provider.setCustomDateRange(range.start, range.end);
                            }
                          } else {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(provider.year, provider.month),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDatePickerMode: DatePickerMode.year,
                            );
                            if (selectedDate != null) {
                              provider.setDate(selectedDate.month, selectedDate.year);
                            }
                          }
                        },
                        child: Text(
                          provider.isCustomRange 
                            ? '${DateFormat('dd MMM').format(provider.startDate)} - ${DateFormat('dd MMM yy').format(provider.endDate)}'
                            : DateFormat('MMMM yyyy').format(DateTime(provider.year, provider.month)),
                          style: TextStyle(fontSize: provider.isCustomRange ? 18 : 20, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text('${provider.daysInRange} Days'),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
