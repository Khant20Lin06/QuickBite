import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/features/home/address_home/application/address_controller.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class AddAddressPage extends ConsumerWidget {
  const AddAddressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftState = ref.watch(addressDraftProvider);
    final formState = ref.watch(addressFormProvider);
    final formController = ref.read(addressFormProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      child: SafeArea(
        bottom: false,
        child: draftState.when(
          data: (draft) {
            if (!formState.initialized) {
              Future<void>.microtask(() {
                formController.seedFromDraft(draft);
              });
            }
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeProfile)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MapSection(imageAsset: draft.mapImageAsset),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Label as',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _AddressChip(
                                    label: 'Home',
                                    icon: Symbols.home,
                                    active:
                                        formState.selectedLabel ==
                                        AddressLabelType.home,
                                    onTap: () => formController.setLabel(
                                      AddressLabelType.home,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _AddressChip(
                                    label: 'Work',
                                    icon: Symbols.work,
                                    active:
                                        formState.selectedLabel ==
                                        AddressLabelType.work,
                                    onTap: () => formController.setLabel(
                                      AddressLabelType.work,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _AddressChip(
                                    label: 'Other',
                                    icon: Symbols.location_on,
                                    active:
                                        formState.selectedLabel ==
                                        AddressLabelType.other,
                                    onTap: () => formController.setLabel(
                                      AddressLabelType.other,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const _FieldLabel('STREET NAME'),
                              const SizedBox(height: 6),
                              _AddressField(
                                key: const Key('address-street-field'),
                                initialValue: formState.streetName,
                                onChanged: formController.setStreetName,
                                trailingIcon: Symbols.edit,
                              ),
                              const SizedBox(height: 12),
                              const _FieldLabel(
                                'BUILDING / FLOOR / UNIT NUMBER',
                              ),
                              const SizedBox(height: 6),
                              _AddressField(
                                key: const Key('address-unit-field'),
                                initialValue: formState.buildingUnit,
                                hintText: 'e.g. ION Orchard, #04-12',
                                onChanged: formController.setBuildingUnit,
                              ),
                              const SizedBox(height: 12),
                              const _FieldLabel('NOTE FOR RIDER'),
                              const SizedBox(height: 6),
                              TextField(
                                key: const Key('address-note-field'),
                                minLines: 3,
                                maxLines: 3,
                                onChanged: formController.setNoteForRider,
                                decoration: InputDecoration(
                                  hintText:
                                      'e.g. Leave at the door, lobby code is 1234',
                                  filled: true,
                                  fillColor: isDark
                                      ? const Color(0x801E293B)
                                      : const Color(0xFFF8FAFC),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFF1F5F9),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const Key('address-save-button'),
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: QBTokens.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Address',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load address draft: $error')),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Symbols.arrow_back_ios),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Add New Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  const _MapSection({required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          Positioned.fill(child: Image.asset(imageAsset, fit: BoxFit.cover)),
          Positioned(
            top: 86,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                    boxShadow: [
                      BoxShadow(color: Color(0x22000000), blurRadius: 10),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      'Pin your location',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Icon(
                  Symbols.location_on,
                  color: QBTokens.primary,
                  size: 46,
                  fill: 1,
                ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 8)],
              ),
              child: const Icon(Symbols.my_location),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressChip extends StatelessWidget {
  const _AddressChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: InkWell(
        key: Key('address-label-$label'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? const Color(0x0DF1277B)
                : (isDark ? const Color(0x801E293B) : Colors.white),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? QBTokens.primary
                  : (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0)),
              width: active ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: active ? QBTokens.primary : const Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: active ? QBTokens.primary : const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hintText,
    this.trailingIcon,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: isDark ? const Color(0x801E293B) : const Color(0xFFF8FAFC),
        suffixIcon: trailingIcon == null
            ? null
            : Icon(trailingIcon, color: const Color(0xFF94A3B8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
