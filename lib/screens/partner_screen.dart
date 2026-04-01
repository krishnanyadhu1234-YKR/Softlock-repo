import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/countries.dart';
import 'package:softlock/models/country.dart';
import 'package:softlock/theme.dart';
import 'package:softlock/widgets/phone_number_input_row.dart';
import 'package:softlock/widgets/softlock_checkbox_card.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  late Country _country;
  final TextEditingController _phone = TextEditingController();
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _country = CountriesData.popular.first;
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
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
                  Expanded(child: Center(child: Text('My Partner', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(color: SoftlockColors.border.withValues(alpha: 0.35), shape: BoxShape.circle),
                            child: Icon(Icons.person_rounded, color: SoftlockColors.textSecondary, size: 36),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text('Current Partner', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary, letterSpacing: 0.7)),
                          const SizedBox(height: 6),
                          Text('+31 6 98 765 432', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w900, fontSize: 20)),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Has received 4 OTP requests this month',
                            style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PhoneNumberInputRow(
                    country: _country,
                    onCountryChanged: (c) => setState(() => _country = c),
                    controller: _phone,
                    enabled: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _toast('Change Partner (stub) · Requires OTP'),
                      style: const ButtonStyle(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                      child: const Text('Change Partner'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current partner will be notified\nRequires their OTP to confirm change',
                    style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontSize: 12, height: 1.35),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SoftlockCheckboxCard(
                    value: _agreed,
                    label: 'My new partner has agreed to receive messages from Softlock',
                    onChanged: (v) => setState(() => _agreed = v),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Divider(color: SoftlockColors.border.withValues(alpha: 0.35), height: 1),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Partner App Status', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary, letterSpacing: 0.9)),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: SoftlockColors.textSecondary.withValues(alpha: 0.6), shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(child: Text('Not using Softlock', style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => _toast('Invite sent (stub)'),
                      style: ButtonStyle(
                        foregroundColor: const WidgetStatePropertyAll(SoftlockColors.primary),
                        side: const WidgetStatePropertyAll(BorderSide(color: SoftlockColors.primary, width: 1.2)),
                        overlayColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.pressed) ? SoftlockColors.primary.withValues(alpha: 0.08) : null,
                        ),
                      ),
                      child: const Text('Invite to Softlock'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Partner can approve or deny OTP requests directly in the app',
                    style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontSize: 12, height: 1.35),
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
