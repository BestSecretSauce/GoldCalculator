class RetailBreakdownResult {
  final double pureGoldValue;
  final double retailWithoutTax;
  final double taxAmount;
  final double workmanshipPrice;
  final double workmanshipPricePerGram;
  final double workmanshipPercent;

  const RetailBreakdownResult({
    required this.pureGoldValue,
    required this.retailWithoutTax,
    required this.taxAmount,
    required this.workmanshipPrice,
    required this.workmanshipPricePerGram,
    required this.workmanshipPercent,
  });
}

class RetailBreakdownCalculator {
  static RetailBreakdownResult calculate({
    required double retailPrice,
    required double weightGrams,
    required double goldPricePerGram,
    required double taxPercent,
    required bool includeTax,
  }) {
    final effectiveTaxPercent = includeTax ? taxPercent : 0;
    final retailWithoutTax = retailPrice / (1 + (effectiveTaxPercent / 100));
    final taxAmount = retailPrice - retailWithoutTax;
    final pureGoldValue = weightGrams * goldPricePerGram;
    final workmanshipPrice = retailWithoutTax - pureGoldValue;
    final workmanshipPricePerGram =
        weightGrams > 0 ? workmanshipPrice / weightGrams : 0.0;
    final workmanshipPercent =
        pureGoldValue > 0 ? (workmanshipPrice / pureGoldValue) * 100 : 0.0;

    return RetailBreakdownResult(
      pureGoldValue: pureGoldValue,
      retailWithoutTax: retailWithoutTax,
      taxAmount: taxAmount,
      workmanshipPrice: workmanshipPrice,
      workmanshipPricePerGram: workmanshipPricePerGram,
      workmanshipPercent: workmanshipPercent,
    );
  }
}
