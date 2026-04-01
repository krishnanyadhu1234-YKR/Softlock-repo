import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/countries.dart';
import 'package:softlock/models/country.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';
import 'package:softlock/widgets/otp_code_input.dart';
import 'package:softlock/widgets/phone_number_input_row.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Country _country;
  final TextEditingController _phone = TextEditingController();
  String _otp = '';
  bool _otpSent = false;

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

  void _sendOtp() {
    setState(() => _otpSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent (stub)'), duration: Duration(seconds: 2)),
    );
  }

  void _verify() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verified $_otp (stub)'), duration: const Duration(seconds: 2)),
    );
    context.go(AppRoutes.onboarding1);
  }

  bool get _canSend => _phone.text.trim().replaceAll(RegExp(r'\D'), '').length >= 6;
  bool get _canVerify => _otp.length == 6;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('Welcome to Softlock', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter your phone number to continue',
                style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              PhoneNumberInputRow(
                country: _country,
                controller: _phone,
                onCountryChanged: (c) => setState(() => _country = c),
                enabled: true,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _canSend ? _sendOtp : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.disabled)
                          ? SoftlockColors.primary.withValues(alpha: 0.35)
                          : SoftlockColors.primary,
                    ),
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  ),
                  child: const Text('Send OTP'),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(child: Divider(color: SoftlockColors.border.withValues(alpha: 0.35), height: 1)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              OtpCodeInput(
                onChanged: (code) => setState(() => _otp = code),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _otpSent && _canVerify ? _verify : null,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.disabled)
                          ? SoftlockColors.primary.withValues(alpha: 0.22)
                          : SoftlockColors.primary,
                    ),
                    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  ),
                  child: const Text('Verify'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'OTP will be sent via SMS to your number',
                textAlign: TextAlign.center,
                style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
