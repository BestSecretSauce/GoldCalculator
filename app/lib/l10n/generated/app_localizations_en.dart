// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gold Calculator';

  @override
  String get navPrices => 'Prices';

  @override
  String get navInvestment => 'Investment';

  @override
  String get navRetail => 'Retail';

  @override
  String get navZakat => 'Zakat';

  @override
  String get languageToggleTooltip => 'Change language';

  @override
  String get priceScreenTitle => 'Gold Prices';

  @override
  String priceLoadError(Object error) {
    return 'Could not load prices: $error';
  }

  @override
  String get karatHeader => 'Karat';

  @override
  String get buyHeader => 'Buy';

  @override
  String get sellHeader => 'Sell';

  @override
  String get changeHeader => 'Change';

  @override
  String get periodDayLabel => '1D';

  @override
  String get periodWeekLabel => '1W';

  @override
  String get periodMonthLabel => '1M';

  @override
  String lastUpdatedLabel(Object value) {
    return 'Last updated: $value';
  }

  @override
  String get cachedDataWarning =>
      'Showing cached data — could not reach the server';

  @override
  String get retailScreenTitle => 'Retail Price Breakdown';

  @override
  String get goldKaratLabel => 'Gold karat';

  @override
  String get calculateFromLabel => 'Calculate from';

  @override
  String get totalRetailPriceLabel => 'Total retail price';

  @override
  String get weightGramsLabel => 'Weight (grams)';

  @override
  String get goldMarketPriceLabel => 'Gold market price per gram';

  @override
  String get taxPercentLabel => 'Tax %';

  @override
  String get pureGoldValueLabel => 'Pure gold value';

  @override
  String get taxAmountLabel => 'Tax amount';

  @override
  String get priceWithoutTaxLabel => 'Price without tax';

  @override
  String get workmanshipChargeLabel => 'Workmanship charge';

  @override
  String get workmanshipPerGramLabel => 'Workmanship per gram';

  @override
  String get workmanshipPercentLabel => 'Workmanship %';

  @override
  String get dealGreatLabel => 'Great deal';

  @override
  String get dealFairLabel => 'Fair price';

  @override
  String get dealOvervaluedLabel => 'Overvalued';

  @override
  String get dealBasisStatic => 'Based on typical industry range';

  @override
  String dealBasisPersonal(Object count) {
    return 'Based on your last $count purchases';
  }

  @override
  String get saveCalculationTooltip => 'Save this calculation to your history';

  @override
  String get calculationSavedMessage => 'Saved to your purchase history';

  @override
  String get shopNameLabel => 'Shop name (optional)';

  @override
  String get addPhotoLabel => 'Add photo';

  @override
  String get takePhotoLabel => 'Take photo';

  @override
  String get chooseFromGalleryLabel => 'Choose from gallery';

  @override
  String get removePhotoLabel => 'Remove photo';

  @override
  String get saveRecordTitle => 'Save purchase record';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get purchaseHistoryTitle => 'Purchase History';

  @override
  String get noSavedRecordsMessage => 'No saved purchases yet';

  @override
  String get deleteRecordTooltip => 'Delete';

  @override
  String get deleteConfirmTitle => 'Delete this record?';

  @override
  String get deleteConfirmMessage =>
      'This will permanently remove the saved record and photo.';

  @override
  String get imagePickerUnsupportedMessage =>
      'Camera/gallery isn\'t supported on this device';

  @override
  String get unknownShopLabel => 'Unknown shop';

  @override
  String get dateLabel => 'Date';

  @override
  String get investmentScreenTitle => 'Gold Investment';

  @override
  String get investmentIntroMessage =>
      'See how your gold would have grown if you invested a fixed amount on a regular schedule (dollar-cost averaging).';

  @override
  String get contributionAmountLabel => 'Amount per contribution';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get frequencyLabel => 'Contribution frequency';

  @override
  String get frequencyWeeklyLabel => 'Weekly';

  @override
  String get frequencyBiweeklyLabel => 'Every 2 weeks';

  @override
  String get frequencyMonthlyLabel => 'Monthly';

  @override
  String get startDateLabel => 'Start date';

  @override
  String get noHistoryDataMessage =>
      'Not enough price history yet to run this simulation';

  @override
  String get purchasesCountLabel => 'Contributions made';

  @override
  String get totalInvestedLabel => 'Total invested';

  @override
  String get totalGramsLabel => 'Gold accumulated';

  @override
  String get averageCostLabel => 'Average cost per gram';

  @override
  String get currentPriceLabel => 'Current price per gram';

  @override
  String get currentValueLabel => 'Current value';

  @override
  String get profitLossLabel => 'Profit / Loss';

  @override
  String get zakatScreenTitle => 'Zakat Calculator';

  @override
  String get goldWeightZakatLabel =>
      'Total gold weight (grams, 24k-equivalent)';

  @override
  String get goldPrice24kLabel => '24k gold price per gram';

  @override
  String get hawlMetLabel => 'Hawl met (held for one lunar year)';

  @override
  String get nisabThresholdLabel => 'Nisab threshold value';

  @override
  String get zakatableValueLabel => 'Your zakatable value';

  @override
  String get nisabMetMessage => 'Nisab met — zakat is due';

  @override
  String get nisabNotMetMessage => 'Below nisab — no zakat due';

  @override
  String get zakatDueLabel => 'Zakat due';
}
