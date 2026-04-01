import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/countries.dart';
import 'package:softlock/models/country.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';
import 'package:softlock/widgets/onboarding_progress_dots.dart';
import 'package:softlock/widgets/phone_number_input_row.dart';
import 'package:softlock/widgets/softlock_checkbox_card.dart';
import 'package:softlock/widgets/custom_duration_sheet.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key, this.name, this.selectedApps});

  final String? name;
  final List<String>? selectedApps;

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  static const List<_OnboardingApp> _allApps = [
    _OnboardingApp('Instagram', SoftlockBrandColors.instagram),
    _OnboardingApp('TikTok', SoftlockBrandColors.tiktok),
    _OnboardingApp('YouTube', SoftlockBrandColors.youtube),
    _OnboardingApp('Facebook', SoftlockBrandColors.facebook),
    _OnboardingApp('Twitter/X', SoftlockBrandColors.twitterX),
    _OnboardingApp('Snapchat', SoftlockBrandColors.snapchat),
    _OnboardingApp('WhatsApp', SoftlockBrandColors.whatsapp),
    _OnboardingApp('LinkedIn', SoftlockBrandColors.linkedin),
  ];

  late final List<_OnboardingApp> _enabledApps;
  final Map<String, int> _durationDays = {};
  final Map<String, double> _dailyMinutes = {};

  late Country _country;
  final TextEditingController _partnerPhone = TextEditingController();
  bool _partnerAgreed = false;

  @override
  void initState() {
    super.initState();
    _country = CountriesData.popular.first;

    final selected = widget.selectedApps;
    if (selected == null || selected.isEmpty) {
      _enabledApps = _allApps.where((a) => const {'Instagram', 'TikTok', 'YouTube'}.contains(a.name)).toList();
    } else {
      _enabledApps = _allApps.where((a) => selected.contains(a.name)).toList();
    }

    for (final app in _enabledApps) {
      _durationDays[app.name] = 7;
      _dailyMinutes[app.name] = 30;
    }
  }

  @override
  void dispose() {
    _partnerPhone.dispose();
    super.dispose();
  }

  void _startDetox() {
    final name = widget.name?.trim();
    debugPrint('Start detox (stub). name=$name enabledApps=${_enabledApps.map((e) => e.name).toList()}');
    context.go(AppRoutes.home);
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
              const OnboardingProgressDots(activeIndex: 1),
              const SizedBox(height: AppSpacing.xl),
              Text('Set your limits', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.sm),
              Text('Customize each app', style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
              const SizedBox(height: AppSpacing.lg),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _enabledApps.length + 1,
                  separatorBuilder: (_, index) => index < _enabledApps.length - 1
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          child: Divider(color: SoftlockColors.border.withValues(alpha: 0.28), height: 1),
                        )
                      : const SizedBox.shrink(),
                  itemBuilder: (context, index) {
                    if (index == _enabledApps.length) {
                      return _PartnerSection(
                        country: _country,
                        phoneController: _partnerPhone,
                        onCountryChanged: (c) => setState(() => _country = c),
                        agreed: _partnerAgreed,
                        onAgreedChanged: (v) => setState(() => _partnerAgreed = v),
                      );
                    }

                    final app = _enabledApps[index];
                    final days = _durationDays[app.name] ?? 7;
                    final minutes = _dailyMinutes[app.name] ?? 30;
                    const presetDays = [3, 7, 14, 30];
                    final isCustom = !presetDays.contains(days);

                    return Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(radius: 18, backgroundColor: app.color, child: _AppInitial(name: app.name, color: app.color)),
                                const SizedBox(width: 12),
                                Expanded(child: Text(app.name, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text('Detox duration', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontSize: 12)),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final d in presetDays)
                                  _PillButton(
                                    label: '${d}d',
                                    selected: days == d,
                                    onTap: () => setState(() => _durationDays[app.name] = d),
                                  ),
                                _PillButton(
                                  label: isCustom ? '${days}d' : '+',
                                  selected: isCustom,
                                  onTap: () async {
                                    final picked = await CustomDurationSheet.show(context, initialDays: days, minDays: 1, maxDays: 365);
                                    if (!mounted || picked == null) return;
                                    setState(() => _durationDays[app.name] = picked);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text('Daily time limit', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontSize: 12)),
                            const SizedBox(height: AppSpacing.sm),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: SoftlockColors.primary,
                                inactiveTrackColor: SoftlockColors.border.withValues(alpha: 0.5),
                                thumbColor: SoftlockColors.primary,
                                overlayColor: SoftlockColors.primary.withValues(alpha: 0.18),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: minutes,
                                min: 15,
                                max: 180,
                                divisions: 11,
                                onChanged: (v) => setState(() => _dailyMinutes[app.name] = v),
                              ),
                            ),
                            Center(
                              child: Text(
                                _formatMinutes(minutes.round()),
                                style: text.titleMedium?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _partnerAgreed ? _startDetox : null,
                  style: ButtonStyle(
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.disabled)
                          ? SoftlockColors.primary.withValues(alpha: 0.35)
                          : SoftlockColors.primary,
                    ),
                  ),
                  child: const Text('Start my detox 🔒'),
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

class _OnboardingApp {
  const _OnboardingApp(this.name, this.color);
  final String name;
  final Color color;
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? SoftlockColors.primary : SoftlockColors.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? SoftlockColors.primary : SoftlockColors.border, width: 1),
        ),
        child: Text(
          label,
          style: text.labelLarge?.copyWith(
            color: selected ? SoftlockColors.textPrimary : SoftlockColors.textPrimary.withValues(alpha: 0.9),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PartnerSection extends StatelessWidget {
  const _PartnerSection({
    required this.country,
    required this.phoneController,
    required this.onCountryChanged,
    required this.agreed,
    required this.onAgreedChanged,
  });

  final Country country;
  final TextEditingController phoneController;
  final ValueChanged<Country> onCountryChanged;
  final bool agreed;
  final ValueChanged<bool> onAgreedChanged;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Accountability Partner', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text('They will send you OTP codes', style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),
          PhoneNumberInputRow(country: country, onCountryChanged: onCountryChanged, controller: phoneController),
          const SizedBox(height: AppSpacing.md),
          SoftlockCheckboxCard(
            value: agreed,
            label: 'My partner has agreed\n to receive messages from Softlock',
            onChanged: onAgreedChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Your partner does not need the app', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _AppInitial extends StatelessWidget {
  const _AppInitial({required this.name, required this.color});
  final String name;
  final Color color;

  Color _foregroundFor(Color bg) => bg.computeLuminance() > 0.6 ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Text(
      name.characters.first.toUpperCase(),
      style: text.labelLarge?.copyWith(color: _foregroundFor(color), fontWeight: FontWeight.w900),
    );
  }
}

String _formatMinutes(int minutes) {
  if (minutes < 60) return '$minutes minutes';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (m == 0) return h == 1 ? '1 hour' : '$h hours';
  return '${h}h ${m}m';
}
