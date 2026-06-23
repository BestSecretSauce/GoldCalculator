import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/purchase_record_store.dart';
import '../logic/purchase_record.dart';

part 'purchase_records_provider.g.dart';

@riverpod
PurchaseRecordStore purchaseRecordStore(Ref ref) => PurchaseRecordStore();

@riverpod
class PurchaseRecords extends _$PurchaseRecords {
  @override
  Future<List<PurchaseRecord>> build() {
    return ref.read(purchaseRecordStoreProvider).load();
  }

  Future<void> addRecord({
    required double retailPrice,
    required double weightGrams,
    required double goldPricePerGram,
    required double workmanshipPercent,
    String? shopName,
    String? pickedImagePath,
    String? karat,
  }) async {
    final store = ref.read(purchaseRecordStoreProvider);
    final id = const Uuid().v4();

    String? imagePath;
    if (pickedImagePath != null) {
      imagePath = await store.persistImage(pickedImagePath, id);
    }

    final record = PurchaseRecord(
      id: id,
      timestamp: DateTime.now(),
      shopName: (shopName == null || shopName.trim().isEmpty) ? null : shopName.trim(),
      imagePath: imagePath,
      retailPrice: retailPrice,
      weightGrams: weightGrams,
      goldPricePerGram: goldPricePerGram,
      workmanshipPercent: workmanshipPercent,
      karat: karat,
    );

    final updated = await store.add(record);
    state = AsyncData(updated);
  }

  Future<void> deleteRecord(String id) async {
    final store = ref.read(purchaseRecordStoreProvider);
    final updated = await store.delete(id);
    state = AsyncData(updated);
  }
}
