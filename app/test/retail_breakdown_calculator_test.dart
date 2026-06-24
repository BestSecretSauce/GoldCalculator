import 'package:flutter_test/flutter_test.dart';
import 'package:gold_calculator/features/retail_breakdown/logic/retail_breakdown_calculator.dart';

void main() {
  group('RetailBreakdownCalculator', () {
    test('splits retail price into gold value, workmanship, and tax', () {
      final result = RetailBreakdownCalculator.calculate(
        mode: RetailInputMode.totalPrice,
        inputValue: 1050,
        weightGrams: 10,
        goldPricePerGram: 80,
        taxPercent: 5,
        includeTax: true,
      );

      expect(result.totalRetailPrice, closeTo(1050, 0.01));
      expect(result.retailWithoutTax, closeTo(1000, 0.01));
      expect(result.taxAmount, closeTo(50, 0.01));
      expect(result.pureGoldValue, closeTo(800, 0.01));
      expect(result.workmanshipPrice, closeTo(200, 0.01));
      expect(result.workmanshipPricePerGram, closeTo(20, 0.01));
      expect(result.workmanshipPercent, closeTo(25, 0.01));
    });

    test('ignores tax when includeTax is false', () {
      final result = RetailBreakdownCalculator.calculate(
        mode: RetailInputMode.totalPrice,
        inputValue: 1000,
        weightGrams: 10,
        goldPricePerGram: 80,
        taxPercent: 5,
        includeTax: false,
      );

      expect(result.retailWithoutTax, closeTo(1000, 0.01));
      expect(result.taxAmount, closeTo(0, 0.01));
    });

    test('handles zero weight without dividing by zero', () {
      final result = RetailBreakdownCalculator.calculate(
        mode: RetailInputMode.totalPrice,
        inputValue: 0,
        weightGrams: 0,
        goldPricePerGram: 80,
        taxPercent: 5,
        includeTax: true,
      );

      expect(result.workmanshipPricePerGram, 0);
      expect(result.workmanshipPercent, 0);
    });

    test('derives total retail price from a known workmanship-per-gram charge', () {
      final result = RetailBreakdownCalculator.calculate(
        mode: RetailInputMode.workmanshipPerGram,
        inputValue: 20,
        weightGrams: 10,
        goldPricePerGram: 80,
        taxPercent: 5,
        includeTax: true,
      );

      expect(result.pureGoldValue, closeTo(800, 0.01));
      expect(result.workmanshipPrice, closeTo(200, 0.01));
      expect(result.retailWithoutTax, closeTo(1000, 0.01));
      expect(result.taxAmount, closeTo(50, 0.01));
      expect(result.totalRetailPrice, closeTo(1050, 0.01));
      expect(result.workmanshipPercent, closeTo(25, 0.01));
    });

    test('derives total retail price from a known workmanship percent', () {
      final result = RetailBreakdownCalculator.calculate(
        mode: RetailInputMode.workmanshipPercent,
        inputValue: 25,
        weightGrams: 10,
        goldPricePerGram: 80,
        taxPercent: 5,
        includeTax: true,
      );

      expect(result.pureGoldValue, closeTo(800, 0.01));
      expect(result.workmanshipPrice, closeTo(200, 0.01));
      expect(result.retailWithoutTax, closeTo(1000, 0.01));
      expect(result.taxAmount, closeTo(50, 0.01));
      expect(result.totalRetailPrice, closeTo(1050, 0.01));
      expect(result.workmanshipPricePerGram, closeTo(20, 0.01));
    });
  });
}
