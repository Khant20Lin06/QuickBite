import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/settings_home/application/app_settings_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class AppSettingsPage extends ConsumerWidget {
  const AppSettingsPage({super.key, this.useRemoteImages = true});

  final bool useRemoteImages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(appSettingsOverviewProvider);
    final selectedLanguage = ref.watch(selectedAppLanguageProvider);
    final languageController = ref.read(selectedAppLanguageProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeProfile)),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                    children: [
                      const _SectionLabel('ACCOUNT'),
                      const SizedBox(height: 8),
                      for (
                        var i = 0;
                        i < overview.accountItems.length;
                        i++
                      ) ...[
                        _AccountSettingTile(item: overview.accountItems[i]),
                        if (i != overview.accountItems.length - 1)
                          const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 18),
                      const _SectionLabel('PREFERENCES'),
                      const SizedBox(height: 8),
                      _LanguageTile(
                        selectedLanguage: selectedLanguage,
                        onSelect: languageController.select,
                      ),
                      const SizedBox(height: 8),
                      _CacheTile(cacheLabel: overview.preferenceCacheLabel),
                      const SizedBox(height: 18),
                      const _SectionLabel('SUPPORT & LEGAL'),
                      const SizedBox(height: 8),
                      for (var i = 0; i < overview.legalItems.length; i++) ...[
                        _LegalTile(
                          item: overview.legalItems[i],
                          onTap: () {
                            if (overview.legalItems[i].id == 'privacy-policy') {
                              context.go(AppRoutes.homePrivacy);
                            }
                          },
                        ),
                        if (i != overview.legalItems.length - 1)
                          const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          foregroundColor: const Color(0xFFEF4444),
                          minimumSize: const Size.fromHeight(52),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Symbols.logout),
                        label: const Text(
                          'Log Out',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        overview.versionLabel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Column(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF1F5F9),
                              ),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: useRemoteImages
                                ? CachedNetworkImage(
                                    imageUrl: overview.footerLogoUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                        const ColoredBox(
                                          color: Color(0xFFFCE7F3),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const ColoredBox(
                                          color: Color(0xFFFCE7F3),
                                        ),
                                  )
                                : const ColoredBox(color: Color(0xFFFCE7F3)),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Ordering made simple.',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load settings: $error')),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xEE221017) : const Color(0xEEFFFFFF),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Symbols.arrow_back_ios_new),
          ),
          const Expanded(
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _AccountSettingTile extends StatelessWidget {
  const _AccountSettingTile({required this.item});

  final AccountSettingsItemModel item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x660F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x1AF1277B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              mapMaterialSymbol(item.iconName),
              color: QBTokens.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Symbols.chevron_right, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.selectedLanguage, required this.onSelect});

  final String selectedLanguage;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x660F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x1AF1277B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Symbols.language, color: QBTokens.primary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'App Language',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _LanguageButton(
                  label: 'EN',
                  active: selectedLanguage == 'EN',
                  onTap: () => onSelect('EN'),
                ),
                const SizedBox(width: 4),
                _LanguageButton(
                  label: 'MM',
                  active: selectedLanguage == 'MM',
                  onTap: () => onSelect('MM'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      key: Key('settings-language-$label'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? (isDark ? const Color(0xFF475569) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? QBTokens.primary : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CacheTile extends StatelessWidget {
  const _CacheTile({required this.cacheLabel});

  final String cacheLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x660F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x1AF1277B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Symbols.delete_sweep, color: QBTokens.primary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Clear Cache',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            cacheLabel,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  const _LegalTile({required this.item, required this.onTap});

  final LegalSettingsItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      key: Key('settings-legal-${item.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0x660F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              mapMaterialSymbol(item.iconName),
              color: const Color(0xFF64748B),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Symbols.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
