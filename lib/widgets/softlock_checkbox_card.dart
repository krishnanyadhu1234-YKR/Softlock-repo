import 'package:flutter/material.dart';
import 'package:softlock/theme.dart';

/// A Softlock-styled checkbox row inside a rounded card.
class SoftlockCheckboxCard extends StatelessWidget {
  const SoftlockCheckboxCard({super.key, required this.value, required this.label, required this.onChanged});

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: SoftlockColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: SoftlockColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            side: const BorderSide(color: SoftlockColors.border, width: 1.2),
            activeColor: SoftlockColors.primary,
            checkColor: SoftlockColors.textPrimary,
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(label, style: text.bodyMedium?.copyWith(fontSize: 14))),
        ],
      ),
    );
  }
}
