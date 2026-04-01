import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/managed_apps_store.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';

class AppsLimitsScreen extends StatelessWidget {
  const AppsLimitsScreen({super.key});

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
              child: _Header(title: 'My Apps & Limits', onBack: () => context.pop()),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: ManagedAppsStore.apps,
                builder: (context, apps, _) {
                  return ListView.separated(
                    padding: AppSpacing.paddingMd,
                    itemCount: apps.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      if (index == apps.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.xl),
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () => context.push(AppRoutes.addApp),
                              style: ButtonStyle(
                                side: const WidgetStatePropertyAll(BorderSide(color: SoftlockColors.success, width: 1.2)),
                                foregroundColor: const WidgetStatePropertyAll(SoftlockColors.success),
                                overlayColor: WidgetStateProperty.resolveWith(
                                  (states) => states.contains(WidgetState.pressed) ? SoftlockColors.success.withValues(alpha: 0.08) : null,
                                ),
                              ),
                              child: const Text('+ Add another app'),
                            ),
                          ),
                        );
                      }

                      final app = apps[index];
                      return _AppCard(
                        app: app,
                        onTap: () => context.push('${AppRoutes.editApp}/${app.id}'),
                        text: text,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        _IconButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        Expanded(child: Center(child: Text(title, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
        const SizedBox(width: 40),
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

class _AppCard extends StatelessWidget {
  const _AppCard({required this.app, required this.onTap, required this.text});

  final ManagedApp app;
  final VoidCallback onTap;
  final TextTheme text;

  @override
  Widget build(BuildContext context) {
    final day = math.max(0, math.min(app.detoxCurrentDay, app.detoxTotalDays));
    final progress = app.detoxTotalDays <= 0 ? 0.0 : day / app.detoxTotalDays;
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: SoftlockColors.textPrimary.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        decoration: BoxDecoration(
          color: SoftlockColors.card,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: SoftlockColors.border, width: 1),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            _AppIcon(bg: app.iconBg, initial: app.initial),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.name, style: text.titleSmall?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text('${app.dailyLimitMinutes}min/day · ${app.detoxTotalDays} days', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 8,
                      backgroundColor: SoftlockColors.border.withValues(alpha: 0.35),
                      valueColor: const AlwaysStoppedAnimation(SoftlockColors.primary),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Day $day of ${app.detoxTotalDays}', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(Icons.chevron_right_rounded, color: SoftlockColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.bg, required this.initial});
  final Color bg;
  final String initial;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(initial, style: text.titleMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800)),
    );
  }
}
