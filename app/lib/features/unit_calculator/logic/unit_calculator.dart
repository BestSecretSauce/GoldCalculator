import 'weight_unit.dart';

class UnitCalculatorResult {
  final double weightInGrams;
  final double totalCost;
  final double totalRevenue;
  final double profit;
  final double profitPercent;

  const UnitCalculatorResult({
    required this.weightInGrams,
    required this.totalCost,
    required this.totalRevenue,
    required this.profit,
    required this.profitPercent,
  });
}

class UnitCalculator {
  /// [buyPricePerUnit] and [sellPricePerUnit] must be denominated in the same
  /// [unit] as [weight] (e.g. price per ounce when weight is in ounces).
  static UnitCalculatorResult calculate({
    required double weight,
    required WeightUnit unit,
    required double buyPricePerUnit,
    required double sellPricePerUnit,
  }) {
    final totalCost = weight * buyPricePerUnit;
    final totalRevenue = weight * sellPricePerUnit;
    final profit = totalRevenue - totalCost;
    final profitPercent = totalCost > 0 ? (profit / totalCost) * 100 : 0.0;

    return UnitCalculatorResult(
      weightInGrams: weight * unit.gramsPerUnit,
      totalCost: totalCost,
      totalRevenue: totalRevenue,
      profit: profit,
      profitPercent: profitPercent,
    );
  }
}
