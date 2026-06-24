import 'package:flutter_test/flutter_test.dart';
import 'package:gold_calculator/core/models/gold_price_snapshot.dart';
import 'package:gold_calculator/features/investment/logic/dca_frequency.dart';
import 'package:gold_calculator/features/investment/logic/investment_calculator.dart';

void main() {
  group('InvestmentCalculator.simulateDca', () {
    final history = [
      GoldPriceSnapshot(
        timestamp: DateTime(2025, 1, 1),
        lastUpdated: '',
        karats: {'24': const KaratPrice(buy: 100, sell: 95)},
      ),
      GoldPriceSnapshot(
        timestamp: DateTime(2025, 2, 1),
        lastUpdated: '',
        karats: {'24': const KaratPrice(buy: 200, sell: 190)},
      ),
    ];

    test('buys gold at the nearest known price for each interval', () {
      final result = InvestmentCalculator.simulateDca(
        amountPerInterval: 100,
        startDate: DateTime(2025, 1, 1),
        frequency: DcaFrequency.monthly,
        history: history,
        karatKey: '24',
        currentPricePerGram: 250,
        asOf: DateTime(2025, 1, 31),
      );

      // 2025-01-01 -> price 100, 2025-01-31 -> still nearest prior price 100
      expect(result.purchases.length, 2);
      expect(result.purchases[0].pricePerGram, 100);
      expect(result.purchases[1].pricePerGram, 100);
      expect(result.totalInvested, 200);
      expect(result.totalGrams, closeTo(1 + 1, 0.0001));
      expect(result.currentValue, closeTo(2 * 250, 0.0001));
      expect(result.profitLoss, closeTo(500 - 200, 0.0001));
    });

    test('falls back to the earliest snapshot for dates before history starts', () {
      final result = InvestmentCalculator.simulateDca(
        amountPerInterval: 50,
        startDate: DateTime(2024, 12, 1),
        frequency: DcaFrequency.monthly,
        history: history,
        karatKey: '24',
        currentPricePerGram: 100,
      );

      expect(result.purchases.first.pricePerGram, 100);
    });

    test('returns an empty result when there is no history', () {
      final result = InvestmentCalculator.simulateDca(
        amountPerInterval: 100,
        startDate: DateTime(2025, 1, 1),
        frequency: DcaFrequency.monthly,
        history: const [],
        karatKey: '24',
        currentPricePerGram: 250,
      );

      expect(result.purchases, isEmpty);
      expect(result.totalInvested, 0);
    });

    test('returns an empty result when the contribution amount is zero', () {
      final result = InvestmentCalculator.simulateDca(
        amountPerInterval: 0,
        startDate: DateTime(2025, 1, 1),
        frequency: DcaFrequency.monthly,
        history: history,
        karatKey: '24',
        currentPricePerGram: 250,
      );

      expect(result.purchases, isEmpty);
    });
  });
}
