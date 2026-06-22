import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WorkmanshipHistoryStore {
  static const _key = 'workmanship_history_percentages';
  static const _maxEntries = 50;

  final SharedPreferencesAsync _prefs;

  WorkmanshipHistoryStore({SharedPreferencesAsync? prefs})
      : _prefs = prefs ?? SharedPreferencesAsync();

  Future<List<double>> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => (e as num).toDouble()).toList();
  }

  Future<List<double>> add(double percent) async {
    final current = await load();
    final updated = [...current, percent];
    final trimmed = updated.length > _maxEntries
        ? updated.sublist(updated.length - _maxEntries)
        : updated;
    await _prefs.setString(_key, jsonEncode(trimmed));
    return trimmed;
  }
}
