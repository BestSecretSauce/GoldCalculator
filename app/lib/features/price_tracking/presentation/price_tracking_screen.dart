import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/language_toggle_button.dart';
import '../../../core/models/gold_price_snapshot.dart';
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

  Widget _buildBody(
    AsyncValue<GoldPriceSnapshot> pricesAsync,
    Map<String, double> priceChanges,
    AppLocalizations l10n,
  ) {
    // Always prefer showing data over loading/error states. valueOrNull
    // returns the cached snapshot even when a background refresh is in
    // progress or has failed, so users see prices immediately on every
    // visit after the first one.
    final snapshot = pricesAsync.valueOrNull;

    if (snapshot != null) {
      return ListView(
        key: const ValueKey('data'),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          LastUpdatedBanner(
            lastUpdated: snapshot.lastUpdated,
            isFromCache: snapshot.isFromCache || pricesAsync.hasError,
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
      );
    }

    // No cached data at all — first-ever launch while server is still
    // waking up (Render free-tier cold start). Show a spinner while
    // loading, or a soft offline prompt if the connection timed out.
    if (pricesAsync.isLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    }

    // Error with no data to fall back on: friendly offline state.
    return ListView(
      key: const ValueKey('offline'),
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.cloud_off_outlined,
          size: 56,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        Center(child: Text(l10n.cachedDataWarning)),
        const SizedBox(height: 24),
        Center(
          child: FilledButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            onPressed: () =>
                ref.read(goldPricesProvider.notifier).refresh(),
          ),
        ),
      ],
    );
  }

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
          child: _buildBody(pricesAsync, priceChanges, l10n),
        ),
      ),
    );
  }
}
