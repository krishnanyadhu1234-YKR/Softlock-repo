import 'package:flutter/material.dart';
import 'package:softlock/theme.dart';

/// Bottom sheet for picking a custom detox duration (in days).
///
/// Returns the selected day count via `Navigator.pop(context, value)`.
class CustomDurationSheet extends StatefulWidget {
  const CustomDurationSheet({super.key, required this.initialDays, this.minDays = 1, this.maxDays = 365});

  final int initialDays;
  final int minDays;
  final int maxDays;

  @override
  State<CustomDurationSheet> createState() => _CustomDurationSheetState();

  static Future<int?> show(BuildContext context, {required int initialDays, int minDays = 1, int maxDays = 365}) {
    final clamped = initialDays.clamp(minDays, maxDays);
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) {
        return CustomDurationSheet(initialDays: clamped, minDays: minDays, maxDays: maxDays);
      },
    );
  }
}

class _CustomDurationSheetState extends State<CustomDurationSheet> {
  late double _days;

  @override
  void initState() {
    super.initState();
    _days = widget.initialDays.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final daysInt = _days.round().clamp(widget.minDays, widget.maxDays);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      child: Container(
        color: SoftlockColors.card,
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: SoftlockColors.border.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Custom duration', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.xs),
            Text('How many days?', style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),

            Center(
              child: Column(
                children: [
                  Text(
                    '$daysInt',
                    style: text.displaySmall?.copyWith(
                      fontSize: 48,
                      height: 1.0,
                      color: SoftlockColors.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('days', style: text.titleSmall?.copyWith(fontSize: 16, color: SoftlockColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: SoftlockColors.primary,
                inactiveTrackColor: SoftlockColors.border.withValues(alpha: 0.55),
                thumbColor: SoftlockColors.primary,
                overlayColor: SoftlockColors.primary.withValues(alpha: 0.18),
                trackHeight: 4,
              ),
              child: Slider(
                value: _days,
                min: widget.minDays.toDouble(),
                max: widget.maxDays.toDouble(),
                divisions: (widget.maxDays - widget.minDays),
                onChanged: (v) => setState(() => _days = v),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        foregroundColor: WidgetStatePropertyAll(SoftlockColors.textPrimary.withValues(alpha: 0.88)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(daysInt),
                      style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                      child: const Text('Confirm'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
