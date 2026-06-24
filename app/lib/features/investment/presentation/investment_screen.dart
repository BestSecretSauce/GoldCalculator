import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/utils/date_format.dart';
import '../../../app/widgets/language_toggle_button.dart';
import '../../../app/widgets/results_card.dart';
import '../../../app/widgets/stat_row.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../price_tracking/application/gold_price_provider.dart';
import '../logic/currency_formatter.dart';
import '../logic/dca_frequency.dart';
import '../logic/investment_calculator.dart';

class InvestmentScreen extends ConsumerStatefulWidget {
  const InvestmentScreen({super.key});

  @override
  ConsumerState<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends ConsumerState<InvestmentScreen> {
  final _amountController = TextEditingController(text: '500');
  DcaFrequency _frequency = DcaFrequency.monthly;
  Currency _currency = Currency.aed;
  String? _selectedKarat;
  DateTime? _startDate;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate(DateTime firstDate, DateTime lastDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final snapshot = ref.watch(goldPricesProvider).valueOrNull;
    final history = ref.watch(goldPriceHistoryProvider).valueOrNull ?? [];
    final karats = snapshot?.karats;

    if (karats != null && karats.isNotEmpty && _selectedKarat == null) {
      _selectedKarat = karats.keys.firstWhere(
        (k) => k.contains('24'),
        orElse: () => karats.keys.first,
      );
    }

    final now = DateTime.now();
    final earliestHistoryDate = history.isNotEmpty
        ? history
            .map((s) => s.timestamp)
            .reduce((a, b) => a.isBefore(b) ? a : b)
        : now.subtract(const Duration(days: 365));
    _startDate ??= earliestHistoryDate;

    final amount = double.tryParse(_amountController.text) ?? 0;
    final currentPrice =
        _selectedKarat != null ? (karats?[_selectedKarat]?.sell ?? 0) : 0.0;

    final result = (_selectedKarat != null && history.isNotEmpty)
        ? InvestmentCalculator.simulateDca(
            amountPerInterval: amount,
            startDate: _startDate!,
            frequency: _frequency,
            history: history,
            karatKey: _selectedKarat!,
            currentPricePerGram: currentPrice,
          )
        : DcaResult.empty;

    final isProfit = result.profitLoss >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.investmentScreenTitle),
        actions: const [LanguageToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Text(
            l10n.investmentIntroMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.contributionAmountLabel,
              prefixIcon: const Icon(Icons.payments_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<Currency>(
            initialValue: _currency,
            decoration: InputDecoration(
              labelText: l10n.currencyLabel,
              prefixIcon: const Icon(Icons.attach_money),
            ),
            items: Currency.values
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text('${c.name.toUpperCase()} (${c.symbol})'),
                    ))
                .toList(),
            onChanged: (c) => setState(() => _currency = c!),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<DcaFrequency>(
            initialValue: _frequency,
            decoration: InputDecoration(
              labelText: l10n.frequencyLabel,
              prefixIcon: const Icon(Icons.event_repeat_outlined),
            ),
            items: DcaFrequency.values
                .map((f) =>
                    DropdownMenuItem(value: f, child: Text(f.label(l10n))))
                .toList(),
            onChanged: (f) => setState(() => _frequency = f!),
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
              onChanged: (k) => setState(() => _selectedKarat = k),
            ),
          if (karats != null && karats.isNotEmpty) const SizedBox(height: 14),
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text('${l10n.startDateLabel}: ${formatYmd(_startDate!)}'),
            onPressed: () => _pickStartDate(earliestHistoryDate, now),
          ),
          const SizedBox(height: 24),
          if (history.isEmpty)
            Text(
              l10n.noHistoryDataMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
          else
            ResultsCard(
              children: [
                StatRow(
                  label: l10n.purchasesCountLabel,
                  value: '${result.purchases.length}',
                ),
                StatRow(
                  label: l10n.totalInvestedLabel,
                  value:
                      CurrencyFormatter.format(result.totalInvested, _currency),
                ),
                StatRow(
                  label: l10n.totalGramsLabel,
                  value: '${result.totalGrams.toStringAsFixed(2)} g',
                ),
                StatRow(
                  label: l10n.averageCostLabel,
                  value: CurrencyFormatter.format(
                      result.averageCostPerGram, _currency),
                ),
                StatRow(
                  label: l10n.currentPriceLabel,
                  value: CurrencyFormatter.format(
                      result.currentPricePerGram, _currency),
                ),
                StatRow(
                  label: l10n.currentValueLabel,
                  value:
                      CurrencyFormatter.format(result.currentValue, _currency),
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.profitLossLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      '${CurrencyFormatter.format(result.profitLoss, _currency)} '
                      '(${result.profitLossPercent.toStringAsFixed(2)}%)',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: isProfit
                                    ? Colors.green[700]
                                    : Theme.of(context).colorScheme.error,
                              ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
