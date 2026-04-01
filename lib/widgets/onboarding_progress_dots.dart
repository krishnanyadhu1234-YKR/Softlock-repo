import 'package:flutter/material.dart';
import 'package:softlock/theme.dart';

/// Simple 3-dot progress indicator used across onboarding screens.
class OnboardingProgressDots extends StatelessWidget {
  const OnboardingProgressDots({super.key, required this.activeIndex, this.count = 3});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final bool active = i == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: active ? SoftlockColors.primary : SoftlockColors.border.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
