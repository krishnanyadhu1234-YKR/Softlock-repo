import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _dailySummary = true;
  bool _limitWarnings = true;
  bool _weeklyReport = true;
  bool _partnerActivity = false;
  bool _streakMilestones = true;
  TimeOfDay _dailyTime = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dailyTime,
      builder: (context, child) {
        return Theme(
          data: softlockTheme,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (!mounted || picked == null) return;
    setState(() => _dailyTime = picked);
  }

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
                  _IconButton(icon: Icons.arrow_back_rounded, onTap: () => context.pop()),
                  Expanded(child: Center(child: Text('Notifications', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  _ToggleCard(
                    title: 'Daily Summary',
                    description: 'Receive your usage report\neach evening',
                    value: _dailySummary,
                    onChanged: (v) => setState(() => _dailySummary = v),
                    trailingBelow: _dailySummary
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Row(
                              children: [
                                Expanded(child: Text('Send at', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary))),
                                _TimePill(value: _dailyTime.format(context), onTap: _pickTime),
                              ],
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleCard(
                    title: 'Limit Warnings',
                    description: 'Alert when 80% of daily\nlimit is reached',
                    value: _limitWarnings,
                    onChanged: (v) => setState(() => _limitWarnings = v),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleCard(
                    title: 'Weekly Report',
                    description: 'Usage summary every Monday morning',
                    value: _weeklyReport,
                    onChanged: (v) => setState(() => _weeklyReport = v),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleCard(
                    title: 'Partner Activity',
                    description: 'When your partner views your stats',
                    value: _partnerActivity,
                    onChanged: (v) => setState(() => _partnerActivity = v),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ToggleCard(
                    title: 'Streak Milestones',
                    description: 'Celebrate when you hit\n7, 14, 30 day streaks',
                    value: _streakMilestones,
                    onChanged: (v) => setState(() => _streakMilestones = v),
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

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({required this.title, required this.description, required this.value, required this.onChanged, this.trailingBelow});
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? trailingBelow;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: SoftlockColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: SoftlockColors.border, width: 1),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(description, style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary, fontSize: 13, height: 1.35)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: SoftlockColors.primary,
                inactiveThumbColor: SoftlockColors.textSecondary,
                inactiveTrackColor: SoftlockColors.border.withValues(alpha: 0.55),
              ),
            ],
          ),
          if (trailingBelow != null) trailingBelow!,
        ],
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({required this.value, required this.onTap});
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: SoftlockColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(value, style: text.bodyMedium?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w700)),
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
