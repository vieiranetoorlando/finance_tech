class CurrencyModel {
  final String code;
  final String name;
  final double bid;
  final double pctChange;

  CurrencyModel({
    required this.code,
    required this.name,
    required this.bid,
    required this.pctChange,
  });

  factory CurrencyModel.fromJson(String key, Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      bid: double.tryParse(json['bid']?.toString() ?? '0') ?? 0.0,
      pctChange: double.tryParse(json['pctChange']?.toString() ?? '0') ?? 0.0,
    );
  }
}
