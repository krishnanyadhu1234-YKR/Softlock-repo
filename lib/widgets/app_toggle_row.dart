import 'package:flutter/material.dart';
import 'package:softlock/theme.dart';

/// One row in the onboarding app picker list.
class AppToggleRow extends StatelessWidget {
  const AppToggleRow({
    super.key,
    required this.name,
    required this.color,
    required this.enabled,
    required this.onChanged,
  });

  final String name;
  final Color color;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  Color _foregroundFor(Color bg) => bg.computeLuminance() > 0.6 ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: SoftlockColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: SoftlockColors.border, width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: Text(
              name.characters.first.toUpperCase(),
              style: text.labelLarge?.copyWith(color: _foregroundFor(color), fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: SoftlockColors.primary,
            inactiveThumbColor: SoftlockColors.textSecondary,
            inactiveTrackColor: SoftlockColors.border.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}
