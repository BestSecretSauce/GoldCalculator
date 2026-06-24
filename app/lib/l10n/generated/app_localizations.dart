import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Gold Calculator'**
  String get appTitle;

  /// No description provided for @navPrices.
  ///
  /// In en, this message translates to:
  /// **'Prices'**
  String get navPrices;

  /// No description provided for @navInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get navInvestment;

  /// No description provided for @navRetail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get navRetail;

  /// No description provided for @navZakat.
  ///
  /// In en, this message translates to:
  /// **'Zakat'**
  String get navZakat;

  /// No description provided for @languageToggleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get languageToggleTooltip;

  /// No description provided for @priceScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Gold Prices'**
  String get priceScreenTitle;

  /// No description provided for @priceLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load prices: {error}'**
  String priceLoadError(Object error);

  /// No description provided for @karatHeader.
  ///
  /// In en, this message translates to:
  /// **'Karat'**
  String get karatHeader;

  /// No description provided for @buyHeader.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buyHeader;

  /// No description provided for @sellHeader.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sellHeader;

  /// No description provided for @changeHeader.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeHeader;

  /// No description provided for @periodDayLabel.
  ///
  /// In en, this message translates to:
  /// **'1D'**
  String get periodDayLabel;

  /// No description provided for @periodWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'1W'**
  String get periodWeekLabel;

  /// No description provided for @periodMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get periodMonthLabel;

  /// No description provided for @lastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated: {value}'**
  String lastUpdatedLabel(Object value);

  /// No description provided for @cachedDataWarning.
  ///
  /// In en, this message translates to:
  /// **'Showing cached data — could not reach the server'**
  String get cachedDataWarning;

  /// No description provided for @retailScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Retail Price Breakdown'**
  String get retailScreenTitle;

  /// No description provided for @goldKaratLabel.
  ///
  /// In en, this message translates to:
  /// **'Gold karat'**
  String get goldKaratLabel;

  /// No description provided for @calculateFromLabel.
  ///
  /// In en, this message translates to:
  /// **'Calculate from'**
  String get calculateFromLabel;

  /// No description provided for @totalRetailPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Total retail price'**
  String get totalRetailPriceLabel;

  /// No description provided for @weightGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (grams)'**
  String get weightGramsLabel;

  /// No description provided for @goldMarketPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Gold market price per gram'**
  String get goldMarketPriceLabel;

  /// No description provided for @taxPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax %'**
  String get taxPercentLabel;

  /// No description provided for @pureGoldValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Pure gold value'**
  String get pureGoldValueLabel;

  /// No description provided for @taxAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax amount'**
  String get taxAmountLabel;

  /// No description provided for @priceWithoutTaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Price without tax'**
  String get priceWithoutTaxLabel;

  /// No description provided for @workmanshipChargeLabel.
  ///
  /// In en, this message translates to:
  /// **'Workmanship charge'**
  String get workmanshipChargeLabel;

  /// No description provided for @workmanshipPerGramLabel.
  ///
  /// In en, this message translates to:
  /// **'Workmanship per gram'**
  String get workmanshipPerGramLabel;

  /// No description provided for @workmanshipPercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Workmanship %'**
  String get workmanshipPercentLabel;

  /// No description provided for @dealGreatLabel.
  ///
  /// In en, this message translates to:
  /// **'Great deal'**
  String get dealGreatLabel;

  /// No description provided for @dealFairLabel.
  ///
  /// In en, this message translates to:
  /// **'Fair price'**
  String get dealFairLabel;

  /// No description provided for @dealOvervaluedLabel.
  ///
  /// In en, this message translates to:
  /// **'Overvalued'**
  String get dealOvervaluedLabel;

  /// No description provided for @dealBasisStatic.
  ///
  /// In en, this message translates to:
  /// **'Based on typical industry range'**
  String get dealBasisStatic;

  /// No description provided for @dealBasisPersonal.
  ///
  /// In en, this message translates to:
  /// **'Based on your last {count} purchases'**
  String dealBasisPersonal(Object count);

  /// No description provided for @saveCalculationTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save this calculation to your history'**
  String get saveCalculationTooltip;

  /// No description provided for @calculationSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved to your purchase history'**
  String get calculationSavedMessage;

  /// No description provided for @shopNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Shop name (optional)'**
  String get shopNameLabel;

  /// No description provided for @addPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhotoLabel;

  /// No description provided for @takePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhotoLabel;

  /// No description provided for @chooseFromGalleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGalleryLabel;

  /// No description provided for @removePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhotoLabel;

  /// No description provided for @saveRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Save purchase record'**
  String get saveRecordTitle;

  /// No description provided for @saveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonLabel;

  /// No description provided for @cancelButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonLabel;

  /// No description provided for @purchaseHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get purchaseHistoryTitle;

  /// No description provided for @noSavedRecordsMessage.
  ///
  /// In en, this message translates to:
  /// **'No saved purchases yet'**
  String get noSavedRecordsMessage;

  /// No description provided for @deleteRecordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteRecordTooltip;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the saved record and photo.'**
  String get deleteConfirmMessage;

  /// No description provided for @imagePickerUnsupportedMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera/gallery isn\'t supported on this device'**
  String get imagePickerUnsupportedMessage;

  /// No description provided for @unknownShopLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown shop'**
  String get unknownShopLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @investmentScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Gold Investment'**
  String get investmentScreenTitle;

  /// No description provided for @investmentIntroMessage.
  ///
  /// In en, this message translates to:
  /// **'See how your gold would have grown if you invested a fixed amount on a regular schedule (dollar-cost averaging).'**
  String get investmentIntroMessage;

  /// No description provided for @contributionAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount per contribution'**
  String get contributionAmountLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Contribution frequency'**
  String get frequencyLabel;

  /// No description provided for @frequencyWeeklyLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get frequencyWeeklyLabel;

  /// No description provided for @frequencyBiweeklyLabel.
  ///
  /// In en, this message translates to:
  /// **'Every 2 weeks'**
  String get frequencyBiweeklyLabel;

  /// No description provided for @frequencyMonthlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get frequencyMonthlyLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDateLabel;

  /// No description provided for @noHistoryDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Not enough price history yet to run this simulation'**
  String get noHistoryDataMessage;

  /// No description provided for @purchasesCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Contributions made'**
  String get purchasesCountLabel;

  /// No description provided for @totalInvestedLabel.
  ///
  /// In en, this message translates to:
  /// **'Total invested'**
  String get totalInvestedLabel;

  /// No description provided for @totalGramsLabel.
  ///
  /// In en, this message translates to:
  /// **'Gold accumulated'**
  String get totalGramsLabel;

  /// No description provided for @averageCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Average cost per gram'**
  String get averageCostLabel;

  /// No description provided for @currentPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Current price per gram'**
  String get currentPriceLabel;

  /// No description provided for @currentValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get currentValueLabel;

  /// No description provided for @profitLossLabel.
  ///
  /// In en, this message translates to:
  /// **'Profit / Loss'**
  String get profitLossLabel;

  /// No description provided for @zakatScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakatScreenTitle;

  /// No description provided for @goldWeightZakatLabel.
  ///
  /// In en, this message translates to:
  /// **'Total gold weight (grams, 24k-equivalent)'**
  String get goldWeightZakatLabel;

  /// No description provided for @goldPrice24kLabel.
  ///
  /// In en, this message translates to:
  /// **'24k gold price per gram'**
  String get goldPrice24kLabel;

  /// No description provided for @hawlMetLabel.
  ///
  /// In en, this message translates to:
  /// **'Hawl met (held for one lunar year)'**
  String get hawlMetLabel;

  /// No description provided for @nisabThresholdLabel.
  ///
  /// In en, this message translates to:
  /// **'Nisab threshold value'**
  String get nisabThresholdLabel;

  /// No description provided for @zakatableValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Your zakatable value'**
  String get zakatableValueLabel;

  /// No description provided for @nisabMetMessage.
  ///
  /// In en, this message translates to:
  /// **'Nisab met — zakat is due'**
  String get nisabMetMessage;

  /// No description provided for @nisabNotMetMessage.
  ///
  /// In en, this message translates to:
  /// **'Below nisab — no zakat due'**
  String get nisabNotMetMessage;

  /// No description provided for @zakatDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Zakat due'**
  String get zakatDueLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
