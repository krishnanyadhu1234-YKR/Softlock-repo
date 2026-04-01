import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.userName = 'Yadhu', this.partnerName = 'Sarah'});

  final String userName;
  final String partnerName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_BlockedAppUsage> _blockedApps = const [
    _BlockedAppUsage(name: 'Instagram', usedMinutes: 28, limitMinutes: 30, iconBg: SoftlockBrandColors.instagram),
    _BlockedAppUsage(name: 'TikTok', usedMinutes: 41, limitMinutes: 60, iconBg: SoftlockBrandColors.tiktok),
    _BlockedAppUsage(name: 'YouTube', usedMinutes: 75, limitMinutes: 90, iconBg: SoftlockBrandColors.youtube),
    _BlockedAppUsage(name: 'X', usedMinutes: 18, limitMinutes: 30, iconBg: SoftlockBrandColors.twitterX),
  ];

  int _selectedIndexForLocation(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith(AppRoutes.stats)) return 1;
    if (loc.startsWith(AppRoutes.settings)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndexForLocation(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: _TopBar(userName: widget.userName),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: _HomeTab(partnerName: widget.partnerName, blockedApps: _blockedApps)),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavBar(
        index: selectedIndex,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Good morning, $userName 👋',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.titleMedium
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w700, height: 1.2, color: SoftlockColors.textPrimary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _IconTap(icon: Icons.notifications_none_rounded, onTap: () {}),
        const SizedBox(width: AppSpacing.xs),
        _IconTap(icon: Icons.settings_rounded, onTap: () => context.push(AppRoutes.settings)),
      ],
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.partnerName, required this.blockedApps});

  final String partnerName;
  final List<_BlockedAppUsage> blockedApps;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingMd,
      children: [
        _DetoxSummaryCard(currentDay: 8, totalDays: 30, progress: 0.27, partnerName: partnerName),
        const SizedBox(height: AppSpacing.lg),
        Text(
          "Today's usage",
          style: context.textStyles.titleMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.md),
        ...blockedApps.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _AppUsageCard(app: a),
            )),
        const SizedBox(height: AppSpacing.xs),
        const _TokenBalanceRow(tokensRemaining: 3),
        const SizedBox(height: AppSpacing.lg),
        const _StatsShortcutCard(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _DetoxSummaryCard extends StatelessWidget {
  const _DetoxSummaryCard({required this.currentDay, required this.totalDays, required this.progress, required this.partnerName});

  final int currentDay;
  final int totalDays;
  final double progress;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final remaining = math.max(0, totalDays - currentDay);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day $currentDay of $totalDays',
              style: context.textStyles.headlineSmall?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: 10,
                backgroundColor: SoftlockColors.border.withValues(alpha: 0.35),
                valueColor: const AlwaysStoppedAnimation(SoftlockColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$remaining days remaining',
              style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.person_rounded, size: 18, color: SoftlockColors.textSecondary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Partner: $partnerName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
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

class _AppUsageCard extends StatelessWidget {
  const _AppUsageCard({required this.app});

  final _BlockedAppUsage app;

  @override
  Widget build(BuildContext context) {
    final ratio = app.limitMinutes <= 0 ? 1.0 : (app.usedMinutes / app.limitMinutes);
    final statusColor = _usageStatusColor(context, ratio);
    final remaining = math.max(0, app.limitMinutes - app.usedMinutes);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                _AppIconCircle(label: app.name, background: app.iconBg),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    app.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.titleSmall?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${app.usedMinutes} / ${app.limitMinutes} min',
                  style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: ratio.clamp(0, 1),
                minHeight: 10,
                backgroundColor: SoftlockColors.border.withValues(alpha: 0.35),
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$remaining min remaining',
                style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _usageStatusColor(BuildContext context, double ratio) {
    final status = Theme.of(context).extension<SoftlockStatusColors>();
    final success = status?.success ?? SoftlockColors.success;
    final warning = status?.warning ?? SoftlockColors.warning;
    if (ratio < 0.60) return success;
    if (ratio < 0.85) return warning;
    return SoftlockColors.danger;
  }
}

class _TokenBalanceRow extends StatelessWidget {
  const _TokenBalanceRow({required this.tokensRemaining});

  final int tokensRemaining;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.monetization_on_rounded, size: 18, color: SoftlockColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            '$tokensRemaining tokens remaining',
            style: context.textStyles.bodyMedium?.copyWith(color: SoftlockColors.textSecondary),
          ),
        ),
        _TextLink(label: 'Buy more', onTap: () {}),
      ],
    );
  }
}

class _StatsShortcutCard extends StatelessWidget {
  const _StatsShortcutCard();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(AppRoutes.stats),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.query_stats_rounded, color: SoftlockColors.textPrimary.withValues(alpha: 0.9)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'View detailed stats',
                  style: context.textStyles.titleSmall?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '→',
                style: context.textStyles.titleLarge?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: SoftlockColors.card,
          border: Border(top: BorderSide(color: SoftlockColors.border.withValues(alpha: 0.5), width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: _BottomNavItem(
                label: 'Home',
                icon: Icons.home_rounded,
                selected: index == 0,
                onTap: () => context.go(AppRoutes.home),
              ),
            ),
            Expanded(
              child: _BottomNavItem(
                label: 'Stats',
                icon: Icons.insights_rounded,
                selected: index == 1,
                onTap: () => context.go(AppRoutes.stats),
              ),
            ),
            Expanded(
              child: _BottomNavItem(
                label: 'Settings',
                icon: Icons.settings_rounded,
                selected: index == 2,
                onTap: () => context.go(AppRoutes.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? SoftlockColors.primary : SoftlockColors.textSecondary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? SoftlockColors.primary.withValues(alpha: 0.10) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.labelSmall?.copyWith(color: fg, fontWeight: FontWeight.w700, letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTap extends StatefulWidget {
  const _IconTap({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_IconTap> createState() => _IconTapState();
}

class _IconTapState extends State<_IconTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _pressed ? SoftlockColors.card.withValues(alpha: 0.85) : SoftlockColors.card.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: SoftlockColors.border.withValues(alpha: 0.7), width: 1),
        ),
        child: Icon(widget.icon, color: SoftlockColors.textPrimary.withValues(alpha: 0.92), size: 20),
      ),
    );
  }
}

class _TextLink extends StatefulWidget {
  const _TextLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<_TextLink> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: _pressed ? 0.75 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            widget.label,
            style: context.textStyles.labelLarge?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

class _AppIconCircle extends StatelessWidget {
  const _AppIconCircle({required this.label, required this.background});

  final String label;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final initial = label.trim().isEmpty ? '?' : label.trim()[0].toUpperCase();
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: context.textStyles.labelLarge?.copyWith(
          color: (background == Colors.yellow) ? Colors.black : SoftlockColors.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: SoftlockColors.textSecondary),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: context.textStyles.titleLarge?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Coming soon',
              style: context.textStyles.bodyMedium?.copyWith(color: SoftlockColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class _BlockedAppUsage {
  const _BlockedAppUsage({required this.name, required this.usedMinutes, required this.limitMinutes, required this.iconBg});

  final String name;
  final int usedMinutes;
  final int limitMinutes;
  final Color iconBg;
}
