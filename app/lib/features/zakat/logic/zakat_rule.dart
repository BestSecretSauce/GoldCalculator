class ZakatInput {
  final double totalGoldWeightGrams;
  final double pricePerGram24k;
  final bool hawlMet;

  const ZakatInput({
    required this.totalGoldWeightGrams,
    required this.pricePerGram24k,
    this.hawlMet = true,
  });
}

class ZakatResult {
  final bool nisabMet;
  final double nisabThresholdValue;
  final double zakatableValue;
  final double zakatDue;

  const ZakatResult({
    required this.nisabMet,
    required this.nisabThresholdValue,
    required this.zakatableValue,
    required this.zakatDue,
  });
}

abstract class ZakatRule {
  ZakatResult calculate(ZakatInput input);
}
