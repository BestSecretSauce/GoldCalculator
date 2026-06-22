import 'package:flutter/material.dart';

const _seedColor = Color(0xFFCFA935);

final ColorScheme goldColorScheme = ColorScheme.fromSeed(
  seedColor: _seedColor,
  brightness: Brightness.light,
);

final ThemeData goldCalculatorTheme = ThemeData(
  useMaterial3: true,
  colorScheme: goldColorScheme,
  scaffoldBackgroundColor: goldColorScheme.surface,
  visualDensity: VisualDensity.standard,
  splashFactory: InkSparkle.splashFactory,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
    },
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 2,
    centerTitle: true,
    backgroundColor: goldColorScheme.surface,
    foregroundColor: goldColorScheme.onSurface,
    surfaceTintColor: goldColorScheme.surfaceTint,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: goldColorScheme.onSurface,
      letterSpacing: 0.1,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    elevation: 1,
    height: 70,
    backgroundColor: goldColorScheme.surfaceContainer,
    indicatorColor: goldColorScheme.primaryContainer,
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return TextStyle(
        fontSize: 12,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        color: selected
            ? goldColorScheme.onSurface
            : goldColorScheme.onSurfaceVariant,
      );
    }),
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: goldColorScheme.surfaceContainerHigh,
    surfaceTintColor: Colors.transparent,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: goldColorScheme.surfaceContainerHighest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: goldColorScheme.primary, width: 2),
    ),
    labelStyle: TextStyle(color: goldColorScheme.onSurfaceVariant),
    floatingLabelStyle: TextStyle(
      color: goldColorScheme.primary,
      fontWeight: FontWeight.w600,
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? goldColorScheme.primary
          : null;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? goldColorScheme.primaryContainer
          : null;
    }),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: goldColorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontWeight: FontWeight.w600),
  ).apply(
    bodyColor: goldColorScheme.onSurface,
    displayColor: goldColorScheme.onSurface,
  ),
);
