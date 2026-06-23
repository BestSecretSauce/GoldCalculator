class PurchaseRecord {
  final String id;
  final DateTime timestamp;
  final String? shopName;
  final String? imagePath;
  final double retailPrice;
  final double weightGrams;
  final double goldPricePerGram;
  final double workmanshipPercent;
  final String? karat;

  const PurchaseRecord({
    required this.id,
    required this.timestamp,
    required this.retailPrice,
    required this.weightGrams,
    required this.goldPricePerGram,
    required this.workmanshipPercent,
    this.shopName,
    this.imagePath,
    this.karat,
  });

  factory PurchaseRecord.fromJson(Map<String, dynamic> json) => PurchaseRecord(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        shopName: json['shopName'] as String?,
        imagePath: json['imagePath'] as String?,
        retailPrice: (json['retailPrice'] as num).toDouble(),
        weightGrams: (json['weightGrams'] as num).toDouble(),
        goldPricePerGram: (json['goldPricePerGram'] as num).toDouble(),
        workmanshipPercent: (json['workmanshipPercent'] as num).toDouble(),
        karat: json['karat'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        if (shopName != null) 'shopName': shopName,
        if (imagePath != null) 'imagePath': imagePath,
        'retailPrice': retailPrice,
        'weightGrams': weightGrams,
        'goldPricePerGram': goldPricePerGram,
        'workmanshipPercent': workmanshipPercent,
        if (karat != null) 'karat': karat,
      };
}
