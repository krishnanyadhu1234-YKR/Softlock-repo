import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/theme.dart';

class DeleteConfirmScreen extends StatefulWidget {
  const DeleteConfirmScreen({super.key});

  @override
  State<DeleteConfirmScreen> createState() => _DeleteConfirmScreenState();
}

class _DeleteConfirmScreenState extends State<DeleteConfirmScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  bool get _canDelete => _controller.text.trim() == 'DELETE';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showStub(String message) {
    debugPrint(message);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: const BorderSide(color: SoftlockColors.border, width: 1),
    );

    final dangerFocused = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: const BorderSide(color: SoftlockColors.danger, width: 1.6),
    );

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
                  Expanded(child: Center(child: Text('Delete Account', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800)))),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView(
                padding: AppSpacing.paddingMd,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  const Icon(Icons.warning_amber_rounded, size: 48, color: SoftlockColors.danger),
                  const SizedBox(height: AppSpacing.sm),
                  Center(child: Text('Are you sure?', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 22))),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    decoration: BoxDecoration(
                      color: SoftlockColors.card,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: SoftlockColors.border, width: 1),
                    ),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('This will permanently delete:', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                        const SizedBox(height: AppSpacing.sm),
                        Text('• Your profile and name', style: text.bodyMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w600)),
                        Text('• All usage history and stats', style: text.bodyMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w600)),
                        Text('• Your token balance', style: text.bodyMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w600)),
                        Text('• Your detox progress and streaks', style: text.bodyMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w600)),
                        Text('• Partner connections', style: text.bodyMedium?.copyWith(color: SoftlockColors.textPrimary, fontWeight: FontWeight.w600)),
                        const SizedBox(height: AppSpacing.md),
                        Center(
                          child: Text(
                            'This cannot be undone.',
                            textAlign: TextAlign.center,
                            style: text.bodyMedium?.copyWith(color: SoftlockColors.danger, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Type DELETE to confirm', style: text.bodySmall?.copyWith(color: SoftlockColors.textSecondary)),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textCapitalization: TextCapitalization.characters,
                    style: text.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Type DELETE here',
                      filled: true,
                      fillColor: SoftlockColors.card,
                      enabledBorder: inputBorder,
                      focusedBorder: dangerFocused,
                      border: inputBorder,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canDelete
                          ? () {
                              FocusScope.of(context).unfocus();
                              _showStub('Account deleted (stub).');
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.disabled) ? SoftlockColors.border : SoftlockColors.danger,
                        ),
                        foregroundColor: const WidgetStatePropertyAll(SoftlockColors.textPrimary),
                        overlayColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.pressed) ? SoftlockColors.textPrimary.withValues(alpha: 0.08) : null,
                        ),
                      ),
                      child: const Text('Delete Everything'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: ButtonStyle(
                        foregroundColor: const WidgetStatePropertyAll(SoftlockColors.textSecondary),
                        side: const WidgetStatePropertyAll(BorderSide(color: SoftlockColors.border, width: 1)),
                      ),
                      child: const Text('Cancel · Keep my account'),
                    ),
                  ),
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
