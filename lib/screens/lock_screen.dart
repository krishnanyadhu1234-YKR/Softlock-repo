import 'package:flutter/material.dart';
import 'package:softlock/theme.dart';
import 'package:softlock/widgets/otp_code_input.dart';
import 'package:url_launcher/url_launcher.dart';

/// Lock screen shown when a daily limit is reached.
///
/// Calm, intentional design: focuses on the user’s goal and provides two gentle
/// ways to continue (partner OTP or token).
class LockScreen extends StatefulWidget {
  const LockScreen({super.key, this.appName = 'Instagram', this.goal = 'I want to read more books', this.unlockedEarlyCount = 2, this.tokensRemaining = 2, this.partnerPhoneE164 = '+15551234567'});

  final String appName;
  final String goal;
  final int unlockedEarlyCount;
  final int tokensRemaining;

  /// Used for the “Request OTP from partner” SMS deep-link.
  /// Keep as E.164 (e.g. +14155552671) for best cross-platform support.
  final String partnerPhoneE164;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _otp = '';
  bool _verifying = false;
  bool _requesting = false;

  bool get _canVerify => _otp.trim().length == 6 && !_verifying;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    switchInCurve: Curves.easeOutCubic,
                    transitionBuilder: (child, anim) {
                      final slide = Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(anim);
                      return FadeTransition(opacity: anim, child: SlideTransition(position: slide, child: child));
                    },
                    child: KeyedSubtree(
                      key: ValueKey('${widget.appName}_${widget.goal}_${widget.unlockedEarlyCount}_${widget.tokensRemaining}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.md),
                          _TopSection(appName: widget.appName),
                          const SizedBox(height: AppSpacing.lg),
                          _GoalQuoteCard(goal: widget.goal),
                          const SizedBox(height: AppSpacing.md),
                          _UnlockCountRow(count: widget.unlockedEarlyCount),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'Enter OTP from your partner',
                            style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          OtpCodeInput(
                            onChanged: (v) => setState(() => _otp = v),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _canVerify ? _verifyOtp : null,
                              child: _verifying
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: SoftlockColors.textPrimary),
                                    )
                                  : const Text('Verify OTP'),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const _OrDivider(),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: widget.tokensRemaining > 0 ? _useToken : null,
                              child: Text('Use a Token  •  ${widget.tokensRemaining} remaining'),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'You have ${widget.tokensRemaining} tokens left this month',
                            textAlign: TextAlign.center,
                            style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _BottomRequestRow(
                busy: _requesting,
                onRequest: _requestOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    setState(() => _verifying = true);
    try {
      // Local-only stub: replace with real verification when backend is connected.
      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      final ok = _otp == '123456';
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Ask your partner for a new code.')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verified. Unlock granted.')),
      );
    } catch (e) {
      debugPrint('Verify OTP failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not verify right now. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _useToken() async {
    // Local-only stub.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token used (stub).')),
    );
  }

  Future<void> _requestOtp() async {
    setState(() => _requesting = true);
    try {
      final body = 'Softlock request: please send me today\'s OTP to unlock early.';
      final uri = _buildSmsUri(widget.partnerPhoneE164, body);
      final can = await canLaunchUrl(uri);
      if (!can) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMS is not available on this device.')),
        );
        return;
      }
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        debugPrint('launchUrl returned false for $uri');
      }
    } catch (e) {
      debugPrint('Request OTP SMS failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open SMS.')),
      );
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Uri _buildSmsUri(String phone, String body) {
    // iOS/Android support slightly different conventions; using queryParameters
    // works for most cases. On web this will usually be unavailable.
    return Uri(scheme: 'sms', path: phone, queryParameters: {'body': body});
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({required this.appName});

  final String appName;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xs),
        const Icon(Icons.lock_rounded, size: 64, color: SoftlockColors.primary),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Daily limit reached',
          textAlign: TextAlign.center,
          style: text.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w800, color: SoftlockColors.textPrimary, height: 1.15),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          appName,
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(fontSize: 14, color: SoftlockColors.textSecondary),
        ),
      ],
    );
  }
}

class _GoalQuoteCard extends StatelessWidget {
  const _GoalQuoteCard({required this.goal});

  final String goal;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: SoftlockColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: SoftlockColors.border.withValues(alpha: 0.8), width: 1),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your goal:', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '“$goal”',
            style: text.titleMedium?.copyWith(color: SoftlockColors.textPrimary, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _UnlockCountRow extends StatelessWidget {
  const _UnlockCountRow({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final safeCount = count < 0 ? 0 : count;
    final marks = safeCount == 0 ? '—' : List.filled(safeCount, '|').join();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Unlocked early today: ',
          style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontWeight: FontWeight.w600),
        ),
        Text(
          marks,
          style: text.titleMedium?.copyWith(color: SoftlockColors.warning, fontWeight: FontWeight.w800, letterSpacing: 2),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: SoftlockColors.border.withValues(alpha: 0.6))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('or', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontWeight: FontWeight.w700)),
        ),
        Expanded(child: Container(height: 1, color: SoftlockColors.border.withValues(alpha: 0.6))),
      ],
    );
  }
}

class _BottomRequestRow extends StatefulWidget {
  const _BottomRequestRow({required this.busy, required this.onRequest});

  final bool busy;
  final Future<void> Function() onRequest;

  @override
  State<_BottomRequestRow> createState() => _BottomRequestRowState();
}

class _BottomRequestRowState extends State<_BottomRequestRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Request OTP from partner', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
          const SizedBox(width: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.busy ? null : widget.onRequest,
            onTapDown: (_) => setState(() {
              _pressed = true;
            }),
            onTapUp: (_) => setState(() {
              _pressed = false;
            }),
            onTapCancel: () => setState(() {
              _pressed = false;
            }),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: _pressed ? 0.7 : 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: widget.busy
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: SoftlockColors.primary),
                      )
                    : Text(
                        'Send SMS',
                        style: text.bodySmall?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w800),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
