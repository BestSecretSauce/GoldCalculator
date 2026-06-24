enum Currency {
  usd,
  aed,
  gbp,
  eur,
  inr;

  String get symbol => switch (this) {
        Currency.usd => '\$',
        Currency.aed => 'د.إ',
        Currency.gbp => '£',
        Currency.eur => '€',
        Currency.inr => '₹',
      };
}

class CurrencyFormatter {
  static String format(double value, Currency currency) {
    return '${currency.symbol}${value.toStringAsFixed(2)}';
  }
}
