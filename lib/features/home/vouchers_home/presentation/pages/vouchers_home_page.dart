import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/vouchers_home/application/vouchers_home_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/home_bottom_nav.dart';
import 'package:quickbite/shared/ui/molecules/voucher_card.dart';

class VouchersHomePage extends ConsumerWidget {
  const VouchersHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionState = ref.watch(vouchersCollectionProvider);
    final selectedTab = ref.watch(selectedVoucherTabProvider);
    final interactionState = ref.watch(voucherInteractionProvider);
    final tabController = ref.read(selectedVoucherTabProvider.notifier);
    final interactionController = ref.read(voucherInteractionProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? const Color(0xFF1A1A1A) : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: collectionState.when(
          data: (collection) {
            final filtered = collection.vouchers
                .where((voucher) => voucher.tab == selectedTab)
                .toList();
            return Column(
              children: [
                _VoucherHeader(
                  selectedTab: selectedTab,
                  tabs: collection.tabs,
                  onTabSelected: tabController.select,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      children: [
                        if (filtered.isEmpty) ...[
                          const _EmptyVoucherState(),
                          const SizedBox(height: 12),
                          _InviteRewardCard(reward: collection.inviteReward),
                        ] else ...[
                          for (
                            var index = 0;
                            index < filtered.length;
                            index++
                          ) ...[
                            VoucherCard(
                              voucher: filtered[index],
                              isApplied: interactionState.appliedVoucherIds
                                  .contains(filtered[index].id),
                              isCopied: interactionState.copiedVoucherIds
                                  .contains(filtered[index].id),
                              onActionPressed: () => _handleVoucherAction(
                                context,
                                interactionController,
                                filtered[index],
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (index == 1) ...[
                              _InviteRewardCard(
                                reward: collection.inviteReward,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                HomeBottomNav(
                  current: HomeBottomNavItem.vouchers,
                  onItemTap: (item) {
                    if (item == HomeBottomNavItem.home) {
                      context.go(AppRoutes.homeFood);
                    } else if (item == HomeBottomNavItem.orders) {
                      context.go(AppRoutes.homeOrders);
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
              Center(child: Text('Unable to load vouchers: $error')),
        ),
      ),
    );
  }
}

class _VoucherHeader extends StatelessWidget {
  const _VoucherHeader({
    required this.selectedTab,
    required this.tabs,
    required this.onTabSelected,
  });

  final VoucherTab selectedTab;
  final List<VoucherTab> tabs;
  final ValueChanged<VoucherTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                InkWell(
                  onTap: () => context.go(AppRoutes.homeFood),
                  borderRadius: BorderRadius.circular(999),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Symbols.arrow_back_ios_new,
                      color: QBTokens.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Vouchers & Offers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const Icon(Symbols.help),
              ],
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final active = tab == selectedTab;
                return _VoucherTabButton(
                  key: Key('voucher-tab-${tab.name}'),
                  tab: tab,
                  active: active,
                  onTap: () => onTabSelected(tab),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherTabButton extends StatelessWidget {
  const _VoucherTabButton({
    super.key,
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final VoucherTab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? QBTokens.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _tabLabel(tab),
          style: TextStyle(
            color: active ? QBTokens.primary : const Color(0xFF64748B),
            fontSize: 14,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _InviteRewardCard extends StatelessWidget {
  const _InviteRewardCard({required this.reward});

  final InviteRewardModel reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x0DF1277B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33F1277B)),
      ),
      child: Row(
        children: [
          Icon(
            mapMaterialSymbol(reward.iconName),
            color: QBTokens.primary,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  reward.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              reward.actionLabel,
              style: const TextStyle(
                color: QBTokens.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyVoucherState extends StatelessWidget {
  const _EmptyVoucherState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      key: const Key('voucher-empty-state'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: const Column(
        children: [
          Icon(Symbols.confirmation_number, color: Color(0xFF94A3B8)),
          SizedBox(height: 8),
          Text(
            'No vouchers available for this category yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

void _handleVoucherAction(
  BuildContext context,
  VoucherInteractionController controller,
  VoucherModel voucher,
) {
  switch (voucher.actionType) {
    case VoucherActionType.apply:
      controller.applyVoucher(voucher.id);
      break;
    case VoucherActionType.copyCode:
      controller.markCopied(voucher.id);
      Clipboard.setData(ClipboardData(text: voucher.id.toUpperCase()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voucher code copied (mock).')),
      );
      break;
    case VoucherActionType.claimed:
      break;
  }
}

String _tabLabel(VoucherTab tab) {
  switch (tab) {
    case VoucherTab.foodDelivery:
      return 'Food Delivery';
    case VoucherTab.pandamart:
      return 'Pandamart';
    case VoucherTab.shops:
      return 'Shops';
    case VoucherTab.subscriptions:
      return 'Subscriptions';
  }
}
