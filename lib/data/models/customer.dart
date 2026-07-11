class Customer {
  final int? id;
  final String name;
  final double defaultMilkRate;
  final double defaultDailySupply;
  final double defaultDeliveryCharge;
  final DateTime createdAt;

  Customer({
    this.id,
    required this.name,
    required this.defaultMilkRate,
    required this.defaultDailySupply,
    required this.defaultDeliveryCharge,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'defaultMilkRate': defaultMilkRate,
      'defaultDailySupply': defaultDailySupply,
      'defaultDeliveryCharge': defaultDeliveryCharge,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int?,
      name: map['name'] as String,
      defaultMilkRate: (map['defaultMilkRate'] as num).toDouble(),
      defaultDailySupply: (map['defaultDailySupply'] as num).toDouble(),
      defaultDeliveryCharge: (map['defaultDeliveryCharge'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Customer copyWith({
    int? id,
    String? name,
    double? defaultMilkRate,
    double? defaultDailySupply,
    double? defaultDeliveryCharge,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultMilkRate: defaultMilkRate ?? this.defaultMilkRate,
      defaultDailySupply: defaultDailySupply ?? this.defaultDailySupply,
      defaultDeliveryCharge: defaultDeliveryCharge ?? this.defaultDeliveryCharge,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
