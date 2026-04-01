import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softlock/theme.dart';

/// 6-box OTP input.
class OtpCodeInput extends StatefulWidget {
  const OtpCodeInput({super.key, this.length = 6, required this.onChanged});

  final int length;
  final ValueChanged<String> onChanged;

  @override
  State<OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<OtpCodeInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focus;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focus = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  void _emit() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged(code);
  }

  void _setAt(int index, String value) {
    if (value.isEmpty) {
      _controllers[index].text = '';
      _emit();
      return;
    }

    // Support paste into the first/any box.
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.isEmpty) return;
      for (int i = 0; i < widget.length; i++) {
        final pos = i;
        _controllers[pos].text = pos < digits.length ? digits[pos] : '';
      }
      _emit();
      final next = digits.length >= widget.length ? widget.length - 1 : digits.length;
      if (next >= 0 && next < _focus.length) _focus[next].requestFocus();
      return;
    }

    _controllers[index].text = value;
    _controllers[index].selection = TextSelection.collapsed(offset: 1);
    _emit();
    if (index < _focus.length - 1) _focus[index + 1].requestFocus();
  }

  void _backspace(int index) {
    if (_controllers[index].text.isNotEmpty) {
      _controllers[index].clear();
      _emit();
      return;
    }
    if (index > 0) {
      _focus[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        return SizedBox(
          width: 46,
          height: 56,
          child: Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
                _backspace(i);
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: TextField(
              controller: _controllers[i],
              focusNode: _focus[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              maxLength: 1,
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: SoftlockColors.card,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: const BorderSide(color: SoftlockColors.border, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: const BorderSide(color: SoftlockColors.border, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  borderSide: const BorderSide(color: SoftlockColors.primary, width: 1.6),
                ),
              ),
              onChanged: (v) {
                try {
                  _setAt(i, v);
                } catch (e) {
                  debugPrint('OTP set failed: $e');
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
