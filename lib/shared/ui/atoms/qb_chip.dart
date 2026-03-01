import 'package:flutter/material.dart';

class QBChip extends StatelessWidget {
  const QBChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(
        color: selected ? colorScheme.primary : Theme.of(context).dividerColor,
      ),
      backgroundColor: selected
          ? colorScheme.primary.withValues(alpha: 0.14)
          : Colors.transparent,
    );
  }
}
