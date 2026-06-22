// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حاسبة الذهب';

  @override
  String get navPrices => 'الأسعار';

  @override
  String get navUnit => 'الوحدة';

  @override
  String get navRetail => 'التجزئة';

  @override
  String get navZakat => 'الزكاة';

  @override
  String get languageToggleTooltip => 'تغيير اللغة';

  @override
  String get priceScreenTitle => 'أسعار الذهب';

  @override
  String priceLoadError(Object error) {
    return 'تعذر تحميل الأسعار: $error';
  }

  @override
  String get karatHeader => 'العيار';

  @override
  String get buyHeader => 'شراء';

  @override
  String get sellHeader => 'بيع';

  @override
  String get changeHeader => 'التغير';

  @override
  String get periodDayLabel => 'يوم';

  @override
  String get periodWeekLabel => 'أسبوع';

  @override
  String get periodMonthLabel => 'شهر';

  @override
  String lastUpdatedLabel(Object value) {
    return 'آخر تحديث: $value';
  }

  @override
  String get cachedDataWarning =>
      'عرض بيانات محفوظة مسبقًا — تعذر الاتصال بالخادم';

  @override
  String get retailScreenTitle => 'تفصيل سعر التجزئة';

  @override
  String get goldKaratLabel => 'عيار الذهب';

  @override
  String get totalRetailPriceLabel => 'السعر الإجمالي للتجزئة';

  @override
  String get weightGramsLabel => 'الوزن (جرام)';

  @override
  String get goldMarketPriceLabel => 'سعر الذهب في السوق للجرام';

  @override
  String get taxPercentLabel => 'نسبة الضريبة %';

  @override
  String get pureGoldValueLabel => 'قيمة الذهب الخام';

  @override
  String get taxAmountLabel => 'قيمة الضريبة';

  @override
  String get priceWithoutTaxLabel => 'السعر بدون ضريبة';

  @override
  String get workmanshipChargeLabel => 'أجرة المصنعية';

  @override
  String get workmanshipPerGramLabel => 'المصنعية للجرام';

  @override
  String get workmanshipPercentLabel => 'نسبة المصنعية';

  @override
  String get dealGreatLabel => 'صفقة رائعة';

  @override
  String get dealFairLabel => 'سعر عادل';

  @override
  String get dealOvervaluedLabel => 'سعر مرتفع';

  @override
  String get dealBasisStatic => 'بناءً على المعدل المعتاد في السوق';

  @override
  String dealBasisPersonal(Object count) {
    return 'بناءً على آخر $count عملية شراء لك';
  }

  @override
  String get saveCalculationTooltip => 'حفظ هذا الحساب في سجلك';

  @override
  String get calculationSavedMessage => 'تم الحفظ في سجل مشترياتك';

  @override
  String get unitScreenTitle => 'حاسبة الوحدات';

  @override
  String get weightLabel => 'الوزن';

  @override
  String get unitLabel => 'الوحدة';

  @override
  String buyPricePerUnitLabel(Object unit) {
    return 'سعر الشراء لكل $unit';
  }

  @override
  String sellPricePerUnitLabel(Object unit) {
    return 'سعر البيع لكل $unit';
  }

  @override
  String get currencyLabel => 'العملة';

  @override
  String get weightEquivalentLabel => 'ما يعادل الوزن';

  @override
  String get totalCostLabel => 'التكلفة الإجمالية';

  @override
  String get totalRevenueLabel => 'الإيراد الإجمالي';

  @override
  String get profitLabel => 'الربح';

  @override
  String get unitGram => 'جرام';

  @override
  String get unitOunce => 'أونصة';

  @override
  String get unitKilogram => 'كيلوجرام';

  @override
  String get unitTola => 'تولة';

  @override
  String get zakatScreenTitle => 'حاسبة الزكاة';

  @override
  String get goldWeightZakatLabel =>
      'إجمالي وزن الذهب (جرام، ما يعادل عيار 24)';

  @override
  String get goldPrice24kLabel => 'سعر جرام الذهب عيار 24';

  @override
  String get hawlMetLabel => 'تم استيفاء الحول (مرّ عليه عام هجري كامل)';

  @override
  String get nisabThresholdLabel => 'قيمة حد النصاب';

  @override
  String get zakatableValueLabel => 'القيمة الخاضعة للزكاة';

  @override
  String get nisabMetMessage => 'تم بلوغ النصاب — الزكاة واجبة';

  @override
  String get nisabNotMetMessage => 'أقل من النصاب — لا زكاة واجبة';

  @override
  String get zakatDueLabel => 'الزكاة الواجبة';
}
