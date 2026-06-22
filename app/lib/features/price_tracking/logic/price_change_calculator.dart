import '../../../core/models/gold_price_snapshot.dart';

enum PriceChangePeriod {
  day(Duration(days: 1)),
  week(Duration(days: 7)),
  month(Duration(days: 30));

  const PriceChangePeriod(this.duration);
  final Duration duration;
}

/// Computes the percent change in each karat's buy price between the latest
/// snapshot and the closest historical snapshot at or before [period] ago.
///
/// [history] must be sorted ascending by timestamp (oldest first). Returns
/// an empty map if there isn't enough history to cover the requested period,
/// rather than comparing against a too-recent record and reporting a
/// misleading number.
class PriceChangeCalculator {
  static Map<String, double> calculate({
    required List<GoldPriceSnapshot> history,
    required PriceChangePeriod period,
  }) {
    if (history.isEmpty) return {};

    final latest = history.last;
    final cutoff = latest.timestamp.subtract(period.duration);

    if (history.first.timestamp.isAfter(cutoff)) {
      return {};
    }

    GoldPriceSnapshot reference = history.first;
    for (final record in history) {
      if (record.timestamp.isAfter(cutoff)) break;
      reference = record;
    }

    // If the closest available record is much older than the cutoff itself
    // (e.g. there's a long gap in the scrape history), it isn't a meaningful
    // stand-in for "period ago" — report no data rather than a misleading
    // number anchored to a stale snapshot.
    final earliestAcceptable = cutoff.subtract(period.duration);
    if (reference.timestamp.isBefore(earliestAcceptable)) {
      return {};
    }

    final changes = <String, double>{};
    for (final entry in latest.karats.entries) {
      final pastPrice = reference.karats[entry.key];
      if (pastPrice == null || pastPrice.buy == 0) continue;
      changes[entry.key] =
          (entry.value.buy - pastPrice.buy) / pastPrice.buy * 100;
    }
    return changes;
  }
}
