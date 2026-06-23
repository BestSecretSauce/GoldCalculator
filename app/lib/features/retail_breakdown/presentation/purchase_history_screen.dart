import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/utils/date_format.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/purchase_records_provider.dart';
import '../logic/purchase_record.dart';
import 'purchase_record_detail_screen.dart';

class PurchaseHistoryScreen extends ConsumerWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final recordsAsync = ref.watch(purchaseRecordsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.purchaseHistoryTitle)),
      body: recordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (records) {
          if (records.isEmpty) {
            return Center(child: Text(l10n.noSavedRecordsMessage));
          }
          final sorted = records.reversed.toList();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _PurchaseRecordCard(
              record: sorted[index],
            ),
          );
        },
      ),
    );
  }
}

class _PurchaseRecordCard extends ConsumerWidget {
  final PurchaseRecord record;

  const _PurchaseRecordCard({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PurchaseRecordDetailScreen(record: record),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: record.imagePath != null
                    ? Image.file(
                        File(record.imagePath!),
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 64,
                        height: 64,
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.diamond_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.shopName ?? l10n.unknownShopLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatYmd(record.timestamp),
                      style: TextStyle(
                          fontSize: 12, color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${record.retailPrice.toStringAsFixed(2)} · '
                      '${record.workmanshipPercent.toStringAsFixed(2)}%',
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: l10n.deleteRecordTooltip,
                onPressed: () => _confirmDelete(context, ref, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.deleteRecordTooltip),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(purchaseRecordsProvider.notifier).deleteRecord(record.id);
    }
  }
}
