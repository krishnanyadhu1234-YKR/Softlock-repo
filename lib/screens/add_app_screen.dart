import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/managed_apps_store.dart';
import 'package:softlock/theme.dart';

class AddAppScreen extends StatefulWidget {
  const AddAppScreen({super.key});

  @override
  State<AddAppScreen> createState() => _AddAppScreenState();
}

class _AddAppScreenState extends State<AddAppScreen> {
  final TextEditingController _search = TextEditingController();
  String? _flashId;
  Timer? _flashTimer;

  final List<ManagedApp> _installed = const [
    ManagedApp(id: 'instagram', name: 'Instagram', iconBg: SoftlockBrandColors.instagram, dailyLimitMinutes: 30, detoxTotalDays: 14, detoxCurrentDay: 8, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
    ManagedApp(id: 'tiktok', name: 'TikTok', iconBg: SoftlockBrandColors.tiktok, dailyLimitMinutes: 60, detoxTotalDays: 14, detoxCurrentDay: 8, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
    ManagedApp(id: 'youtube', name: 'YouTube', iconBg: SoftlockBrandColors.youtube, dailyLimitMinutes: 90, detoxTotalDays: 14, detoxCurrentDay: 8, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
    ManagedApp(id: 'x', name: 'X', iconBg: SoftlockBrandColors.twitterX, dailyLimitMinutes: 30, detoxTotalDays: 14, detoxCurrentDay: 8, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
    ManagedApp(id: 'snapchat', name: 'Snapchat', iconBg: SoftlockBrandColors.snapchat, dailyLimitMinutes: 30, detoxTotalDays: 14, detoxCurrentDay: 0, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
    ManagedApp(id: 'whatsapp', name: 'WhatsApp', iconBg: SoftlockBrandColors.whatsapp, dailyLimitMinutes: 45, detoxTotalDays: 14, detoxCurrentDay: 0, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
    ManagedApp(id: 'linkedin', name: 'LinkedIn', iconBg: SoftlockBrandColors.linkedin, dailyLimitMinutes: 30, detoxTotalDays: 14, detoxCurrentDay: 0, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
    ManagedApp(id: 'facebook', name: 'Facebook', iconBg: SoftlockBrandColors.facebook, dailyLimitMinutes: 30, detoxTotalDays: 14, detoxCurrentDay: 0, startedLabel: 'March 1 2026', endsLabel: 'March 15 2026'),
  ];

  @override
  void dispose() {
    _flashTimer?.cancel();
    _search.dispose();
    super.dispose();
  }

  List<ManagedApp> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _installed;
    return _installed.where((a) => a.name.toLowerCase().contains(q)).toList();
  }

  void _flashRow(String id) {
    _flashTimer?.cancel();
    setState(() => _flashId = id);
    _flashTimer = Timer(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      setState(() => _flashId = null);
    });
  }

  void _showAddedToast(String name) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text('$name added ✓ Set limits in My Apps & Limits'),
        ),
      );
  }

  void _add(ManagedApp app) {
    if (ManagedAppsStore.containsId(app.id)) return;
    ManagedAppsStore.add(app);
    _flashRow(app.id);
    _showAddedToast(app.name);
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
                  Expanded(child: Center(child: Text('Add App', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: SoftlockColors.textSecondary),
                  hintText: 'Search your apps…',
                  suffixIcon: _search.text.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _search.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close_rounded, color: SoftlockColors.textSecondary),
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Installed Apps', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary, letterSpacing: 0.9)),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.paddingMd,
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => Divider(color: SoftlockColors.border.withValues(alpha: 0.18), height: 1),
                itemBuilder: (context, index) {
                  final app = _filtered[index];
                  final isAdded = ManagedAppsStore.containsId(app.id);
                  final flashing = _flashId == app.id;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      color: flashing ? SoftlockColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _AppRow(
                        app: app,
                        isAdded: isAdded,
                        onAdd: () => _add(app),
                      ),
                    ),
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

class _AppRow extends StatelessWidget {
  const _AppRow({required this.app, required this.isAdded, required this.onAdd});
  final ManagedApp app;
  final bool isAdded;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: app.iconBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(app.initial, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: SoftlockColors.textPrimary)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.name, style: text.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                if (isAdded) ...[
                  const SizedBox(height: 2),
                  Text('Already added', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: isAdded
                ? Text('Added ✓', key: const ValueKey('added'), style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary, fontWeight: FontWeight.w600))
                : SizedBox(
                    key: const ValueKey('add'),
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onAdd,
                      style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                      child: const Text('Add'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
