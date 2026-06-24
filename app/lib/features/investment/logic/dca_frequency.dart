import '../../../l10n/generated/app_localizations.dart';

enum DcaFrequency { weekly, biweekly, monthly }

extension DcaFrequencyX on DcaFrequency {
  Duration get interval => switch (this) {
        DcaFrequency.weekly => const Duration(days: 7),
        DcaFrequency.biweekly => const Duration(days: 14),
        DcaFrequency.monthly => const Duration(days: 30),
      };

  String label(AppLocalizations l10n) => switch (this) {
        DcaFrequency.weekly => l10n.frequencyWeeklyLabel,
        DcaFrequency.biweekly => l10n.frequencyBiweeklyLabel,
        DcaFrequency.monthly => l10n.frequencyMonthlyLabel,
      };
}
