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
  String get navInvestment => 'الاستثمار';

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
  String get calculateFromLabel => 'احسب باستخدام';

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
  String get shopNameLabel => 'اسم المحل (اختياري)';

  @override
  String get addPhotoLabel => 'إضافة صورة';

  @override
  String get takePhotoLabel => 'تصوير';

  @override
  String get chooseFromGalleryLabel => 'اختيار من المعرض';

  @override
  String get removePhotoLabel => 'إزالة الصورة';

  @override
  String get saveRecordTitle => 'حفظ سجل الشراء';

  @override
  String get saveButtonLabel => 'حفظ';

  @override
  String get cancelButtonLabel => 'إلغاء';

  @override
  String get purchaseHistoryTitle => 'سجل المشتريات';

  @override
  String get noSavedRecordsMessage => 'لا توجد مشتريات محفوظة بعد';

  @override
  String get deleteRecordTooltip => 'حذف';

  @override
  String get deleteConfirmTitle => 'حذف هذا السجل؟';

  @override
  String get deleteConfirmMessage => 'سيتم حذف السجل والصورة المحفوظة نهائيًا.';

  @override
  String get imagePickerUnsupportedMessage =>
      'الكاميرا/المعرض غير مدعومة على هذا الجهاز';

  @override
  String get unknownShopLabel => 'محل غير معروف';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get investmentScreenTitle => 'استثمار الذهب';

  @override
  String get investmentIntroMessage =>
      'تعرف على نمو استثمارك في الذهب لو كنت تستثمر مبلغًا ثابتًا على فترات منتظمة (الشراء بالتكلفة الدولارية المتوسطة).';

  @override
  String get contributionAmountLabel => 'المبلغ لكل دفعة';

  @override
  String get currencyLabel => 'العملة';

  @override
  String get frequencyLabel => 'تكرار الدفعات';

  @override
  String get frequencyWeeklyLabel => 'أسبوعيًا';

  @override
  String get frequencyBiweeklyLabel => 'كل أسبوعين';

  @override
  String get frequencyMonthlyLabel => 'شهريًا';

  @override
  String get startDateLabel => 'تاريخ البدء';

  @override
  String get noHistoryDataMessage =>
      'لا تتوفر بيانات أسعار كافية لإجراء هذا المحاكاة حاليًا';

  @override
  String get purchasesCountLabel => 'عدد الدفعات';

  @override
  String get totalInvestedLabel => 'إجمالي المستثمر';

  @override
  String get totalGramsLabel => 'كمية الذهب المتراكمة';

  @override
  String get averageCostLabel => 'متوسط التكلفة للجرام';

  @override
  String get currentPriceLabel => 'السعر الحالي للجرام';

  @override
  String get currentValueLabel => 'القيمة الحالية';

  @override
  String get profitLossLabel => 'الربح / الخسارة';

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
