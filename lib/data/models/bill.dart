import 'dart:convert';

class Bill {
  final int? id;
  final int? customerId;
  final String customerName;
  final int month;
  final int year;
  final double milkRate;
  final double dailyDeliveryCharge;
  final double dailySupply;
  final int daysInMonth;
  final double totalMilk;
  final double milkCharges;
  final double deliveryCharges;
  final double totalAmount;
  final DateTime savedAt;
  final Map<DateTime, double>? adjustments;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isCustomRange;

  Bill({
    this.id,
    this.customerId,
    required this.customerName,
    required this.month,
    required this.year,
    required this.milkRate,
    required this.dailyDeliveryCharge,
    required this.dailySupply,
    required this.daysInMonth,
    required this.totalMilk,
    required this.milkCharges,
    required this.deliveryCharges,
    required this.totalAmount,
    required this.savedAt,
    this.adjustments,
    this.startDate,
    this.endDate,
    this.isCustomRange = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'month': month,
      'year': year,
      'milkRate': milkRate,
      'dailyDeliveryCharge': dailyDeliveryCharge,
      'dailySupply': dailySupply,
      'daysInMonth': daysInMonth,
      'totalMilk': totalMilk,
      'milkCharges': milkCharges,
      'deliveryCharges': deliveryCharges,
      'totalAmount': totalAmount,
      'savedAt': savedAt.toIso8601String(),
      'adjustments': adjustments != null
          ? jsonEncode(adjustments!.map((key, value) => MapEntry(key.toIso8601String(), value)))
          : null,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCustomRange': isCustomRange ? 1 : 0,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'] as int?,
      customerId: map['customerId'] as int?,
      customerName: map['customerName'] as String,
      month: map['month'] as int,
      year: map['year'] as int,
      milkRate: (map['milkRate'] as num).toDouble(),
      dailyDeliveryCharge: (map['dailyDeliveryCharge'] as num).toDouble(),
      dailySupply: (map['dailySupply'] as num).toDouble(),
      daysInMonth: map['daysInMonth'] as int,
      totalMilk: (map['totalMilk'] as num).toDouble(),
      milkCharges: (map['milkCharges'] as num).toDouble(),
      deliveryCharges: (map['deliveryCharges'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      savedAt: DateTime.parse(map['savedAt'] as String),
      adjustments: map['adjustments'] != null
          ? (jsonDecode(map['adjustments'] as String) as Map<String, dynamic>)
              .map((key, value) => MapEntry(DateTime.parse(key), (value as num).toDouble()))
          : null,
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate'] as String) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      isCustomRange: map['isCustomRange'] == 1,
    );
  }

  Bill copyWith({
    int? id,
    int? customerId,
    String? customerName,
    int? month,
    int? year,
    double? milkRate,
    double? dailyDeliveryCharge,
    double? dailySupply,
    int? daysInMonth,
    double? totalMilk,
    double? milkCharges,
    double? deliveryCharges,
    double? totalAmount,
    DateTime? savedAt,
    Map<DateTime, double>? adjustments,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCustomRange,
  }) {
    return Bill(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      month: month ?? this.month,
      year: year ?? this.year,
      milkRate: milkRate ?? this.milkRate,
      dailyDeliveryCharge: dailyDeliveryCharge ?? this.dailyDeliveryCharge,
      dailySupply: dailySupply ?? this.dailySupply,
      daysInMonth: daysInMonth ?? this.daysInMonth,
      totalMilk: totalMilk ?? this.totalMilk,
      milkCharges: milkCharges ?? this.milkCharges,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      totalAmount: totalAmount ?? this.totalAmount,
      savedAt: savedAt ?? this.savedAt,
      adjustments: adjustments ?? this.adjustments,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCustomRange: isCustomRange ?? this.isCustomRange,
    );
  }
}
