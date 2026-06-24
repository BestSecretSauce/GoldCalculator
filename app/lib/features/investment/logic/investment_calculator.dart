import '../../../core/models/gold_price_snapshot.dart';
import 'dca_frequency.dart';

class DcaPurchase {
  final DateTime date;
  final double pricePerGram;
  final double amountInvested;
  final double gramsBought;

  const DcaPurchase({
    required this.date,
    required this.pricePerGram,
    required this.amountInvested,
    required this.gramsBought,
  });
}

class DcaResult {
  final List<DcaPurchase> purchases;
  final double totalInvested;
  final double totalGrams;
  final double averageCostPerGram;
  final double currentPricePerGram;
  final double currentValue;
  final double profitLoss;
  final double profitLossPercent;

  const DcaResult({
    required this.purchases,
    required this.totalInvested,
    required this.totalGrams,
    required this.averageCostPerGram,
    required this.currentPricePerGram,
    required this.currentValue,
    required this.profitLoss,
    required this.profitLossPercent,
  });

  static const empty = DcaResult(
    purchases: [],
    totalInvested: 0,
    totalGrams: 0,
    averageCostPerGram: 0,
    currentPricePerGram: 0,
    currentValue: 0,
    profitLoss: 0,
    profitLossPercent: 0,
  );
}

class InvestmentCalculator {
  static DcaResult simulateDca({
    required double amountPerInterval,
    required DateTime startDate,
    required DcaFrequency frequency,
    required List<GoldPriceSnapshot> history,
    required String karatKey,
    required double currentPricePerGram,
    DateTime? asOf,
  }) {
    if (history.isEmpty || amountPerInterval <= 0) {
      return DcaResult.empty;
    }

    final sorted = [...history]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final endDate = asOf ?? DateTime.now();
    final purchases = <DcaPurchase>[];

    var date = startDate;
    while (!date.isAfter(endDate)) {
      final price = _priceOnOrBefore(sorted, date, karatKey);
      if (price != null && price > 0) {
        purchases.add(DcaPurchase(
          date: date,
          pricePerGram: price,
          amountInvested: amountPerInterval,
          gramsBought: amountPerInterval / price,
        ));
      }
      date = date.add(frequency.interval);
    }

    final totalInvested =
        purchases.fold(0.0, (sum, p) => sum + p.amountInvested);
    final totalGrams = purchases.fold(0.0, (sum, p) => sum + p.gramsBought);
    final averageCostPerGram = totalGrams > 0 ? totalInvested / totalGrams : 0.0;
    final currentValue = totalGrams * currentPricePerGram;
    final profitLoss = currentValue - totalInvested;
    final profitLossPercent =
        totalInvested > 0 ? (profitLoss / totalInvested) * 100 : 0.0;

    return DcaResult(
      purchases: purchases,
      totalInvested: totalInvested,
      totalGrams: totalGrams,
      averageCostPerGram: averageCostPerGram,
      currentPricePerGram: currentPricePerGram,
      currentValue: currentValue,
      profitLoss: profitLoss,
      profitLossPercent: profitLossPercent,
    );
  }

  /// Returns the buy price for [karatKey] from the latest snapshot that is
  /// not after [date], falling back to the earliest known snapshot for dates
  /// before our recorded history begins.
  static double? _priceOnOrBefore(
    List<GoldPriceSnapshot> sortedHistory,
    DateTime date,
    String karatKey,
  ) {
    GoldPriceSnapshot? best;
    for (final snapshot in sortedHistory) {
      if (!snapshot.timestamp.isAfter(date)) {
        best = snapshot;
      } else {
        break;
      }
    }
    best ??= sortedHistory.first;
    return best.karats[karatKey]?.buy;
  }
}
