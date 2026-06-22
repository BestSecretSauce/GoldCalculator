import 'package:flutter/material.dart';

import '../../../app/widgets/language_toggle_button.dart';
import '../../../app/widgets/results_card.dart';
import '../../../app/widgets/stat_row.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../logic/currency_formatter.dart';
import '../logic/unit_calculator.dart';
import '../logic/weight_unit.dart';

class UnitCalculatorScreen extends StatefulWidget {
  const UnitCalculatorScreen({super.key});

  @override
  State<UnitCalculatorScreen> createState() => _UnitCalculatorScreenState();
}

class _UnitCalculatorScreenState extends State<UnitCalculatorScreen> {
  final _weightController = TextEditingController();
  final _buyPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  WeightUnit _unit = WeightUnit.gram;
  Currency _currency = Currency.aed;

  @override
  void dispose() {
    _weightController.dispose();
    _buyPriceController.dispose();
    _sellPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final weight = double.tryParse(_weightController.text) ?? 0;
    final buyPrice = double.tryParse(_buyPriceController.text) ?? 0;
    final sellPrice = double.tryParse(_sellPriceController.text) ?? 0;
    final result = UnitCalculator.calculate(
      weight: weight,
      unit: _unit,
      buyPricePerUnit: buyPrice,
      sellPricePerUnit: sellPrice,
    );
    final isProfit = result.profit >= 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.unitScreenTitle),
        actions: const [LanguageToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.weightLabel,
              prefixIcon: const Icon(Icons.scale_outlined),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<WeightUnit>(
            initialValue: _unit,
            decoration: InputDecoration(
              labelText: l10n.unitLabel,
              prefixIcon: const Icon(Icons.straighten_outlined),
            ),
            items: WeightUnit.values
                .map((u) =>
                    DropdownMenuItem(value: u, child: Text(u.label(l10n))))
                .toList(),
            onChanged: (u) => setState(() => _unit = u!),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _buyPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.buyPricePerUnitLabel(_unit.label(l10n)),
              prefixIcon: const Icon(Icons.arrow_downward),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _sellPriceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.sellPricePerUnitLabel(_unit.label(l10n)),
              prefixIcon: const Icon(Icons.arrow_upward),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<Currency>(
            initialValue: _currency,
            decoration: InputDecoration(
              labelText: l10n.currencyLabel,
              prefixIcon: const Icon(Icons.payments_outlined),
            ),
            items: Currency.values
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text('${c.name.toUpperCase()} (${c.symbol})'),
                    ))
                .toList(),
            onChanged: (c) => setState(() => _currency = c!),
          ),
          const SizedBox(height: 24),
          ResultsCard(
            children: [
              StatRow(
                label: l10n.weightEquivalentLabel,
                value: '${result.weightInGrams.toStringAsFixed(2)} g',
              ),
              StatRow(
                label: l10n.totalCostLabel,
                value: CurrencyFormatter.format(result.totalCost, _currency),
              ),
              StatRow(
                label: l10n.totalRevenueLabel,
                value:
                    CurrencyFormatter.format(result.totalRevenue, _currency),
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.profitLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    '${CurrencyFormatter.format(result.profit, _currency)} '
                    '(${result.profitPercent.toStringAsFixed(2)}%)',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
