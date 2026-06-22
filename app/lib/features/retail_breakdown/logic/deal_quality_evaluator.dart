enum DealQuality { greatDeal, fair, overvalued }

class DealAssessment {
  final DealQuality quality;
  final bool isPersonalized;
  final int sampleCount;
  final double baselineLow;
  final double baselineHigh;

  const DealAssessment({
    required this.quality,
    required this.isPersonalized,
    required this.sampleCount,
    required this.baselineLow,
    required this.baselineHigh,
  });
}

/// Estimates whether a workmanship percentage is a good deal.
///
/// With fewer than [minHistoryForPersonalization] saved purchases there is no
/// real data to compare against, so a static industry-typical range is used
/// instead. Once enough history exists, the baseline switches to a band
/// around the average of the user's own past purchases.
class DealQualityEvaluator {
  static const int minHistoryForPersonalization = 5;
  static const double staticLowPercent = 8;
  static const double staticHighPercent = 20;
  static const double personalBandFraction = 0.15;

  static DealAssessment evaluate({
    required double workmanshipPercent,
    required List<double> history,
  }) {
    final usePersonal = history.length >= minHistoryForPersonalization;
    double low;
    double high;

    if (usePersonal) {
      final average = history.reduce((a, b) => a + b) / history.length;
      low = average * (1 - personalBandFraction);
      high = average * (1 + personalBandFraction);
    } else {
      low = staticLowPercent;
      high = staticHighPercent;
    }

    final quality = workmanshipPercent < low
        ? DealQuality.greatDeal
        : workmanshipPercent > high
            ? DealQuality.overvalued
            : DealQuality.fair;

    return DealAssessment(
      quality: quality,
      isPersonalized: usePersonal,
      sampleCount: history.length,
      baselineLow: low,
      baselineHigh: high,
    );
  }
}
