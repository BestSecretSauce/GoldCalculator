import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/language_toggle_button.dart';
import '../../../app/widgets/results_card.dart';
import '../../../app/widgets/stat_row.dart';
import '../../../core/models/gold_price_snapshot.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../price_tracking/application/gold_price_provider.dart';
import '../application/workmanship_history_provider.dart';
import '../logic/deal_quality_evaluator.dart';
import '../logic/retail_breakdown_calculator.dart';
import 'widgets/deal_indicator.dart';

class RetailBreakdownScreen extends ConsumerStatefulWidget {
  const RetailBreakdownScreen({super.key});

  @override
  ConsumerState<RetailBreakdownScreen> createState() =>
      _RetailBreakdownScreenState();
}

class _RetailBreakdownScreenState
    extends ConsumerState<RetailBreakdownScreen> {
  final _retailPriceController = TextEditingController();
  final _weightController = TextEditingController();
  final _goldPriceController = TextEditingController();
  final _taxPercentController = TextEditingController(text: '5');
  bool _includeTax = true;
  String? _selectedKarat;
  String? _lastSyncedPriceText;
  DateTime? _lastSyncedSnapshotTimestamp;

  @override
  void dispose() {
    _retailPriceController.dispose();
    _weightController.dispose();
    _goldPriceController.dispose();
    _taxPercentController.dispose();
    super.dispose();
  }

  void _applyLivePrice(Map<String, KaratPrice> karats, String karat) {
    final price = karats[karat];
    if (price != null) {
      final text = price.buy.toStringAsFixed(2);
      _goldPriceController.text = text;
      _lastSyncedPriceText = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snapshot = ref.watch(goldPricesProvider).valueOrNull;
    final karats = snapshot?.karats;

    if (karats != null && karats.isNotEmpty) {
      if (_selectedKarat == null) {
        _selectedKarat = karats.keys.firstWhere(
          (k) => k.contains('21'),
          orElse: () => karats.keys.first,
        );
        _applyLivePrice(karats, _selectedKarat!);
        _lastSyncedSnapshotTimestamp = snapshot!.timestamp;
      } else if (snapshot!.timestamp != _lastSyncedSnapshotTimestamp) {
        // New live data arrived (e.g. the Prices tab was refreshed). Only
        // overwrite the field if the user hasn't diverged from the last
        // value we synced in — otherwise a manual edit would be clobbered.
        if (_goldPriceController.text == _lastSyncedPriceText) {
          _applyLivePrice(karats, _selectedKarat!);
        }
        _lastSyncedSnapshotTimestamp = snapshot.timestamp;
      }
    }

    final retailPrice = double.tryParse(_retailPriceController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final goldPrice = double.tryParse(_goldPriceController.text) ?? 0;
    final taxPercent = double.tryParse(_taxPercentController.text) ?? 0;

    final result = RetailBreakdownCalculator.calculate(
      retailPrice: retailPrice,
      weightGrams: weight,
      goldPricePerGram: goldPrice,
      taxPercent: taxPercent,
      includeTax: _includeTax,
    );

    final hasValidCalculation = retailPrice > 0 && weight > 0;
    final history = ref.watch(workmanshipHistoryProvider).valueOrNull ?? [];
    final assessment = hasValidCalculation
        ? DealQualityEvaluator.evaluate(
            workmanshipPercent: result.workmanshipPercent,
            history: history,
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.retailScreenTitle),
        actions: const [LanguageToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          TextField(
            controller: _retailPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.totalRetailPriceLabel,
              prefixIcon: const Icon(Icons.sell_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.weightGramsLabel,
              prefixIcon: const Icon(Icons.scale_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          if (karats != null && karats.isNotEmpty)
            DropdownButtonFormField<String>(
              initialValue: _selectedKarat,
              decoration: InputDecoration(
                labelText: l10n.goldKaratLabel,
                prefixIcon: const Icon(Icons.workspace_premium_outlined),
              ),
              items: karats.keys
                  .map((k) => DropdownMenuItem(
                        value: k,
                        child: Text(k, textDirection: TextDirection.rtl),
                      ))
                  .toList(),
              onChanged: (k) {
                if (k == null) return;
                setState(() {
                  _selectedKarat = k;
                  _applyLivePrice(karats, k);
                });
              },
            ),
          if (karats != null && karats.isNotEmpty) const SizedBox(height: 14),
          TextField(
            controller: _goldPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.goldMarketPriceLabel,
              prefixIcon: const Icon(Icons.trending_up),
              suffixIcon: karats != null &&
                      karats.isNotEmpty &&
                      _selectedKarat != null
                  ? IconButton(
                      icon: const Icon(Icons.sync),
                      tooltip: l10n.goldKaratLabel,
                      onPressed: () => setState(
                          () => _applyLivePrice(karats, _selectedKarat!)),
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taxPercentController,
                  keyboardType: TextInputType.number,
                  enabled: _includeTax,
                  decoration: InputDecoration(
                    labelText: l10n.taxPercentLabel,
                    prefixIcon: const Icon(Icons.percent),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: _includeTax,
                onChanged: (v) => setState(() => _includeTax = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ResultsCard(
            children: [
              StatRow(
                label: l10n.pureGoldValueLabel,
                value: result.pureGoldValue.toStringAsFixed(2),
              ),
              StatRow(
                label: l10n.taxAmountLabel,
                value: result.taxAmount.toStringAsFixed(2),
              ),
              StatRow(
                label: l10n.priceWithoutTaxLabel,
                value: result.retailWithoutTax.toStringAsFixed(2),
              ),
              StatRow(
                label: l10n.workmanshipChargeLabel,
                value: result.workmanshipPrice.toStringAsFixed(2),
              ),
              StatRow(
                label: l10n.workmanshipPerGramLabel,
                value: result.workmanshipPricePerGram.toStringAsFixed(2),
              ),
              const Divider(height: 20),
              StatRow(
                label: l10n.workmanshipPercentLabel,
                value: '${result.workmanshipPercent.toStringAsFixed(2)}%',
                emphasized: true,
              ),
              if (assessment != null) ...[
                const SizedBox(height: 12),
                DealIndicator(assessment: assessment),
              ],
            ],
          ),
          if (hasValidCalculation) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.bookmark_add_outlined),
              label: Text(l10n.saveCalculationTooltip),
              onPressed: () async {
                await ref
                    .read(workmanshipHistoryProvider.notifier)
                    .addRecord(result.workmanshipPercent);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.calculationSavedMessage)),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
