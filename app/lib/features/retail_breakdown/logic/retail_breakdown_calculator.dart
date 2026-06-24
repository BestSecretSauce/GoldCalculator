enum RetailInputMode { totalPrice, workmanshipPerGram, workmanshipPercent }

class RetailBreakdownResult {
  final double totalRetailPrice;
  final double pureGoldValue;
  final double retailWithoutTax;
  final double taxAmount;
  final double workmanshipPrice;
  final double workmanshipPricePerGram;
  final double workmanshipPercent;

  const RetailBreakdownResult({
    required this.totalRetailPrice,
    required this.pureGoldValue,
    required this.retailWithoutTax,
    required this.taxAmount,
    required this.workmanshipPrice,
    required this.workmanshipPricePerGram,
    required this.workmanshipPercent,
  });
}

class RetailBreakdownCalculator {
  /// Computes the full retail price breakdown. [mode] determines what
  /// [inputValue] represents — the total retail price, the workmanship
  /// charge per gram, or the workmanship percent over the pure gold value —
  /// so a user can work the calculation from whichever figure they were
  /// quoted and still see the resulting total retail price.
  static RetailBreakdownResult calculate({
    required RetailInputMode mode,
    required double inputValue,
    required double weightGrams,
    required double goldPricePerGram,
    required double taxPercent,
    required bool includeTax,
  }) {
    final effectiveTaxPercent = includeTax ? taxPercent : 0;
    final pureGoldValue = weightGrams * goldPricePerGram;

    double retailWithoutTax;
    double workmanshipPrice;

    switch (mode) {
      case RetailInputMode.totalPrice:
        retailWithoutTax = inputValue / (1 + (effectiveTaxPercent / 100));
        workmanshipPrice = retailWithoutTax - pureGoldValue;
      case RetailInputMode.workmanshipPerGram:
        workmanshipPrice = inputValue * weightGrams;
        retailWithoutTax = pureGoldValue + workmanshipPrice;
      case RetailInputMode.workmanshipPercent:
        workmanshipPrice = pureGoldValue * (inputValue / 100);
        retailWithoutTax = pureGoldValue + workmanshipPrice;
    }

    final totalRetailPrice = retailWithoutTax * (1 + (effectiveTaxPercent / 100));
    final taxAmount = totalRetailPrice - retailWithoutTax;
    final workmanshipPricePerGram =
        weightGrams > 0 ? workmanshipPrice / weightGrams : 0.0;
    final workmanshipPercent =
        pureGoldValue > 0 ? (workmanshipPrice / pureGoldValue) * 100 : 0.0;

    return RetailBreakdownResult(
      totalRetailPrice: totalRetailPrice,
      pureGoldValue: pureGoldValue,
      retailWithoutTax: retailWithoutTax,
      taxAmount: taxAmount,
      workmanshipPrice: workmanshipPrice,
      workmanshipPricePerGram: workmanshipPricePerGram,
      workmanshipPercent: workmanshipPercent,
    );
  }
}
