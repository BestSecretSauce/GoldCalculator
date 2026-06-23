import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/utils/date_format.dart';
import '../../../app/widgets/results_card.dart';
import '../../../app/widgets/stat_row.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../application/purchase_records_provider.dart';
import '../logic/purchase_record.dart';

class PurchaseRecordDetailScreen extends ConsumerWidget {
  final PurchaseRecord record;

  const PurchaseRecordDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(record.shopName ?? l10n.unknownShopLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.deleteRecordTooltip,
            onPressed: () => _confirmDelete(context, ref, l10n),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (record.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(record.imagePath!),
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.diamond_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 20),
          ResultsCard(
            children: [
              StatRow(
                label: l10n.shopNameLabel,
                value: record.shopName ?? l10n.unknownShopLabel,
              ),
              StatRow(label: l10n.dateLabel, value: formatYmd(record.timestamp)),
              if (record.karat != null)
                StatRow(
                  label: l10n.goldKaratLabel,
                  value: record.karat!,
                ),
              StatRow(
                label: l10n.totalRetailPriceLabel,
                value: record.retailPrice.toStringAsFixed(2),
              ),
              StatRow(
                label: l10n.weightGramsLabel,
                value: record.weightGrams.toStringAsFixed(2),
              ),
              StatRow(
                label: l10n.goldMarketPriceLabel,
                value: record.goldPricePerGram.toStringAsFixed(2),
              ),
              const Divider(height: 20),
              StatRow(
                label: l10n.workmanshipPercentLabel,
                value: '${record.workmanshipPercent.toStringAsFixed(2)}%',
                emphasized: true,
              ),
            ],
          ),
        ],
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
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
