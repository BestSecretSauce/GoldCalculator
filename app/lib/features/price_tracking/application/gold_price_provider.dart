import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/config.dart';
import '../../../core/models/gold_price_snapshot.dart';
import '../../../core/network/api_client.dart';
import '../data/gold_price_local_cache.dart';
import '../data/gold_price_repository.dart';

part 'gold_price_provider.g.dart';

@riverpod
GoldPriceRepository goldPriceRepository(Ref ref) {
  return GoldPriceRepository(
    apiClient: ApiClient(baseUrl: AppConfig.apiBaseUrl),
    cache: GoldPriceLocalCache(),
  );
}

@riverpod
class GoldPrices extends _$GoldPrices {
  @override
  Future<GoldPriceSnapshot> build() async {
    final repository = ref.read(goldPriceRepositoryProvider);
    final cached = await repository.loadCached();
    if (cached == null) {
      return repository.fetchLatest();
    }
    // Show the cached snapshot immediately, then quietly try to replace it
    // with fresh data — keeps the UI from blocking on a slow/cold-starting
    // backend instead of sitting on a spinner.
    _refreshInBackground(repository);
    return cached;
  }

  Future<void> _refreshInBackground(GoldPriceRepository repository) async {
    try {
      final fresh = await repository.fetchLatest();
      if (!fresh.isFromCache) {
        state = AsyncData(fresh);
      }
    } catch (_) {
      // Keep showing the cached snapshot; the user can pull-to-refresh.
    }
  }

  Future<void> refresh() async {
    final repository = ref.read(goldPriceRepositoryProvider);
    state = AsyncLoading<GoldPriceSnapshot>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => repository.refresh());
    ref.invalidate(goldPriceHistoryProvider);
  }
}

@riverpod
Future<List<GoldPriceSnapshot>> goldPriceHistory(Ref ref) {
  return ref.read(goldPriceRepositoryProvider).fetchHistory();
}
