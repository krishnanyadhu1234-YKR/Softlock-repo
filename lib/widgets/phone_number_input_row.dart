import 'package:flutter/material.dart';
import 'package:softlock/models/country.dart';
import 'package:softlock/theme.dart';
import 'package:softlock/widgets/country_picker_sheet.dart';

/// Reusable phone number input row:
/// - Left: country selector
/// - Right: numeric phone input
class PhoneNumberInputRow extends StatelessWidget {
  const PhoneNumberInputRow({super.key, required this.country, required this.onCountryChanged, required this.controller, this.enabled = true});

  final Country country;
  final ValueChanged<Country> onCountryChanged;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppRadius.sm);

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled
                ? () => CountryPickerSheet.show(
                      context,
                      selected: country,
                      onSelected: onCountryChanged,
                    )
                : null,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: SoftlockColors.card,
                borderRadius: radius.copyWith(topRight: Radius.zero, bottomRight: Radius.zero),
                border: Border.all(color: SoftlockColors.border, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text('${country.flagEmoji} ${country.displayDial}', style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_down, color: SoftlockColors.textSecondary.withValues(alpha: enabled ? 1 : 0.45)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: SoftlockColors.card,
              borderRadius: radius.copyWith(topLeft: Radius.zero, bottomLeft: Radius.zero),
              border: Border.all(color: SoftlockColors.border, width: 1),
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              style: text.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Phone number',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
