import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';

class SettingsMainScreen extends StatelessWidget {
  const SettingsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: Row(
                children: [
                  const Spacer(),
                  Text('Settings', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  _UserCard(name: 'Yadhu', phone: '+91 98765 43210'),
                  const SizedBox(height: AppSpacing.lg),
                  _SettingsMenuCard(
                    rows: [
                      _SettingsMenuRowData(icon: Icons.phone_iphone_rounded, label: 'My Apps & Limits', onTap: () => context.push(AppRoutes.appsLimits)),
                      _SettingsMenuRowData(icon: Icons.groups_rounded, label: 'My Partner', onTap: () => context.push(AppRoutes.partner)),
                      _SettingsMenuRowData(icon: Icons.track_changes_rounded, label: 'My Goal', onTap: () => context.push(AppRoutes.goal)),
                      _SettingsMenuRowData(icon: Icons.notifications_rounded, label: 'Notifications', onTap: () => context.push(AppRoutes.notifications)),
                      _SettingsMenuRowData(icon: Icons.monetization_on_rounded, label: 'Tokens', onTap: () => context.push(AppRoutes.tokens)),
                      _SettingsMenuRowData(icon: Icons.lock_rounded, label: 'Privacy & Data', onTap: () => context.push(AppRoutes.privacy)),
                      _SettingsMenuRowData(icon: Icons.credit_card_rounded, label: 'Subscription', onTap: () => context.push(AppRoutes.subscription)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Center(child: Text('Softlock v1.0.0', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: SoftlockColors.primary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(initial, style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: SoftlockColors.textPrimary)),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(name, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 2),
            Text(phone, style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _SettingsMenuRowData {
  const _SettingsMenuRowData({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _SettingsMenuCard extends StatelessWidget {
  const _SettingsMenuCard({required this.rows});

  final List<_SettingsMenuRowData> rows;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: SoftlockColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: SoftlockColors.border, width: 1),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            _SettingsMenuRow(icon: rows[i].icon, label: rows[i].label, onTap: rows[i].onTap, text: text),
            if (i != rows.length - 1) Divider(color: SoftlockColors.border.withValues(alpha: 0.22), height: 1),
          ],
        ],
      ),
    );
  }
}

class _SettingsMenuRow extends StatelessWidget {
  const _SettingsMenuRow({required this.icon, required this.label, required this.onTap, required this.text});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: SoftlockColors.textPrimary.withValues(alpha: 0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: SoftlockColors.textPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: text.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_right_rounded, color: SoftlockColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
