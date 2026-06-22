import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_controller.g.dart';

const _localePrefsKey = 'app_locale';

@riverpod
class AppLocale extends _$AppLocale {
  @override
  Future<Locale> build() async {
    final prefs = SharedPreferencesAsync();
    final code = await prefs.getString(_localePrefsKey);
    return Locale(code ?? 'ar');
  }

  Future<void> toggle() async {
    final current = state.valueOrNull?.languageCode ?? 'ar';
    final next = current == 'ar' ? 'en' : 'ar';
    final prefs = SharedPreferencesAsync();
    await prefs.setString(_localePrefsKey, next);
    state = AsyncData(Locale(next));
  }
}
