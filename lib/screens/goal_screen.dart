import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/theme.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final status = Theme.of(context).extension<SoftlockStatusColors>();
    final warning = status?.warning ?? SoftlockColors.warning;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: Row(
                children: [
                  _IconButton(icon: Icons.arrow_back_rounded, onTap: () => context.pop()),
                  Expanded(child: Center(child: Text('My Goal', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your goal', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary, letterSpacing: 0.9)),
                          const SizedBox(height: AppSpacing.md),
                          Stack(
                            children: [
                              Positioned(
                                left: -6,
                                top: -16,
                                child: Text('“', style: text.displaySmall?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w900, height: 0.8)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18, right: 4),
                                child: Text(
                                  'I want to read more books',
                                  style: text.titleLarge?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, fontSize: 18, height: 1.45),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: -18,
                                child: Text('”', style: text.displaySmall?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w900, height: 0.8)),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(const SnackBar(content: Text('Edit Goal (stub)'), duration: Duration(seconds: 2)));
                      },
                      style: ButtonStyle(
                        foregroundColor: const WidgetStatePropertyAll(SoftlockColors.primary),
                        overlayColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.pressed) ? SoftlockColors.primary.withValues(alpha: 0.08) : null,
                        ),
                      ),
                      child: const Text('Edit Goal'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: SoftlockColors.border, width: 1),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_rounded, color: SoftlockColors.textSecondary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your goal appears on your lock screen every time you hit your limit.\nChoose words that motivate you.',
                            style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          _StatRow(label: 'Started', value: 'March 1 2026'),
                          Divider(color: SoftlockColors.border.withValues(alpha: 0.22), height: AppSpacing.lg),
                          _StatRow(label: 'Longest streak', value: '8 days 🔥'),
                          Divider(color: SoftlockColors.border.withValues(alpha: 0.22), height: AppSpacing.lg),
                          _StatRow(label: 'Times unlocked early', value: '3 times', valueColor: warning),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(child: Text(label, style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary))),
        const SizedBox(width: 12),
        Text(value, style: text.bodyMedium?.copyWith(color: valueColor ?? SoftlockColors.textPrimary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(999),
      highlightColor: SoftlockColors.textPrimary.withValues(alpha: 0.06),
      child: SizedBox(width: 40, height: 40, child: Icon(icon, color: SoftlockColors.textPrimary)),
    );
  }
}
