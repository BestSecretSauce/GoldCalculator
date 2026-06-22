import 'package:flutter_test/flutter_test.dart';
import 'package:gold_calculator/features/retail_breakdown/logic/deal_quality_evaluator.dart';

void main() {
  group('DealQualityEvaluator', () {
    test('uses the static range when history is too small', () {
      final assessment = DealQualityEvaluator.evaluate(
        workmanshipPercent: 5,
        history: [10, 12],
      );

      expect(assessment.isPersonalized, isFalse);
      expect(assessment.quality, DealQuality.greatDeal);
    });

    test('flags a high workmanship percent as overvalued under the static range', () {
      final assessment = DealQualityEvaluator.evaluate(
        workmanshipPercent: 25,
        history: [],
      );

      expect(assessment.isPersonalized, isFalse);
      expect(assessment.quality, DealQuality.overvalued);
    });

    test('switches to a personalized band once enough history exists', () {
      final history = [20.0, 20.0, 20.0, 20.0, 20.0];

      final fair = DealQualityEvaluator.evaluate(
        workmanshipPercent: 20,
        history: history,
      );
      final great = DealQualityEvaluator.evaluate(
        workmanshipPercent: 15,
        history: history,
      );
      final overvalued = DealQualityEvaluator.evaluate(
        workmanshipPercent: 25,
        history: history,
      );

      expect(fair.isPersonalized, isTrue);
      expect(fair.sampleCount, 5);
      expect(fair.quality, DealQuality.fair);
      expect(great.quality, DealQuality.greatDeal);
      expect(overvalued.quality, DealQuality.overvalued);
    });
  });
}
