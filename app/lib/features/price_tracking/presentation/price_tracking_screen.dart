import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/widgets/language_toggle_button.dart';
import '../../../core/models/gold_price_snapshot.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/gold_price_provider.dart';
import '../logic/price_change_calculator.dart';
import 'widgets/karat_price_table.dart';
import 'widgets/last_updated_banner.dart';

class PriceTrackingScreen extends ConsumerWidget {
  const PriceTrackingScreen({super.key});

  Widget _buildBody(
    BuildContext context,
    AsyncValue<GoldPriceSnapshot> pricesAsync,
    double? dayChange,
    double? weekChange,
    double? monthChange,
    AppLocalizations l10n,
    WidgetRef ref,
  ) {
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
            dayChange: dayChange,
            weekChange: weekChange,
            monthChange: monthChange,
          ),
        ],
      );
    }

    if (pricesAsync.isLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    }

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
            onPressed: () => ref.read(goldPricesProvider.notifier).refresh(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pricesAsync = ref.watch(goldPricesProvider);
    final history = ref.watch(goldPriceHistoryProvider).valueOrNull ?? [];

    // All karats move by the same percentage so one value per period is enough.
    double? firstChange(PriceChangePeriod period) {
      final changes =
          PriceChangeCalculator.calculate(history: history, period: period);
      return changes.values.firstOrNull;
    }

    final dayChange = firstChange(PriceChangePeriod.day);
    final weekChange = firstChange(PriceChangePeriod.week);
    final monthChange = firstChange(PriceChangePeriod.month);

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
          child: _buildBody(
              context, pricesAsync, dayChange, weekChange, monthChange, l10n, ref),
        ),
      ),
    );
  }
}
