import 'zakat_rule.dart';

/// Default zakat rule: 2.5% (1/40) on total gold value once it meets or
/// exceeds the nisab threshold (~85g of 24k-gold-equivalent value),
/// assuming the hawl (one lunar year of holding) has already been met.
class StandardZakatRule implements ZakatRule {
  static const double nisabGrams = 85.0;
  static const double zakatFraction = 1 / 40;

  @override
  ZakatResult calculate(ZakatInput input) {
    final nisabValue = nisabGrams * input.pricePerGram24k;
    final totalValue = input.totalGoldWeightGrams * input.pricePerGram24k;
    final meets = input.hawlMet && totalValue >= nisabValue;
    final due = meets ? totalValue * zakatFraction : 0.0;

    return ZakatResult(
      nisabMet: meets,
      nisabThresholdValue: nisabValue,
      zakatableValue: totalValue,
      zakatDue: due,
    );
  }
}
