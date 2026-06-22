import 'package:flutter_test/flutter_test.dart';
import 'package:gold_calculator/core/models/gold_price_snapshot.dart';
import 'package:gold_calculator/features/price_tracking/logic/price_change_calculator.dart';

GoldPriceSnapshot _snapshot(DateTime timestamp, double price24k) {
  return GoldPriceSnapshot(
    timestamp: timestamp,
    lastUpdated: timestamp.toString(),
    karats: {
      'عيار24': KaratPrice(buy: price24k, sell: price24k - 5),
    },
  );
}

void main() {
  group('PriceChangeCalculator', () {
    final now = DateTime(2026, 6, 21);

    test('computes percent change against the closest record before the cutoff', () {
      final history = [
        _snapshot(now.subtract(const Duration(days: 10)), 100),
        _snapshot(now.subtract(const Duration(days: 2)), 110),
        _snapshot(now, 121),
      ];

      final changes = PriceChangeCalculator.calculate(
        history: history,
        period: PriceChangePeriod.day,
      );

      // Closest record at/before 1 day ago is the day-2 entry (price 110).
      expect(changes['عيار24'], closeTo(10, 0.01));
    });

    test('returns empty when there is not enough history for the period', () {
      final history = [
        _snapshot(now.subtract(const Duration(days: 2)), 100),
        _snapshot(now, 110),
      ];

      final changes = PriceChangeCalculator.calculate(
        history: history,
        period: PriceChangePeriod.month,
      );

      expect(changes, isEmpty);
    });

    test('returns empty for an empty history', () {
      final changes = PriceChangeCalculator.calculate(
        history: [],
        period: PriceChangePeriod.week,
      );

      expect(changes, isEmpty);
    });

    test('ignores a stale reference far outside the requested period', () {
      // A long-dead scraper gap: the only record before the cutoff is over a
      // year old, which isn't a meaningful "1 day ago" comparison.
      final history = [
        _snapshot(now.subtract(const Duration(days: 400)), 100),
        _snapshot(now, 121),
      ];

      final changes = PriceChangeCalculator.calculate(
        history: history,
        period: PriceChangePeriod.day,
      );

      expect(changes, isEmpty);
    });
  });
}
