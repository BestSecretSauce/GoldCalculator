import 'package:shared_preferences/shared_preferences.dart';

class GoldPriceLocalCache {
  static const _key = 'gold_prices_cache_json';

  final SharedPreferencesAsync _prefs;

  GoldPriceLocalCache({SharedPreferencesAsync? prefs})
      : _prefs = prefs ?? SharedPreferencesAsync();

  Future<void> save(String rawJson) => _prefs.setString(_key, rawJson);

  Future<String?> load() => _prefs.getString(_key);
}
