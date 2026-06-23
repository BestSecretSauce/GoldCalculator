import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/purchase_record.dart';

class PurchaseRecordStore {
  static const _key = 'purchase_records';
  static const _maxEntries = 200;
  static const _imagesSubdir = 'purchase_photos';

  final SharedPreferencesAsync _prefs;

  PurchaseRecordStore({SharedPreferencesAsync? prefs})
      : _prefs = prefs ?? SharedPreferencesAsync();

  Future<List<PurchaseRecord>> load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => PurchaseRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PurchaseRecord>> add(PurchaseRecord record) async {
    final current = await load();
    final updated = [...current, record];
    final trimmed = updated.length > _maxEntries
        ? updated.sublist(updated.length - _maxEntries)
        : updated;
    await _save(trimmed);
    return trimmed;
  }

  Future<List<PurchaseRecord>> delete(String id) async {
    final current = await load();
    final removed = current.where((r) => r.id == id).toList();
    final updated = current.where((r) => r.id != id).toList();
    await _save(updated);

    final imagePath = removed.isEmpty ? null : removed.first.imagePath;
    if (imagePath != null) {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    return updated;
  }

  Future<void> _save(List<PurchaseRecord> records) async {
    await _prefs.setString(
      _key,
      jsonEncode(records.map((r) => r.toJson()).toList()),
    );
  }

  /// Copies a picked image into permanent app storage and returns the new
  /// path — the image picker's own temp file isn't guaranteed to survive.
  Future<String> persistImage(String sourcePath, String recordId) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${docsDir.path}/$_imagesSubdir');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final extension = sourcePath.contains('.') ? sourcePath.split('.').last : 'jpg';
    final destPath = '${imagesDir.path}/$recordId.$extension';
    await File(sourcePath).copy(destPath);
    return destPath;
  }
}
