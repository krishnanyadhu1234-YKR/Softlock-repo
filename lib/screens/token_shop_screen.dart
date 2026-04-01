import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/theme.dart';

class TokenShopScreen extends StatelessWidget {
  const TokenShopScreen({super.key});

  void _showStub(BuildContext context, String message) {
    debugPrint(message);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final status = Theme.of(context).extension<SoftlockStatusColors>();
    final success = status?.success ?? SoftlockColors.success;

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
                  Expanded(child: Center(child: Text('Tokens', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: SoftlockColors.card,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: SoftlockColors.border, width: 1),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.monetization_on_rounded, size: 34, color: SoftlockColors.primary),
                        const SizedBox(height: AppSpacing.sm),
                        Text('2 tokens', style: text.displaySmall?.copyWith(fontWeight: FontWeight.w900, fontSize: 36)),
                        const SizedBox(height: 2),
                        Text('remaining this month', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                        const SizedBox(height: AppSpacing.sm),
                        Text('3 free tokens reset on Apr 1', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    decoration: BoxDecoration(
                      color: SoftlockColors.card,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: SoftlockColors.border, width: 1),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('💡 What is a token?', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary, fontWeight: FontWeight.w800)),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Use a token to bypass your lock\nonce without needing your partner.\nPerfect for genuine emergencies.',
                          style: text.bodyMedium?.copyWith(color: SoftlockColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Buy more tokens', style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: AppSpacing.sm),
                  _PurchaseCard(
                    title: '5 tokens',
                    price: '€1.99',
                    subtitle: '€0.40 per token',
                    onBuy: () => _showStub(context, 'Purchase 5 tokens (stub).'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _PurchaseCard(
                    title: '10 tokens',
                    price: '€2.99',
                    subtitle: '€0.30 per token · Save 25%',
                    subtitleColor: success,
                    badge: 'BEST VALUE',
                    emphasized: true,
                    onBuy: () => _showStub(context, 'Purchase 10 tokens (stub).'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(child: Text('Tokens expire after 90 days', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary))),
                  const SizedBox(height: 6),
                  Center(child: Text('Purchases are non-refundable', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary))),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  const _PurchaseCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.onBuy,
    this.subtitleColor,
    this.badge,
    this.emphasized = false,
  });

  final String title;
  final String price;
  final String subtitle;
  final Color? subtitleColor;
  final String? badge;
  final bool emphasized;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: SoftlockColors.card,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: emphasized ? SoftlockColors.primary : SoftlockColors.border, width: emphasized ? 1.35 : 1),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: text.titleMedium?.copyWith(fontWeight: FontWeight.w900, fontSize: 20))),
                  Text(price, style: text.titleLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 24, color: SoftlockColors.primary)),
                ],
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: text.bodySmall?.copyWith(color: subtitleColor ?? SoftlockColors.textSecondary, fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onBuy,
                  child: const Text('Buy'),
                ),
              ),
            ],
          ),
        ),
        if (badge != null)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: SoftlockColors.primary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: SoftlockColors.primary.withValues(alpha: 0.35), width: 1),
              ),
              child: Text(badge!, style: text.labelSmall?.copyWith(color: SoftlockColors.primary, fontWeight: FontWeight.w900, letterSpacing: 0.7)),
            ),
          ),
      ],
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
