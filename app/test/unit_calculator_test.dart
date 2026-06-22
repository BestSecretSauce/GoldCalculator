import 'package:flutter_test/flutter_test.dart';
import 'package:gold_calculator/features/unit_calculator/logic/unit_calculator.dart';
import 'package:gold_calculator/features/unit_calculator/logic/weight_unit.dart';

void main() {
  group('UnitCalculator', () {
    test('computes cost, revenue, and profit in the given unit', () {
      final result = UnitCalculator.calculate(
        weight: 2,
        unit: WeightUnit.ounce,
        buyPricePerUnit: 100,
        sellPricePerUnit: 120,
      );

      expect(result.totalCost, 200);
      expect(result.totalRevenue, 240);
      expect(result.profit, 40);
      expect(result.profitPercent, closeTo(20, 0.01));
      expect(result.weightInGrams, closeTo(2 * 28.3495, 0.001));
    });

    test('reports zero profit percent when cost is zero', () {
      final result = UnitCalculator.calculate(
        weight: 0,
        unit: WeightUnit.gram,
        buyPricePerUnit: 0,
        sellPricePerUnit: 50,
      );

      expect(result.profitPercent, 0);
    });
  });

  group('WeightUnit', () {
    test('converts each unit to grams', () {
      expect(WeightUnit.gram.gramsPerUnit, 1);
      expect(WeightUnit.kilogram.gramsPerUnit, 1000);
      expect(WeightUnit.ounce.gramsPerUnit, closeTo(28.3495, 0.0001));
      expect(WeightUnit.tola.gramsPerUnit, closeTo(11.6638, 0.0001));
    });
  });
}
