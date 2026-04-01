import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';
import 'package:softlock/widgets/app_toggle_row.dart';
import 'package:softlock/widgets/onboarding_progress_dots.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  final TextEditingController _name = TextEditingController();

  final Map<String, Color> _apps = const {
    'Instagram': SoftlockBrandColors.instagram,
    'TikTok': SoftlockBrandColors.tiktok,
    'YouTube': SoftlockBrandColors.youtube,
    'Facebook': SoftlockBrandColors.facebook,
    'Twitter/X': SoftlockBrandColors.twitterX,
    'Snapchat': SoftlockBrandColors.snapchat,
    'WhatsApp': SoftlockBrandColors.whatsapp,
    'LinkedIn': SoftlockBrandColors.linkedin,
  };

  late final Map<String, bool> _enabled;

  @override
  void initState() {
    super.initState();
    _enabled = {
      'Instagram': true,
      'TikTok': true,
      'YouTube': true,
      'Facebook': false,
      'Twitter/X': false,
      'Snapchat': false,
      'WhatsApp': false,
      'LinkedIn': false,
    };
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _next() {
    final selected = _enabled.entries.where((e) => e.value).map((e) => e.key).toList(growable: false);
    context.push(AppRoutes.onboarding2, extra: {
      'name': _name.text.trim(),
      'selectedApps': selected,
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              const OnboardingProgressDots(activeIndex: 0),
              const SizedBox(height: AppSpacing.xl),
              Text("Let's get started", style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.sm),
              Text('What should we call you?', style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Your name'),
              ),
              const SizedBox(height: AppSpacing.xl),

              Text('Choose apps to manage', style: text.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('Select apps you want to limit', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontSize: 12)),
              const SizedBox(height: AppSpacing.md),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final entry in _apps.entries) ...[
                        AppToggleRow(
                          name: entry.key,
                          color: entry.value,
                          enabled: _enabled[entry.key] ?? false,
                          onChanged: (v) => setState(() => _enabled[entry.key] = v),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'More apps can be added later\nin settings',
                        textAlign: TextAlign.center,
                        style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                  child: const Text('Next'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
