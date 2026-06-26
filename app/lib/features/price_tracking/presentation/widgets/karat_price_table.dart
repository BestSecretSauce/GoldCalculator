import 'package:flutter/material.dart';

import '../../../../core/models/gold_price_snapshot.dart';
import '../../../../l10n/generated/app_localizations.dart';

class KaratPriceTable extends StatelessWidget {
  final Map<String, KaratPrice> karats;
  final double? dayChange;
  final double? weekChange;
  final double? monthChange;

  const KaratPriceTable({
    super.key,
    required this.karats,
    required this.dayChange,
    required this.weekChange,
    required this.monthChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = karats.entries.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // All three period changes shown at once — no selector needed
            // since the % is identical across karat types.
            Row(
              children: [
                _PeriodBadge(label: l10n.periodDayLabel, percent: dayChange),
                const SizedBox(width: 8),
                _PeriodBadge(label: l10n.periodWeekLabel, percent: weekChange),
                const SizedBox(width: 8),
                _PeriodBadge(label: l10n.periodMonthLabel, percent: monthChange),
              ],
            ),
            const SizedBox(height: 16),
            _TableRow(
              karat: l10n.karatHeader,
              buy: l10n.buyHeader,
              sell: l10n.sellHeader,
              isHeader: true,
            ),
            const Divider(height: 16),
            for (var i = 0; i < entries.length; i++) ...[
              _TableRow(
                karat: entries[i].key,
                buy: entries[i].value.buy.toStringAsFixed(2),
                sell: entries[i].value.sell.toStringAsFixed(2),
              ),
              if (i != entries.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _PeriodBadge extends StatelessWidget {
  final String label;
  final double? percent;

  const _PeriodBadge({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (percent == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$label  —',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final isUp = percent! >= 0;
    final color = isUp ? Colors.green[700]! : Colors.red[700]!;
    final bg = isUp
        ? Colors.green.withValues(alpha: 0.1)
        : Colors.red.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: color,
            size: 16,
          ),
          Text(
            '${percent!.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String karat;
  final String buy;
  final String sell;
  final bool isHeader;

  const _TableRow({
    required this.karat,
    required this.buy,
    required this.sell,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = isHeader
        ? TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          )
        : const TextStyle(fontWeight: FontWeight.w600, fontSize: 15);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              karat,
              textAlign: TextAlign.start,
              textDirection: TextDirection.rtl,
              style: style,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              buy,
              textAlign: TextAlign.center,
              style: style.copyWith(
                color: isHeader ? null : Colors.green[700],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              sell,
              textAlign: TextAlign.center,
              style: style.copyWith(
                color: isHeader ? null : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
