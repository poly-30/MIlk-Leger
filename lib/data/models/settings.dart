class AppSettings {
  final double defaultMilkRate;
  final double defaultDailySupply;
  final double defaultDeliveryCharge;
  final String currencySymbol;
  final bool isDarkMode;

  AppSettings({
    required this.defaultMilkRate,
    required this.defaultDailySupply,
    required this.defaultDeliveryCharge,
    required this.currencySymbol,
    required this.isDarkMode,
  });

  AppSettings copyWith({
    double? defaultMilkRate,
    double? defaultDailySupply,
    double? defaultDeliveryCharge,
    String? currencySymbol,
    bool? isDarkMode,
  }) {
    return AppSettings(
      defaultMilkRate: defaultMilkRate ?? this.defaultMilkRate,
      defaultDailySupply: defaultDailySupply ?? this.defaultDailySupply,
      defaultDeliveryCharge: defaultDeliveryCharge ?? this.defaultDeliveryCharge,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
