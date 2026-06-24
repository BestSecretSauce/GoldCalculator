import 'dart:convert';

import '../../../core/models/gold_price_snapshot.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exceptions.dart';
import 'gold_price_local_cache.dart';

class GoldPriceRepository {
  final ApiClient _apiClient;
  final GoldPriceLocalCache _cache;

  GoldPriceRepository({
    required ApiClient apiClient,
    required GoldPriceLocalCache cache,
  })  : _apiClient = apiClient,
        _cache = cache;

  Future<GoldPriceSnapshot> fetchLatest() async {
    try {
      final json = await _apiClient.fetchLatestGoldPrice();
      await _cache.save(jsonEncode(json));
      return GoldPriceSnapshot.fromJson(json);
    } on ApiException {
      final cached = await loadCached();
      if (cached != null) return cached;
      rethrow;
    }
  }

  /// Reads the last successfully fetched snapshot from local storage without
  /// touching the network, so the UI has something to show immediately while
  /// a slow/cold-starting backend wakes up.
  Future<GoldPriceSnapshot?> loadCached() async {
    final cachedJson = await _cache.load();
    if (cachedJson == null) return null;
    return GoldPriceSnapshot.fromJson(
      jsonDecode(cachedJson) as Map<String, dynamic>,
      isFromCache: true,
    );
  }

  Future<GoldPriceSnapshot> refresh() async {
    await _apiClient.triggerRescrape();
    return fetchLatest();
  }

  Future<List<GoldPriceSnapshot>> fetchHistory() async {
    final history = await _apiClient.fetchGoldPriceHistory();
    return history.map(GoldPriceSnapshot.fromJson).toList();
  }
}
