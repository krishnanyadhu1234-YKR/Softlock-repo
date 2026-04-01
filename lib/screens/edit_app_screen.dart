import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/managed_apps_store.dart';
import 'package:softlock/theme.dart';

class EditAppScreen extends StatefulWidget {
  const EditAppScreen({super.key, required this.appId});
  final String appId;

  @override
  State<EditAppScreen> createState() => _EditAppScreenState();
}

class _EditAppScreenState extends State<EditAppScreen> {
  ManagedApp? _app;
  late int _minLimit;
  late double _limitValue;

  @override
  void initState() {
    super.initState();
    _app = ManagedAppsStore.byId(widget.appId);
    final current = _app?.dailyLimitMinutes ?? 30;
    _minLimit = current;
    _limitValue = current.toDouble();
  }

  String _limitLabel(int minutes) {
    if (minutes < 60) return '$minutes minutes';
    final hrs = minutes ~/ 60;
    final rem = minutes % 60;
    if (rem == 0) return '$hrs hr${hrs == 1 ? '' : 's'}';
    return '$hrs hr ${rem}m';
  }

  void _save() {
    final app = _app;
    if (app == null) return;
    final newLimit = _limitValue.round();
    ManagedAppsStore.update(app.copyWith(dailyLimitMinutes: newLimit));
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Saved'), duration: Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final status = Theme.of(context).extension<SoftlockStatusColors>();
    final warning = status?.warning ?? SoftlockColors.warning;
    final danger = Theme.of(context).colorScheme.error;

    final app = _app;
    if (app == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('App not found', style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
          ),
        ),
      );
    }

    final title = '📸 ${app.name}';
    final maxLimit = 180;
    final effectiveMin = _minLimit.clamp(15, maxLimit);
    final effectiveValue = _limitValue.clamp(effectiveMin.toDouble(), maxLimit.toDouble());
    _limitValue = effectiveValue;

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
                  Expanded(child: Center(child: Text(title, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(color: app.iconBg, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(app.initial, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: SoftlockColors.textPrimary)),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(app.name, style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w900, fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _SectionCard(
                    label: 'Daily time limit',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: SoftlockColors.primary,
                            inactiveTrackColor: SoftlockColors.border.withValues(alpha: 0.35),
                            thumbColor: SoftlockColors.primary,
                            overlayColor: SoftlockColors.primary.withValues(alpha: 0.16),
                          ),
                          child: Slider(
                            value: _limitValue,
                            min: effectiveMin.toDouble(),
                            max: maxLimit.toDouble(),
                            divisions: (maxLimit - effectiveMin),
                            onChanged: (v) => setState(() => _limitValue = v),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('15 min', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                            Text('3 hrs', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Center(
                          child: Text(
                            _limitLabel(_limitValue.round()),
                            style: text.titleMedium?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded, color: warning, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Limit can only be increased not decreased',
                                style: text.bodySmall?.copyWith(color: warning, fontSize: 12, height: 1.35),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  _SectionCard(
                    label: 'Detox duration',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lock_rounded, color: SoftlockColors.textSecondary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${app.detoxTotalDays} days (locked)',
                                style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Started: ${app.startedLabel}', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Ends: ${app.endsLabel}', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Duration is locked to keep your commitment strong',
                          style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),
                  Text('Emergency Options', style: text.labelSmall?.copyWith(color: danger, letterSpacing: 0.8)),
                  const SizedBox(height: AppSpacing.md),
                  _DangerAction(
                    title: '⏸ Pause detox',
                    subtitle: 'Costs 3 tokens + partner approval\nMax 2 pauses per detox period',
                    onTap: () => _dangerToast('Pause detox (stub)'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DangerAction(
                    title: '✕ End detox early',
                    subtitle: 'Requires partner OTP ·\nResets your streak to zero ·\nMarked permanently in history',
                    onTap: () => _dangerToast('End detox early (stub)'),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                      child: const Text('Save'),
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

  void _dangerToast(String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.label, required this.child});
  final String label;
  final Widget child;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary, letterSpacing: 0.9)),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _DangerAction extends StatelessWidget {
  const _DangerAction({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final danger = Theme.of(context).colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 52,
          child: OutlinedButton(
            onPressed: onTap,
            style: ButtonStyle(
              side: WidgetStatePropertyAll(BorderSide(color: danger, width: 1.2)),
              foregroundColor: WidgetStatePropertyAll(danger),
              overlayColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.pressed) ? danger.withValues(alpha: 0.10) : null,
              ),
            ),
            child: Text(title),
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontSize: 12, height: 1.4)),
      ],
    );
  }
}
