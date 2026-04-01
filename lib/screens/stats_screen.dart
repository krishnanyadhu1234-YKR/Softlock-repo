import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/managed_apps_store.dart';
import 'package:softlock/theme.dart';

enum StatsPeriod { today, week, month }

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  StatsPeriod _period = StatsPeriod.today;

  static const _apps = <_AppStats>{
    _AppStats(
      name: 'Instagram',
      iconBg: SoftlockBrandColors.instagram,
      streakDays: 8,
      todayUsedMinutes: 28,
      todayLimitMinutes: 30,
      weekUsedMinutes: 200,
      weekLimitMinutes: 210,
      weekUnlockedEarly: 5,
      bestDayLabel: 'Tuesday 🟢',
      worstDayLabel: 'Saturday 🔴',
      monthUsedMinutes: 760,
      monthLimitMinutes: 900,
      monthUnlockedEarly: 12,
      monthDaysCompleted: 18,
      monthDaysExceeded: 4,
    ),
    _AppStats(
      name: 'TikTok',
      iconBg: SoftlockBrandColors.tiktok,
      streakDays: 5,
      todayUsedMinutes: 41,
      todayLimitMinutes: 60,
      weekUsedMinutes: 175,
      weekLimitMinutes: 240,
      weekUnlockedEarly: 3,
      bestDayLabel: 'Wednesday 🟢',
      worstDayLabel: 'Sunday 🔴',
      monthUsedMinutes: 620,
      monthLimitMinutes: 780,
      monthUnlockedEarly: 9,
      monthDaysCompleted: 16,
      monthDaysExceeded: 6,
    ),
    _AppStats(
      name: 'YouTube',
      iconBg: SoftlockBrandColors.youtube,
      streakDays: 3,
      todayUsedMinutes: 75,
      todayLimitMinutes: 90,
      weekUsedMinutes: 260,
      weekLimitMinutes: 300,
      weekUnlockedEarly: 6,
      bestDayLabel: 'Monday 🟢',
      worstDayLabel: 'Saturday 🔴',
      monthUsedMinutes: 1020,
      monthLimitMinutes: 1200,
      monthUnlockedEarly: 14,
      monthDaysCompleted: 14,
      monthDaysExceeded: 8,
    ),
    _AppStats(
      name: 'X',
      iconBg: SoftlockBrandColors.twitterX,
      streakDays: 11,
      todayUsedMinutes: 18,
      todayLimitMinutes: 30,
      weekUsedMinutes: 95,
      weekLimitMinutes: 120,
      weekUnlockedEarly: 2,
      bestDayLabel: 'Friday 🟢',
      worstDayLabel: 'Tuesday 🔴',
      monthUsedMinutes: 410,
      monthLimitMinutes: 450,
      monthUnlockedEarly: 7,
      monthDaysCompleted: 20,
      monthDaysExceeded: 2,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: _StatsHeader(onBack: context.pop),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: _StatsPeriodTabs(period: _period, onChanged: (p) => setState(() => _period = p)),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  ..._apps.map((a) => _PerAppSection(app: a, period: _period)),
                  const SizedBox(height: AppSpacing.xl),
                  const _DetoxProgressSection(),
                  const SizedBox(height: AppSpacing.xl),
                  const _HistorySection(),
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

class _StatsHeader extends StatelessWidget {
  const _StatsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderIconButton(icon: Icons.arrow_back_rounded, onTap: onBack),
        Expanded(
          child: Center(
            child: Text(
              'My Stats',
              style: context.textStyles.titleLarge?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: SoftlockColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SoftlockColors.border.withValues(alpha: 0.6), width: 1),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: SoftlockColors.textPrimary, size: 20),
      ),
    );
  }
}

class _StatsPeriodTabs extends StatelessWidget {
  const _StatsPeriodTabs({required this.period, required this.onChanged});

  final StatsPeriod period;
  final ValueChanged<StatsPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabPill(
            label: 'Today',
            selected: period == StatsPeriod.today,
            onTap: () => onChanged(StatsPeriod.today),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _TabPill(
            label: 'This Week',
            selected: period == StatsPeriod.week,
            onTap: () => onChanged(StatsPeriod.week),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _TabPill(
            label: 'This Month',
            selected: period == StatsPeriod.month,
            onTap: () => onChanged(StatsPeriod.month),
          ),
        ),
      ],
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? SoftlockColors.primary : SoftlockColors.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? SoftlockColors.primary : SoftlockColors.border.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.labelLarge?.copyWith(
              color: selected ? SoftlockColors.textPrimary : SoftlockColors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _PerAppSection extends StatelessWidget {
  const _PerAppSection({required this.app, required this.period});

  final _AppStats app;
  final StatsPeriod period;

  @override
  Widget build(BuildContext context) {
    final status = _periodModel(period);
    final ratio = status.limitMinutes <= 0 ? 1.0 : status.usedMinutes / status.limitMinutes;
    final barColor = _usageStatusColor(ratio);

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  children: [
                    _AppIconCircle(label: app.name, background: app.iconBg),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textStyles.titleSmall
                                ?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 3),
                          _StreakBadge(days: app.streakDays),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      status.topRightLabel,
                      textAlign: TextAlign.right,
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
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(child: Text(status.bottomLeftLabel, style: context.textStyles.bodySmall?.copyWith(color: status.bottomLeftColor))),
                    const SizedBox(width: AppSpacing.sm),
                    Text(status.bottomRightLabel, style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                  ],
                ),
                if (status.extraLines.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  ...status.extraLines.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Expanded(child: Text(line.label, style: context.textStyles.bodySmall?.copyWith(color: line.color))),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Divider(color: SoftlockColors.border.withValues(alpha: 0.35), height: 1),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  _PeriodModel _periodModel(StatsPeriod p) {
    switch (p) {
      case StatsPeriod.week:
        return _PeriodModel.week(app);
      case StatsPeriod.month:
        return _PeriodModel.month(app);
      case StatsPeriod.today:
      default:
        return _PeriodModel.today(app);
    }
  }
}

class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: SoftlockColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: SoftlockColors.warning.withValues(alpha: 0.45), width: 1),
      ),
      child: Text(
        '🔥 $days day streak',
        style: context.textStyles.labelMedium?.copyWith(color: SoftlockColors.warning, fontWeight: FontWeight.w700),
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
    final trimmed = label.trim();
    final initial = trimmed.isEmpty ? '?' : trimmed.substring(0, 1).toUpperCase();
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: context.textStyles.titleSmall?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800),
      ),
    );
  }
}

Color _usageStatusColor(double ratio) {
  if (ratio < 0.60) return SoftlockColors.success;
  if (ratio < 0.85) return SoftlockColors.warning;
  return SoftlockColors.danger;
}

class _DetoxProgressSection extends StatelessWidget {
  const _DetoxProgressSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detox Progress', style: context.textStyles.titleMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.md),
        ValueListenableBuilder<List<ManagedApp>>(
          valueListenable: ManagedAppsStore.apps,
          builder: (context, apps, _) {
            if (apps.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text('No apps selected yet.', style: context.textStyles.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
                ),
              );
            }

            final averageProgress = apps.fold<double>(0, (sum, a) {
              final denom = a.detoxTotalDays <= 0 ? 1 : a.detoxTotalDays;
              return sum + (a.detoxCurrentDay / denom);
            }) /
                apps.length;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${apps.length} active detox${apps.length == 1 ? '' : 'es'}', style: context.textStyles.titleSmall?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 4),
                              Text('Each app can have its own detox duration.', style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary, height: 1.35)),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        _ProgressRing(progress: averageProgress),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Divider(color: SoftlockColors.border.withValues(alpha: 0.35), height: 1),
                    const SizedBox(height: AppSpacing.md),
                    ...apps.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _DetoxAppProgressRow(app: a),
                    )),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _DetoxAppProgressRow extends StatelessWidget {
  const _DetoxAppProgressRow({required this.app});

  final ManagedApp app;

  @override
  Widget build(BuildContext context) {
    final total = app.detoxTotalDays <= 0 ? 1 : app.detoxTotalDays;
    final progress = (app.detoxCurrentDay / total).clamp(0.0, 1.0);
    final label = 'Day ${app.detoxCurrentDay} of ${app.detoxTotalDays}';

    return Row(
      children: [
        _AppIconCircle(label: app.name, background: app.iconBg),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      app.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.titleSmall?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(label, style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: SoftlockColors.border.withValues(alpha: 0.35),
                  valueColor: const AlwaysStoppedAnimation(SoftlockColors.primary),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Started ${app.startedLabel} · Ends ${app.endsLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodySmall?.copyWith(color: SoftlockColors.textSecondary, height: 1.25),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0, 1),
            strokeWidth: 10,
            backgroundColor: SoftlockColors.border.withValues(alpha: 0.35),
            valueColor: const AlwaysStoppedAnimation(SoftlockColors.primary),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: context.textStyles.titleMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'History',
          style: context.textStyles.titleMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: const [
                _HistoryRow(left: 'Attempt 1', middle: '12 days', right: 'Reset ⚡', rightColor: SoftlockColors.textSecondary),
                SizedBox(height: AppSpacing.sm),
                Divider(height: 1),
                SizedBox(height: AppSpacing.sm),
                _HistoryRow(left: 'Attempt 2', middle: 'Current 🔥', right: 'Day 8', rightColor: SoftlockColors.textPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.left, required this.middle, required this.right, required this.rightColor});

  final String left;
  final String middle;
  final String right;
  final Color rightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(left, style: context.textStyles.bodyMedium?.copyWith(color: SoftlockColors.textSecondary, fontWeight: FontWeight.w600)),
        ),
        Text(middle, style: context.textStyles.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
        const SizedBox(width: AppSpacing.md),
        Text(right, style: context.textStyles.bodyMedium?.copyWith(color: rightColor, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _AppStats {
  const _AppStats({
    required this.name,
    required this.iconBg,
    required this.streakDays,
    required this.todayUsedMinutes,
    required this.todayLimitMinutes,
    required this.weekUsedMinutes,
    required this.weekLimitMinutes,
    required this.weekUnlockedEarly,
    required this.bestDayLabel,
    required this.worstDayLabel,
    required this.monthUsedMinutes,
    required this.monthLimitMinutes,
    required this.monthUnlockedEarly,
    required this.monthDaysCompleted,
    required this.monthDaysExceeded,
  });

  final String name;
  final Color iconBg;
  final int streakDays;

  final int todayUsedMinutes;
  final int todayLimitMinutes;

  final int weekUsedMinutes;
  final int weekLimitMinutes;
  final int weekUnlockedEarly;
  final String bestDayLabel;
  final String worstDayLabel;

  final int monthUsedMinutes;
  final int monthLimitMinutes;
  final int monthUnlockedEarly;
  final int monthDaysCompleted;
  final int monthDaysExceeded;
}

class _PeriodModel {
  const _PeriodModel({
    required this.usedMinutes,
    required this.limitMinutes,
    required this.topRightLabel,
    required this.bottomLeftLabel,
    required this.bottomLeftColor,
    required this.bottomRightLabel,
    required this.extraLines,
  });

  factory _PeriodModel.today(_AppStats a) {
    final remaining = math.max(0, a.todayLimitMinutes - a.todayUsedMinutes);
    return _PeriodModel(
      usedMinutes: a.todayUsedMinutes,
      limitMinutes: a.todayLimitMinutes,
      topRightLabel: '${a.todayUsedMinutes} / ${a.todayLimitMinutes} min today',
      bottomLeftLabel: 'Unlocked early: 2',
      bottomLeftColor: SoftlockColors.warning,
      bottomRightLabel: 'Remaining: $remaining min',
      extraLines: const [],
    );
  }

  factory _PeriodModel.week(_AppStats a) {
    return _PeriodModel(
      usedMinutes: a.weekUsedMinutes,
      limitMinutes: a.weekLimitMinutes,
      topRightLabel: '${_formatMinutesAsHrs(a.weekUsedMinutes)} this week',
      bottomLeftLabel: 'Weekly limit: ${_formatMinutesAsHrs(a.weekLimitMinutes)}',
      bottomLeftColor: SoftlockColors.textSecondary,
      bottomRightLabel: 'Unlocked early: ${a.weekUnlockedEarly} this week',
      extraLines: [
        _ExtraLine(label: 'Best day: ${a.bestDayLabel}', color: SoftlockColors.success),
        _ExtraLine(label: 'Worst day: ${a.worstDayLabel}', color: SoftlockColors.danger),
      ],
    );
  }

  factory _PeriodModel.month(_AppStats a) {
    return _PeriodModel(
      usedMinutes: a.monthUsedMinutes,
      limitMinutes: a.monthLimitMinutes,
      topRightLabel: '${_formatMinutesAsHrs(a.monthUsedMinutes)} this month',
      bottomLeftLabel: 'Unlocked early: ${a.monthUnlockedEarly} this month',
      bottomLeftColor: SoftlockColors.warning,
      bottomRightLabel: 'Monthly limit: ${_formatMinutesAsHrs(a.monthLimitMinutes)}',
      extraLines: [
        _ExtraLine(label: 'Days completed fully: ${a.monthDaysCompleted}', color: SoftlockColors.success),
        _ExtraLine(label: 'Days limit exceeded: ${a.monthDaysExceeded}', color: SoftlockColors.danger),
      ],
    );
  }

  final int usedMinutes;
  final int limitMinutes;
  final String topRightLabel;
  final String bottomLeftLabel;
  final Color bottomLeftColor;
  final String bottomRightLabel;
  final List<_ExtraLine> extraLines;
}

class _ExtraLine {
  const _ExtraLine({required this.label, required this.color});
  final String label;
  final Color color;
}

String _formatMinutesAsHrs(int minutes) {
  final m = math.max(0, minutes);
  final h = m ~/ 60;
  final r = m % 60;
  if (h <= 0) return '${r}min';
  if (r == 0) return '${h}h';
  return '${h}h ${r}min';
}
