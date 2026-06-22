import '../../../l10n/generated/app_localizations.dart';

enum WeightUnit {
  gram,
  ounce,
  kilogram,
  tola;

  double get gramsPerUnit => switch (this) {
        WeightUnit.gram => 1,
        WeightUnit.ounce => 28.3495,
        WeightUnit.kilogram => 1000,
        WeightUnit.tola => 11.6638,
      };

  String label(AppLocalizations l10n) => switch (this) {
        WeightUnit.gram => l10n.unitGram,
        WeightUnit.ounce => l10n.unitOunce,
        WeightUnit.kilogram => l10n.unitKilogram,
        WeightUnit.tola => l10n.unitTola,
      };
}
