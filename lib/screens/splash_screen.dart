import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/nav.dart';
import 'package:softlock/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted || _navigated) return;
      _navigated = true;
      context.go(AppRoutes.consent);
    } catch (e) {
      debugPrint('Splash timer/navigation failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: _SplashContent()));
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_rounded, size: 80, color: SoftlockColors.primary),
        const SizedBox(height: 14),
        Text('Softlock', style: text.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Gently lock your limits', style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary, fontSize: 14)),
      ],
    );
  }
}
