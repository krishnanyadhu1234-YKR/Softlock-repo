import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';
import 'package:softlock/widgets/softlock_checkbox_card.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _ageConfirmed = false;
  bool _termsConfirmed = false;

  bool get _canContinue => _ageConfirmed && _termsConfirmed;

  void _openStub(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what (stub)'), duration: const Duration(seconds: 2)),
    );
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
              const SizedBox(height: AppSpacing.lg),
              const Align(alignment: Alignment.center, child: Icon(Icons.lock_rounded, size: 40, color: SoftlockColors.primary)),
              const SizedBox(height: AppSpacing.lg),
              Text('Before you start', style: text.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'We collect your phone number and app\nusage data to run your detox. We never\nsell your data. Stored securely in the EU.',
                style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary, fontSize: 14, height: 1.55),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 18,
                runSpacing: 8,
                children: [
                  _LinkText(label: 'Privacy Policy', onTap: () => _openStub('Privacy Policy')),
                  _LinkText(label: 'Terms of Service', onTap: () => _openStub('Terms of Service')),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SoftlockCheckboxCard(value: _ageConfirmed, label: 'I confirm I am at least 16 years old', onChanged: (v) => setState(() => _ageConfirmed = v)),
              const SizedBox(height: AppSpacing.md),
              SoftlockCheckboxCard(value: _termsConfirmed, label: 'I agree to the Terms & Privacy Policy', onChanged: (v) => setState(() => _termsConfirmed = v)),
              const Spacer(),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _canContinue ? () => context.go(AppRoutes.login) : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.disabled)
                          ? SoftlockColors.primary.withValues(alpha: 0.35)
                          : SoftlockColors.primary,
                    ),
                    foregroundColor: const WidgetStatePropertyAll(SoftlockColors.textPrimary),
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: Text(
                    'Already have an account? Sign in',
                    style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
                  ),
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

class _LinkText extends StatelessWidget {
  const _LinkText({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: text.bodyMedium?.copyWith(color: SoftlockColors.primary, fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}
