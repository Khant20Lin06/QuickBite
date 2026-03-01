import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/privacy_home/application/privacy_policy_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/home_bottom_nav.dart';

class PrivacyPolicyPage extends ConsumerWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(privacyPolicyOverviewProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeSettings)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Last updated: ${overview.lastUpdated}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          overview.introduction,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle(
                          icon: Symbols.database,
                          title: 'Data Collection',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'We collect information you provide directly to us, such as when you create or modify your account, request delivery services, or contact customer support. This includes:',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...overview.dataCollectionItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Icon(
                                    Symbols.circle,
                                    size: 6,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 15,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                        const _SectionTitle(
                          icon: Symbols.visibility,
                          title: 'Use of Information',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The information we collect is used to provide, maintain, and improve our services, including:',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...overview.useCases.map(
                          (useCase) => _UseCaseCard(item: useCase),
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle(
                          icon: Symbols.share,
                          title: 'Third-Party Sharing',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          overview.thirdPartySharingText,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _SectionTitle(
                          icon: Symbols.gavel,
                          title: 'User Rights',
                        ),
                        const SizedBox(height: 8),
                        ...overview.userRights.map((right) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Icon(
                                    Symbols.check_circle,
                                    color: QBTokens.primary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    right,
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 14),
                        FilledButton(
                          onPressed: () => context.go(AppRoutes.homeHelp),
                          style: FilledButton.styleFrom(
                            backgroundColor: QBTokens.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Contact Support for Questions',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                HomeBottomNav(
                  current: HomeBottomNavItem.profile,
                  onItemTap: (item) {
                    if (item == HomeBottomNavItem.home) {
                      context.go(AppRoutes.homeFood);
                    } else if (item == HomeBottomNavItem.orders) {
                      context.go(AppRoutes.homeOrders);
                    } else if (item == HomeBottomNavItem.vouchers) {
                      context.go(AppRoutes.homeVouchers);
                    } else if (item == HomeBottomNavItem.profile) {
                      context.go(AppRoutes.homeProfile);
                    }
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load privacy policy: $error')),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Symbols.arrow_back_ios_new),
          ),
          const Expanded(
            child: Text(
              'Privacy Policy',
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0x1AF1277B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: QBTokens.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _UseCaseCard extends StatelessWidget {
  const _UseCaseCard({required this.item});

  final PrivacyHighlightModel item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x330F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x22F1277B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            item.subtitle,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
