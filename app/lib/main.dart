import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/locale_controller.dart';
import 'app/theme.dart';
import 'features/price_tracking/presentation/price_tracking_screen.dart';
import 'features/retail_breakdown/presentation/retail_breakdown_screen.dart';
import 'features/unit_calculator/presentation/unit_calculator_screen.dart';
import 'features/zakat/presentation/zakat_screen.dart';
import 'l10n/generated/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: GoldCalculatorApp()));
}

class GoldCalculatorApp extends ConsumerWidget {
  const GoldCalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(appLocaleProvider);

    return MaterialApp(
      title: 'Gold Calculator',
      theme: goldCalculatorTheme,
      locale: localeAsync.valueOrNull,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: localeAsync.isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const _screens = [
    PriceTrackingScreen(),
    UnitCalculatorScreen(),
    RetailBreakdownScreen(),
    ZakatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.trending_up), label: l10n.navPrices),
          NavigationDestination(
              icon: const Icon(Icons.calculate), label: l10n.navUnit),
          NavigationDestination(
              icon: const Icon(Icons.receipt_long), label: l10n.navRetail),
          NavigationDestination(
              icon: const Icon(Icons.volunteer_activism),
              label: l10n.navZakat),
        ],
      ),
    );
  }
}
