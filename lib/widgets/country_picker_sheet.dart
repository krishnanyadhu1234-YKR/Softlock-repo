import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softlock/data/countries.dart';
import 'package:softlock/models/country.dart';
import 'package:softlock/theme.dart';

/// Bottom sheet used by [PhoneNumberInputRow] to select a country.
class CountryPickerSheet extends StatefulWidget {
  const CountryPickerSheet({super.key, required this.selected, required this.onSelected});

  final Country selected;
  final ValueChanged<Country> onSelected;

  static Future<void> show(BuildContext context, {required Country selected, required ValueChanged<Country> onSelected}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => CountryPickerSheet(selected: selected, onSelected: onSelected),
    );
  }

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Country> _filtered(List<Country> countries) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return countries;

    bool matches(Country c) {
      final name = c.name.toLowerCase();
      final dial = c.dialCode;
      return name.contains(q) || dial.contains(q) || ('+$dial').contains(q);
    }

    return countries.where(matches).toList();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final selectedIso2 = widget.selected.iso2;
    final popular = _filtered(CountriesData.popular);
    final all = _filtered(CountriesData.all);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      child: Container(
        color: SoftlockColors.card,
        child: DraggableScrollableSheet(
          initialChildSize: 0.86,
          minChildSize: 0.55,
          maxChildSize: 0.96,
          expand: false,
          builder: (context, scrollController) {
            return CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: SoftlockColors.border.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Select country', style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _search,
                          onChanged: (_) => setState(() {}),
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search, color: SoftlockColors.textSecondary),
                            hintText: 'Search country or code…',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverList.separated(
                  itemCount: popular.length,
                  separatorBuilder: (_, __) => Divider(color: SoftlockColors.border.withValues(alpha: 0.28), height: 1),
                  itemBuilder: (context, index) {
                    final c = popular[index];
                    return _CountryRow(
                      country: c,
                      selected: c.iso2 == selectedIso2,
                      onTap: () {
                        widget.onSelected(c);
                        context.pop();
                      },
                    );
                  },
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: SoftlockColors.border.withValues(alpha: 0.35), height: 1),
                        const SizedBox(height: AppSpacing.sm),
                        Text('All countries', style: text.labelSmall?.copyWith(color: SoftlockColors.textSecondary, letterSpacing: 0.5)),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ),
                ),

                SliverList.separated(
                  itemCount: all.length,
                  separatorBuilder: (_, __) => Divider(color: SoftlockColors.border.withValues(alpha: 0.22), height: 1),
                  itemBuilder: (context, index) {
                    final c = all[index];
                    return _CountryRow(
                      country: c,
                      selected: c.iso2 == selectedIso2,
                      onTap: () {
                        widget.onSelected(c);
                        context.pop();
                      },
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CountryRow extends StatelessWidget {
  const _CountryRow({required this.country, required this.selected, required this.onTap});

  final Country country;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
          child: Row(
            children: [
              Text(country.flagEmoji, style: text.bodyLarge?.copyWith(fontSize: 18)),
              const SizedBox(width: 12),
              Expanded(child: Text(country.name, style: text.bodyMedium)),
              const SizedBox(width: 12),
              Text(country.displayDial, style: text.bodyMedium?.copyWith(color: SoftlockColors.textSecondary)),
              const SizedBox(width: 10),
              if (selected) const Icon(Icons.check, color: SoftlockColors.primary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
