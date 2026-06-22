import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/language_toggle_button.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/gold_price_provider.dart';
import '../logic/price_change_calculator.dart';
import 'widgets/karat_price_table.dart';
import 'widgets/last_updated_banner.dart';

class PriceTrackingScreen extends ConsumerStatefulWidget {
  const PriceTrackingScreen({super.key});

  @override
  ConsumerState<PriceTrackingScreen> createState() =>
      _PriceTrackingScreenState();
}

class _PriceTrackingScreenState extends ConsumerState<PriceTrackingScreen> {
  PriceChangePeriod _selectedPeriod = PriceChangePeriod.day;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pricesAsync = ref.watch(goldPricesProvider);
    final history = ref.watch(goldPriceHistoryProvider).valueOrNull ?? [];
    final priceChanges = PriceChangeCalculator.calculate(
      history: history,
      period: _selectedPeriod,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.priceScreenTitle),
        actions: [
          const LanguageToggleButton(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(goldPricesProvider.notifier).refresh(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(goldPricesProvider.notifier).refresh(),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: pricesAsync.when(
            loading: () => const Center(
              key: ValueKey('loading'),
              child: CircularProgressIndicator(),
            ),
            error: (error, _) => ListView(
              key: const ValueKey('error'),
              children: [
                const SizedBox(height: 80),
                Center(child: Text(l10n.priceLoadError(error.toString()))),
              ],
            ),
            data: (snapshot) => ListView(
              key: const ValueKey('data'),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                LastUpdatedBanner(
                  lastUpdated: snapshot.lastUpdated,
                  isFromCache: snapshot.isFromCache,
                ),
                const SizedBox(height: 16),
                KaratPriceTable(
                  karats: snapshot.karats,
                  priceChanges: priceChanges,
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) =>
                      setState(() => _selectedPeriod = period),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
