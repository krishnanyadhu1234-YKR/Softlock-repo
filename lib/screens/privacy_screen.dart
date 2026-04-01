import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  void _showStub(BuildContext context, String message) {
    debugPrint(message);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final status = Theme.of(context).extension<SoftlockStatusColors>();
    final success = status?.success ?? SoftlockColors.success;

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
                  Expanded(child: Center(child: Text('Privacy & Data', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  Text('What we store', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoCard(
                    children: const [
                      _InfoRow(title: 'Phone number', description: 'Your identity'),
                      _InfoRow(title: 'App usage data', description: 'To track limits'),
                      _InfoRow(title: 'Partner number', description: 'To send OTPs'),
                      _InfoRow(title: 'Purchase history', description: 'Token transactions'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _BadgeRow(
                    icon: '🇪🇺',
                    text: 'Stored securely in EU servers',
                    color: success,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _BadgeRow(
                    icon: '🚫',
                    text: 'We never sell your data',
                    color: success,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Your rights', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      color: SoftlockColors.card,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: SoftlockColors.border, width: 1),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        OutlinedButton(
                          onPressed: () => _showStub(context, 'Download data (stub).'),
                          style: ButtonStyle(
                            side: const WidgetStatePropertyAll(BorderSide(color: SoftlockColors.primary, width: 1.25)),
                            foregroundColor: const WidgetStatePropertyAll(SoftlockColors.primary),
                          ),
                          child: const Text('Download all my data'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Receive data via email\nwithin 48 hours',
                          style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        OutlinedButton(
                          onPressed: () => context.push(AppRoutes.deleteAccount),
                          style: ButtonStyle(
                            side: const WidgetStatePropertyAll(BorderSide(color: SoftlockColors.danger, width: 1.25)),
                            foregroundColor: const WidgetStatePropertyAll(SoftlockColors.danger),
                          ),
                          child: const Text('Delete my account & all data'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Permanent, cannot be undone',
                          style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Center(
                    child: TextButton(
                      onPressed: () => _showStub(context, 'Privacy Policy (stub).'),
                      style: ButtonStyle(
                        foregroundColor: const WidgetStatePropertyAll(SoftlockColors.primary),
                        overlayColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.pressed) ? SoftlockColors.primary.withValues(alpha: 0.08) : null,
                        ),
                      ),
                      child: const Text('Privacy policy'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SoftlockColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: SoftlockColors.border, width: 1),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_rounded, color: SoftlockColors.textPrimary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(description, style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.icon, required this.text, required this.color});
  final String icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Flexible(child: Text(text, style: t.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
