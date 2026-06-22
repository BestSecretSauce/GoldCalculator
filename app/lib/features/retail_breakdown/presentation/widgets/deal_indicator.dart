import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/deal_quality_evaluator.dart';

class DealIndicator extends StatelessWidget {
  final DealAssessment assessment;

  const DealIndicator({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final (label, icon, background, foreground) = switch (assessment.quality) {
      DealQuality.greatDeal => (
          l10n.dealGreatLabel,
          Icons.thumb_up_outlined,
          Colors.green[50]!,
          Colors.green[800]!,
        ),
      DealQuality.fair => (
          l10n.dealFairLabel,
          Icons.check_circle_outline,
          colorScheme.surfaceContainerHighest,
          colorScheme.onSurfaceVariant,
        ),
      DealQuality.overvalued => (
          l10n.dealOvervaluedLabel,
          Icons.warning_amber_outlined,
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
        ),
    };

    final basis = assessment.isPersonalized
        ? l10n.dealBasisPersonal(assessment.sampleCount.toString())
        : l10n.dealBasisStatic;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      TextStyle(color: foreground, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  basis,
                  style: TextStyle(color: foreground, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
