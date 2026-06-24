import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/language_toggle_button.dart';
import '../../../app/widgets/results_card.dart';
import '../../../app/widgets/stat_row.dart';
import '../../../core/models/gold_price_snapshot.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../price_tracking/application/gold_price_provider.dart';
import '../application/purchase_records_provider.dart';
import '../logic/deal_quality_evaluator.dart';
import '../logic/retail_breakdown_calculator.dart';
import 'purchase_history_screen.dart';
import 'widgets/deal_indicator.dart';
import 'widgets/save_purchase_dialog.dart';

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
  final _workmanshipPerGramController = TextEditingController();
  final _workmanshipPercentController = TextEditingController();
  bool _includeTax = true;
  RetailInputMode _mode = RetailInputMode.totalPrice;
  String? _selectedKarat;
  String? _lastSyncedPriceText;
  DateTime? _lastSyncedSnapshotTimestamp;

  @override
  void dispose() {
    _retailPriceController.dispose();
    _weightController.dispose();
    _goldPriceController.dispose();
    _taxPercentController.dispose();
    _workmanshipPerGramController.dispose();
    _workmanshipPercentController.dispose();
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

  void _syncDerivedFields(RetailBreakdownResult result, bool hasValid) {
    if (!hasValid) return;
    switch (_mode) {
      case RetailInputMode.totalPrice:
        final pg = result.workmanshipPricePerGram.toStringAsFixed(2);
        if (_workmanshipPerGramController.text != pg) {
          _workmanshipPerGramController.text = pg;
        }
        final pc = result.workmanshipPercent.toStringAsFixed(2);
        if (_workmanshipPercentController.text != pc) {
          _workmanshipPercentController.text = pc;
        }
      case RetailInputMode.workmanshipPerGram:
        final rp = result.totalRetailPrice.toStringAsFixed(2);
        if (_retailPriceController.text != rp) {
          _retailPriceController.text = rp;
        }
        final pc = result.workmanshipPercent.toStringAsFixed(2);
        if (_workmanshipPercentController.text != pc) {
          _workmanshipPercentController.text = pc;
        }
      case RetailInputMode.workmanshipPercent:
        final rp = result.totalRetailPrice.toStringAsFixed(2);
        if (_retailPriceController.text != rp) {
          _retailPriceController.text = rp;
        }
        final pg = result.workmanshipPricePerGram.toStringAsFixed(2);
        if (_workmanshipPerGramController.text != pg) {
          _workmanshipPerGramController.text = pg;
        }
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
        if (_goldPriceController.text == _lastSyncedPriceText) {
          _applyLivePrice(karats, _selectedKarat!);
        }
        _lastSyncedSnapshotTimestamp = snapshot.timestamp;
      }
    }

    final inputValue = switch (_mode) {
      RetailInputMode.totalPrice =>
        double.tryParse(_retailPriceController.text) ?? 0,
      RetailInputMode.workmanshipPerGram =>
        double.tryParse(_workmanshipPerGramController.text) ?? 0,
      RetailInputMode.workmanshipPercent =>
        double.tryParse(_workmanshipPercentController.text) ?? 0,
    };
    final weight = double.tryParse(_weightController.text) ?? 0;
    final goldPrice = double.tryParse(_goldPriceController.text) ?? 0;
    final taxPercent = double.tryParse(_taxPercentController.text) ?? 0;

    final result = RetailBreakdownCalculator.calculate(
      mode: _mode,
      inputValue: inputValue,
      weightGrams: weight,
      goldPricePerGram: goldPrice,
      taxPercent: taxPercent,
      includeTax: _includeTax,
    );

    final hasValidCalculation = inputValue > 0 && weight > 0 && goldPrice > 0;
    _syncDerivedFields(result, hasValidCalculation);

    final records = ref.watch(purchaseRecordsProvider).valueOrNull ?? [];
    final history = records.map((r) => r.workmanshipPercent).toList();
    final assessment = hasValidCalculation
        ? DealQualityEvaluator.evaluate(
            workmanshipPercent: result.workmanshipPercent,
            history: history,
          )
        : null;

    final theme = Theme.of(context);
    final derivedStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.primary,
      fontStyle: FontStyle.italic,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.retailScreenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: l10n.purchaseHistoryTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PurchaseHistoryScreen(),
              ),
            ),
          ),
          const LanguageToggleButton(),
        ],
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
              suffixIcon: _mode != RetailInputMode.totalPrice
                  ? const Tooltip(
                      message: 'Calculated',
                      child: Icon(Icons.auto_fix_high, size: 18),
                    )
                  : null,
            ),
            onChanged: (_) => setState(() => _mode = RetailInputMode.totalPrice),
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
              const Divider(height: 20),
              // Workmanship per gram — editable; drives calculation when typed
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _workmanshipPerGramController,
                      keyboardType: TextInputType.number,
                      style: _mode == RetailInputMode.workmanshipPerGram
                          ? null
                          : derivedStyle,
                      decoration: InputDecoration(
                        labelText: l10n.workmanshipPerGramLabel,
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(
                          () => _mode = RetailInputMode.workmanshipPerGram),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Workmanship percent — editable; drives calculation when typed
                  Expanded(
                    child: TextField(
                      controller: _workmanshipPercentController,
                      keyboardType: TextInputType.number,
                      style: _mode == RetailInputMode.workmanshipPercent
                          ? null
                          : derivedStyle,
                      decoration: InputDecoration(
                        labelText: l10n.workmanshipPercentLabel,
                        suffixText: '%',
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(
                          () => _mode = RetailInputMode.workmanshipPercent),
                    ),
                  ),
                ],
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
                final saveResult = await showSavePurchaseDialog(context);
                if (saveResult == null) return;
                await ref.read(purchaseRecordsProvider.notifier).addRecord(
                      retailPrice: result.totalRetailPrice,
                      weightGrams: weight,
                      goldPricePerGram: goldPrice,
                      workmanshipPercent: result.workmanshipPercent,
                      shopName: saveResult.shopName,
                      pickedImagePath: saveResult.imagePath,
                      karat: _selectedKarat,
                    );
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
