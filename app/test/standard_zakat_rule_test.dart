import 'package:flutter_test/flutter_test.dart';
import 'package:gold_calculator/features/zakat/logic/standard_zakat_rule.dart';
import 'package:gold_calculator/features/zakat/logic/zakat_rule.dart';

void main() {
  group('StandardZakatRule', () {
    final rule = StandardZakatRule();

    test('zakat is due once nisab is met and hawl has passed', () {
      final result = rule.calculate(const ZakatInput(
        totalGoldWeightGrams: 100,
        pricePerGram24k: 10,
      ));

      expect(result.nisabThresholdValue, closeTo(850, 0.01));
      expect(result.zakatableValue, closeTo(1000, 0.01));
      expect(result.nisabMet, isTrue);
      expect(result.zakatDue, closeTo(25, 0.01));
    });

    test('no zakat due when below nisab', () {
      final result = rule.calculate(const ZakatInput(
        totalGoldWeightGrams: 50,
        pricePerGram24k: 10,
      ));

      expect(result.nisabMet, isFalse);
      expect(result.zakatDue, 0);
    });

    test('no zakat due when hawl has not been met, even above nisab', () {
      final result = rule.calculate(const ZakatInput(
        totalGoldWeightGrams: 100,
        pricePerGram24k: 10,
        hawlMet: false,
      ));

      expect(result.nisabMet, isFalse);
      expect(result.zakatDue, 0);
    });
  });
}
