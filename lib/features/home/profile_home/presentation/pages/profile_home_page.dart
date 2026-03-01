import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/profile_home/application/profile_home_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/home_bottom_nav.dart';

class ProfileHomePage extends ConsumerWidget {
  const ProfileHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileOverviewProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? const Color(0xFF121212) : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: profileState.when(
          data: (profile) {
            return Column(
              children: [
                _ProfileHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileHero(profile: profile),
                        const SizedBox(height: 12),
                        _ProfileMenuList(
                          items: profile.primaryItems,
                          onTap: (id) {
                            if (id == 'vouchers') {
                              context.go(AppRoutes.homeVouchers);
                            } else if (id == 'payment') {
                              context.go(AppRoutes.homePayments);
                            } else if (id == 'addresses') {
                              context.go(AppRoutes.homeAddress);
                            } else if (id == 'help') {
                              context.go(AppRoutes.homeHelp);
                            } else if (id == 'settings') {
                              context.go(AppRoutes.homeSettings);
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: Text(
                            'MORE OPTIONS',
                            style: TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        _ProfileMenuList(
                          items: profile.secondaryItems,
                          onTap: (id) {
                            if (id == 'invite') {
                              context.go(AppRoutes.homeInvite);
                            } else if (id == 'privacy') {
                              context.go(AppRoutes.homePrivacy);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Symbols.logout),
                            label: const Text(
                              'Log Out',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              foregroundColor: QBTokens.primary,
                              side: const BorderSide(
                                color: QBTokens.primary,
                                width: 1.6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            profile.versionLabel,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 10,
                            ),
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
                    }
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load profile: $error')),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go(AppRoutes.homeFood),
            borderRadius: BorderRadius.circular(999),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Symbols.arrow_back_ios_new, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Edit',
              style: TextStyle(
                color: QBTokens.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  final ProfileOverview profile;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0x33F1277B), width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(profile.avatarAsset, fit: BoxFit.cover),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: QBTokens.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Symbols.verified,
                    color: Colors.white,
                    size: 16,
                    fill: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1AF1277B),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.star,
                            color: QBTokens.primary,
                            size: 14,
                            fill: 1,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'PANDAPRO',
                            style: TextStyle(
                              color: QBTokens.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        profile.memberSince,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuList extends StatelessWidget {
  const _ProfileMenuList({required this.items, required this.onTap});

  final List<ProfileMenuItemModel> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _ProfileMenuTile(item: items[i], onTap: () => onTap(items[i].id)),
            if (i != items.length - 1)
              Divider(
                height: 1,
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF8FAFC),
              ),
          ],
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({required this.item, required this.onTap});

  final ProfileMenuItemModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('profile-menu-${item.id}'),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(mapMaterialSymbol(item.iconName), color: QBTokens.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (item.badgeLabel != null) ...[
              Text(
                item.badgeLabel!,
                style: const TextStyle(
                  color: QBTokens.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(Symbols.chevron_right, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }
}
