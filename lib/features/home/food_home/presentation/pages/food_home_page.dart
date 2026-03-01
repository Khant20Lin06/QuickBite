import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/food_home/application/food_home_controller.dart';
import 'package:quickbite/features/home/pandamart_home/application/pandamart_home_controller.dart';
import 'package:quickbite/features/home/restaurant_details_home/application/restaurant_details_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/home_bottom_nav.dart';
import 'package:quickbite/shared/ui/molecules/home_section_header.dart';
import 'package:quickbite/shared/ui/molecules/promo_card.dart';

class FoodHomePage extends ConsumerWidget {
  const FoodHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(foodHomeFeedProvider);
    final selectedTileId = ref.watch(selectedHomeTileProvider);
    final selectedTileController = ref.read(selectedHomeTileProvider.notifier);
    final restaurantCartCount = ref.watch(restaurantCartCountProvider);
    final pandamartCartCount = ref.watch(pandamartCartProvider).totalItems;
    final basketCount = restaurantCartCount + pandamartCartCount;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: feedState.when(
          data: (feed) {
            return Column(
              children: [
                _HomeHeader(
                  address: feed.address,
                  searchPlaceholder: feed.searchPlaceholder,
                  onAddressTap: () => context.push(AppRoutes.homeAddress),
                  onSearchTap: () => context.go(AppRoutes.homeSearch),
                  onFavoritesTap: () => context.go(AppRoutes.homeFavorites),
                  onBasketTap: () => context.push(AppRoutes.homeCheckout),
                  basketCount: basketCount,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: PromoCard(
                            title: feed.promoBanner.title,
                            subtitle: feed.promoBanner.subtitle,
                            ctaLabel: feed.promoBanner.ctaLabel,
                            imageAsset: feed.promoBanner.imageAsset,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _MainTileGrid(
                            tiles: feed.mainTiles,
                            selectedTileId: selectedTileId,
                            onTilePressed: (tileId) {
                              selectedTileController.select(tileId);
                              if (tileId == 'pandamart') {
                                context.go(AppRoutes.homePandamart);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: HomeSectionHeader(
                            title: 'Available Vouchers',
                            actionLabel: 'View All',
                            onActionPressed: () =>
                                context.go(AppRoutes.homeVouchers),
                          ),
                        ),
                        SizedBox(
                          height: 104,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: feed.voucherSummaries.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final voucher = feed.voucherSummaries[index];
                              return _VoucherSummaryCard(voucher: voucher);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: HomeSectionHeader(
                            title: 'Restaurants Near You',
                            actionLabel: 'See More',
                            onActionPressed: () =>
                                context.push(AppRoutes.homeRestaurantDetails),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              for (
                                var i = 0;
                                i < feed.restaurants.length;
                                i++
                              ) ...[
                                _RestaurantCard(
                                  restaurant: feed.restaurants[i],
                                  onTap: () => context.push(
                                    AppRoutes.homeRestaurantDetails,
                                  ),
                                ),
                                if (i != feed.restaurants.length - 1)
                                  const SizedBox(height: 20),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                HomeBottomNav(
                  current: HomeBottomNavItem.home,
                  onItemTap: (tab) {
                    if (tab == HomeBottomNavItem.vouchers) {
                      context.go(AppRoutes.homeVouchers);
                    } else if (tab == HomeBottomNavItem.orders) {
                      context.go(AppRoutes.homeOrders);
                    } else if (tab == HomeBottomNavItem.profile) {
                      context.go(AppRoutes.homeProfile);
                    }
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load home feed: $error')),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.address,
    required this.searchPlaceholder,
    required this.onAddressTap,
    required this.onSearchTap,
    required this.onFavoritesTap,
    required this.onBasketTap,
    required this.basketCount,
  });

  final String address;
  final String searchPlaceholder;
  final VoidCallback onAddressTap;
  final VoidCallback onSearchTap;
  final VoidCallback onFavoritesTap;
  final VoidCallback onBasketTap;
  final int basketCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF2221017) : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Symbols.location_on,
                  color: QBTokens.primary,
                  size: 28,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: InkWell(
                    key: const Key('home-address-button'),
                    onTap: onAddressTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DELIVERY ADDRESS',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  address,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Icon(
                                Symbols.expand_more,
                                color: QBTokens.primary,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  key: const Key('home-favorites-button'),
                  onTap: onFavoritesTap,
                  borderRadius: BorderRadius.circular(999),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Symbols.favorite),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  key: const Key('home-basket-button'),
                  onTap: onBasketTap,
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Symbols.shopping_bag),
                        if (basketCount > 0)
                          Positioned(
                            top: -6,
                            right: -8,
                            child: Container(
                              key: const Key('home-basket-count'),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                color: QBTokens.primary,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                basketCount > 99
                                    ? '99+'
                                    : basketCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: InkWell(
              key: const Key('home-search-bar'),
              onTap: onSearchTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Symbols.search, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        searchPlaceholder,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainTileGrid extends StatelessWidget {
  const _MainTileGrid({
    required this.tiles,
    required this.selectedTileId,
    required this.onTilePressed,
  });

  final List<CategoryChipModel> tiles;
  final String selectedTileId;
  final ValueChanged<String> onTilePressed;

  @override
  Widget build(BuildContext context) {
    final first = tiles.length > 1 ? tiles.sublist(0, 2) : tiles;
    final second = tiles.length > 2
        ? tiles.sublist(2)
        : const <CategoryChipModel>[];

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < first.length; i++) ...[
              Expanded(
                child: _MainTile(
                  tile: first[i],
                  selected: selectedTileId == first[i].id,
                  onPressed: () => onTilePressed(first[i].id),
                ),
              ),
              if (i != first.length - 1) const SizedBox(width: 12),
            ],
          ],
        ),
        if (second.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < second.length; i++) ...[
                Expanded(
                  child: _QuickActionTile(
                    tile: second[i],
                    selected: selectedTileId == second[i].id,
                    onPressed: () => onTilePressed(second[i].id),
                  ),
                ),
                if (i != second.length - 1) const SizedBox(width: 12),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _MainTile extends StatelessWidget {
  const _MainTile({
    required this.tile,
    required this.selected,
    required this.onPressed,
  });

  final CategoryChipModel tile;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: tile.title,
      button: true,
      selected: selected,
      child: InkWell(
        key: Key('home-tile-${tile.id}'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? QBTokens.primary
                    : (isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFF1F5F9)),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tile.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tile.subtitle ?? '',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                if (tile.imageAsset != null)
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Transform.rotate(
                      angle: tile.id == 'food_delivery' ? 0.24 : -0.12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          tile.imageAsset!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.tile,
    required this.selected,
    required this.onPressed,
  });

  final CategoryChipModel tile;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      key: Key('home-tile-${tile.id}'),
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? QBTokens.primary
                : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                tile.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0x1AF1277B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                mapMaterialSymbol(tile.iconName ?? 'home'),
                color: QBTokens.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoucherSummaryCard extends StatelessWidget {
  const _VoucherSummaryCard({required this.voucher});

  final VoucherSummaryModel voucher;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x0DF1277B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4DF1277B),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: QBTokens.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(
              mapMaterialSymbol(voucher.iconName),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  voucher.title.toUpperCase(),
                  style: const TextStyle(
                    color: QBTokens.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  voucher.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  voucher.terms,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant, required this.onTap});

  final RestaurantCardModel restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      key: Key('home-restaurant-${restaurant.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      restaurant.imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (restaurant.promoTag != null)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: QBTokens.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          restaurant.promoTag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Symbols.favorite,
                        fill: 1,
                        color: QBTokens.primary,
                        size: 18,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        restaurant.deliveryEta,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      restaurant.cuisineLine,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Symbols.star,
                      fill: 1,
                      color: Color(0xFFEAB308),
                      size: 16,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      restaurant.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      restaurant.reviewCountLabel,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
