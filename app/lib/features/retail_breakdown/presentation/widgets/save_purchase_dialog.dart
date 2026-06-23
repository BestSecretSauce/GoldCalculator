import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../l10n/generated/app_localizations.dart';

class SavePurchaseResult {
  final String? shopName;
  final String? imagePath;

  const SavePurchaseResult({this.shopName, this.imagePath});
}

Future<SavePurchaseResult?> showSavePurchaseDialog(BuildContext context) {
  return showDialog<SavePurchaseResult>(
    context: context,
    builder: (context) => const _SavePurchaseDialog(),
  );
}

class _SavePurchaseDialog extends StatefulWidget {
  const _SavePurchaseDialog();

  @override
  State<_SavePurchaseDialog> createState() => _SavePurchaseDialogState();
}

class _SavePurchaseDialogState extends State<_SavePurchaseDialog> {
  final _shopNameController = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final l10n = AppLocalizations.of(context);
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        setState(() => _imagePath = picked.path);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.imagePickerUnsupportedMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(l10n.saveRecordTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _shopNameController,
              decoration: InputDecoration(labelText: l10n.shopNameLabel),
            ),
            const SizedBox(height: 16),
            if (_imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_imagePath!),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.takePhotoLabel),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.chooseFromGalleryLabel),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                if (_imagePath != null)
                  TextButton.icon(
                    icon: const Icon(Icons.close),
                    label: Text(l10n.removePhotoLabel),
                    onPressed: () => setState(() => _imagePath = null),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            SavePurchaseResult(
              shopName: _shopNameController.text,
              imagePath: _imagePath,
            ),
          ),
          child: Text(l10n.saveButtonLabel),
        ),
      ],
    );
  }
}
