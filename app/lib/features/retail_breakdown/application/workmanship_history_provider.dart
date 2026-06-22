import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/workmanship_history_store.dart';

part 'workmanship_history_provider.g.dart';

@riverpod
WorkmanshipHistoryStore workmanshipHistoryStore(Ref ref) {
  return WorkmanshipHistoryStore();
}

@riverpod
class WorkmanshipHistory extends _$WorkmanshipHistory {
  @override
  Future<List<double>> build() {
    return ref.read(workmanshipHistoryStoreProvider).load();
  }

  Future<void> addRecord(double percent) async {
    final store = ref.read(workmanshipHistoryStoreProvider);
    final updated = await store.add(percent);
    state = AsyncData(updated);
  }
}
