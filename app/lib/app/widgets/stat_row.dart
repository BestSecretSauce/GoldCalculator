import 'package:flutter/material.dart';

class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle = emphasized
        ? theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)
        : theme.textTheme.titleMedium;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: emphasized ? 4 : 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(value, style: valueStyle, textAlign: TextAlign.end),
        ],
      ),
    );
  }
}
