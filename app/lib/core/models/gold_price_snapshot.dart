class KaratPrice {
  final double buy;
  final double sell;

  const KaratPrice({required this.buy, required this.sell});

  factory KaratPrice.fromJson(Map<String, dynamic> json) => KaratPrice(
        buy: (json['buy'] as num).toDouble(),
        sell: (json['sell'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {'buy': buy, 'sell': sell};
}

class GoldPriceSnapshot {
  final DateTime timestamp;
  final String lastUpdated;
  final Map<String, KaratPrice> karats;
  final KaratPrice? ouncePrice;
  final bool isFromCache;

  const GoldPriceSnapshot({
    required this.timestamp,
    required this.lastUpdated,
    required this.karats,
    this.ouncePrice,
    this.isFromCache = false,
  });

  factory GoldPriceSnapshot.fromJson(
    Map<String, dynamic> json, {
    bool isFromCache = false,
  }) {
    final karatsJson = json['karats'] as Map<String, dynamic>? ?? {};
    final karats = karatsJson.map(
      (key, value) =>
          MapEntry(key, KaratPrice.fromJson(value as Map<String, dynamic>)),
    );

    final ounceJson = json['ounce'] as Map<String, dynamic>?;
    KaratPrice? ouncePrice;
    if (ounceJson != null && ounceJson.isNotEmpty) {
      ouncePrice =
          KaratPrice.fromJson(ounceJson.values.first as Map<String, dynamic>);
    }

    return GoldPriceSnapshot(
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
              DateTime.now(),
      lastUpdated: json['last_updated'] as String? ?? '',
      karats: karats,
      ouncePrice: ouncePrice,
      isFromCache: isFromCache,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'last_updated': lastUpdated,
        'karats': karats.map((key, value) => MapEntry(key, value.toJson())),
        if (ouncePrice != null) 'ounce': {'الأونصة': ouncePrice!.toJson()},
      };
}
