import 'package:flutter/material.dart';

import '../../../../core/models/gold_price_snapshot.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/price_change_calculator.dart';

class KaratPriceTable extends StatelessWidget {
  final Map<String, KaratPrice> karats;
  final Map<String, double> priceChanges;
  final PriceChangePeriod selectedPeriod;
  final ValueChanged<PriceChangePeriod> onPeriodChanged;

  const KaratPriceTable({
    super.key,
    required this.karats,
    required this.priceChanges,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = karats.entries.toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
        child: Column(
          children: [
            SegmentedButton<PriceChangePeriod>(
              segments: [
                ButtonSegment(
                  value: PriceChangePeriod.day,
                  label: Text(l10n.periodDayLabel),
                ),
                ButtonSegment(
                  value: PriceChangePeriod.week,
                  label: Text(l10n.periodWeekLabel),
                ),
                ButtonSegment(
                  value: PriceChangePeriod.month,
                  label: Text(l10n.periodMonthLabel),
                ),
              ],
              selected: {selectedPeriod},
              onSelectionChanged: (selection) =>
                  onPeriodChanged(selection.first),
            ),
            const SizedBox(height: 16),
            _TableRow(
              karat: l10n.karatHeader,
              buy: l10n.buyHeader,
              sell: l10n.sellHeader,
              change: l10n.changeHeader,
              isHeader: true,
            ),
            const Divider(height: 16),
            for (var i = 0; i < entries.length; i++) ...[
              _TableRow(
                karat: entries[i].key,
                buy: entries[i].value.buy.toStringAsFixed(2),
                sell: entries[i].value.sell.toStringAsFixed(2),
                changePercent: priceChanges[entries[i].key],
              ),
              if (i != entries.length - 1) const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  final String karat;
  final String buy;
  final String sell;
  final String? change;
  final double? changePercent;
  final bool isHeader;

  const _TableRow({
    required this.karat,
    required this.buy,
    required this.sell,
    this.change,
    this.changePercent,
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
            flex: 3,
            child: Text(
              karat,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: style,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              buy,
              textAlign: TextAlign.center,
              style: style.copyWith(
                color: isHeader ? null : Colors.green[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              sell,
              textAlign: TextAlign.center,
              style: style.copyWith(
                color: isHeader ? null : Colors.red[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isHeader
                ? Text(change ?? '', textAlign: TextAlign.center, style: style)
                : _ChangeBadge(percent: changePercent),
          ),
        ],
      ),
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  final double? percent;

  const _ChangeBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    if (percent == null) {
      return Center(
        child: Text(
          '—',
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      );
    }

    final isUp = percent! >= 0;
    final color = isUp ? Colors.green[700] : Colors.red[700];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: color,
          size: 20,
        ),
        Text(
          '${percent!.abs().toStringAsFixed(1)}%',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
