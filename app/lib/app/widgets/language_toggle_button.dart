import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../locale_controller.dart';
import '../../l10n/generated/app_localizations.dart';

class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: AppLocalizations.of(context).languageToggleTooltip,
      onPressed: () => ref.read(appLocaleProvider.notifier).toggle(),
    );
  }
}
