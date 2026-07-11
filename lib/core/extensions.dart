import 'package:intl/intl.dart';

extension DoubleFormatting on double {
  /// Formats the double as currency with the specified symbol, e.g., ₹1,250.00
  String toCurrency([String symbol = '₹']) {
    final format = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
      customPattern: '$symbol#,##,##0.00',
    );
    return format.format(this);
  }

  /// Formats double without trailing zeros if they are not needed, e.g., 2.0 -> 2, 2.5 -> 2.5
  String toDisplayString() {
    return this == truncateToDouble() ? truncate().toString() : toString();
  }
}

extension DateTimeFormatting on DateTime {
  /// Returns short month and year, e.g., "Oct 2023"
  String toMonthYear() {
    return DateFormat('MMM yyyy').format(this);
  }
}
