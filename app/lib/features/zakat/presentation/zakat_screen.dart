import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/language_toggle_button.dart';
import '../../../app/widgets/results_card.dart';
import '../../../app/widgets/stat_row.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../price_tracking/application/gold_price_provider.dart';
import '../logic/zakat_rule.dart';
import '../logic/zakat_rule_provider.dart';

class ZakatScreen extends ConsumerStatefulWidget {
  const ZakatScreen({super.key});

  @override
  ConsumerState<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends ConsumerState<ZakatScreen> {
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  bool _hawlMet = true;
  String? _lastSyncedPriceText;
  DateTime? _lastSyncedSnapshotTimestamp;

  @override
  void dispose() {
    _weightController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _applyLivePrice(double price) {
    final text = price.toStringAsFixed(2);
    _priceController.text = text;
    _lastSyncedPriceText = text;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final rule = ref.watch(zakatRuleProvider);

    final snapshot = ref.watch(goldPricesProvider).valueOrNull;
    final karats = snapshot?.karats;
    if (karats != null && karats.isNotEmpty) {
      final karat24Key = karats.keys.firstWhere(
        (k) => k.contains('24'),
        orElse: () => karats.keys.first,
      );
      final price24k = karats[karat24Key]?.buy;
      if (price24k != null) {
        if (_lastSyncedSnapshotTimestamp == null) {
          _applyLivePrice(price24k);
          _lastSyncedSnapshotTimestamp = snapshot!.timestamp;
        } else if (snapshot!.timestamp != _lastSyncedSnapshotTimestamp) {
          if (_priceController.text == _lastSyncedPriceText) {
            _applyLivePrice(price24k);
          }
          _lastSyncedSnapshotTimestamp = snapshot.timestamp;
        }
      }
    }
    final weight = double.tryParse(_weightController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;

    final result = rule.calculate(ZakatInput(
      totalGoldWeightGrams: weight,
      pricePerGram24k: price,
      hawlMet: _hawlMet,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.zakatScreenTitle),
        actions: const [LanguageToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.goldWeightZakatLabel,
              prefixIcon: const Icon(Icons.scale_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.goldPrice24kLabel,
              prefixIcon: const Icon(Icons.trending_up),
              suffixIcon: karats != null && karats.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.sync),
                      tooltip: l10n.goldPrice24kLabel,
                      onPressed: () {
                        final key = karats.keys.firstWhere(
                          (k) => k.contains('24'),
                          orElse: () => karats.keys.first,
                        );
                        final price = karats[key]?.buy;
                        if (price != null) setState(() => _applyLivePrice(price));
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(l10n.hawlMetLabel),
              value: _hawlMet,
              onChanged: (v) => setState(() => _hawlMet = v),
            ),
          ),
          const SizedBox(height: 24),
          ResultsCard(
            children: [
              StatRow(
                label: l10n.nisabThresholdLabel,
                value: result.nisabThresholdValue.toStringAsFixed(2),
              ),
              StatRow(
                label: l10n.zakatableValueLabel,
                value: result.zakatableValue.toStringAsFixed(2),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: result.nisabMet
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      result.nisabMet
                          ? Icons.check_circle_outline
                          : Icons.info_outline,
                      size: 18,
                      color: result.nisabMet
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result.nisabMet
                            ? l10n.nisabMetMessage
                            : l10n.nisabNotMetMessage,
                        style: TextStyle(
                          color: result.nisabMet
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              StatRow(
                label: l10n.zakatDueLabel,
                value: result.zakatDue.toStringAsFixed(2),
                emphasized: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
