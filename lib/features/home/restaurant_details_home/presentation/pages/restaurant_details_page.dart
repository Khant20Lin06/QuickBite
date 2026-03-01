import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/restaurant_details_home/application/restaurant_details_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class RestaurantDetailsPage extends ConsumerWidget {
  const RestaurantDetailsPage({super.key, this.useRemoteImages = true});

  final bool useRemoteImages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(restaurantDetailsProvider);
    final selectedTab = ref.watch(selectedRestaurantDetailsTabProvider);
    final tabController = ref.read(
      selectedRestaurantDetailsTabProvider.notifier,
    );
    final cartCount = ref.watch(restaurantCartCountProvider);
    final cartController = ref.read(restaurantCartCountProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            return Stack(
              children: [
                Column(
                  children: [
                    _TopBar(
                      onBack: () => context.go(AppRoutes.homeFood),
                      onFavoriteTap: () {},
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroImage(
                              imageUrl: overview.heroImageUrl,
                              useRemoteImages: useRemoteImages,
                            ),
                            _RestaurantInfo(
                              overview: overview,
                              useRemoteImages: useRemoteImages,
                            ),
                            _TabBar(
                              selectedTab: selectedTab,
                              onTabSelected: tabController.select,
                            ),
                            if (selectedTab == RestaurantDetailsTab.menu) ...[
                              _SectionTitle(title: 'Popular Items'),
                              for (
                                var i = 0;
                                i < overview.popularItems.length;
                                i++
                              )
                                _PopularMenuTile(
                                  item: overview.popularItems[i],
                                  useRemoteImages: useRemoteImages,
                                  onAdd: cartController.addItem,
                                  addKey: Key(
                                    'restaurant-popular-add-${overview.popularItems[i].id}',
                                  ),
                                ),
                              Container(
                                color: const Color(0x0DF1277B),
                                padding: const EdgeInsets.only(bottom: 12),
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const _SectionTitle(title: 'Combo Meals'),
                                    SizedBox(
                                      height: 282,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: overview.comboItems.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 12),
                                        itemBuilder: (context, index) {
                                          final combo =
                                              overview.comboItems[index];
                                          return _ComboCard(
                                            item: combo,
                                            useRemoteImages: useRemoteImages,
                                            onAdd: cartController.addItem,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const _SectionTitle(title: 'Drinks'),
                              for (var i = 0; i < overview.drinks.length; i++)
                                _DrinkTile(
                                  item: overview.drinks[i],
                                  onAdd: cartController.addItem,
                                ),
                              _StoreInfoCard(
                                info: overview.storeInfo,
                                useRemoteImages: useRemoteImages,
                              ),
                            ] else if (selectedTab ==
                                RestaurantDetailsTab.reviews) ...[
                              const _PlaceholderSection(
                                title: 'Reviews',
                                description:
                                    'Customer reviews and ratings will appear here.',
                              ),
                            ] else ...[
                              _StoreInfoCard(
                                info: overview.storeInfo,
                                useRemoteImages: useRemoteImages,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 18,
                  child: FilledButton(
                    key: const Key('restaurant-view-cart-button'),
                    onPressed: () => context.push(AppRoutes.homeCheckout),
                    style: FilledButton.styleFrom(
                      backgroundColor: QBTokens.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'View Cart',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          overview.cartTotalLabel,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load restaurant details: $error')),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.onFavoriteTap});

  final VoidCallback onBack;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Symbols.arrow_back,
            onTap: onBack,
            filled: false,
          ),
          const Spacer(),
          _CircleIconButton(
            icon: Symbols.favorite,
            onTap: onFavoriteTap,
            filled: true,
            accent: true,
          ),
          const SizedBox(width: 8),
          _CircleIconButton(icon: Symbols.search, onTap: () {}, filled: true),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.filled,
    this.accent = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: filled
              ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          fill: accent ? 1 : 0,
          color: accent ? QBTokens.primary : null,
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl, required this.useRemoteImages});

  final String imageUrl;
  final bool useRemoteImages;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: useRemoteImages
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const ColoredBox(color: Color(0xFFFCE7F3)),
                  errorWidget: (context, url, error) =>
                      const ColoredBox(color: Color(0xFFFCE7F3)),
                )
              : const ColoredBox(color: Color(0xFFFCE7F3)),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.42),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RestaurantInfo extends StatelessWidget {
  const _RestaurantInfo({
    required this.overview,
    required this.useRemoteImages,
  });

  final RestaurantDetailsOverview overview;
  final bool useRemoteImages;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, -34),
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  width: 4,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: useRemoteImages
                  ? CachedNetworkImage(
                      imageUrl: overview.logoImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const ColoredBox(color: Color(0xFFFCE7F3)),
                      errorWidget: (context, url, error) =>
                          const ColoredBox(color: Color(0xFFFCE7F3)),
                    )
                  : const ColoredBox(color: Color(0xFFFCE7F3)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          overview.name,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(
                        Symbols.verified,
                        color: QBTokens.primary,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    overview.cuisineLine,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Symbols.star,
                              color: QBTokens.primary,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              overview.ratingValue,
                              style: const TextStyle(
                                color: QBTokens.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        overview.reviewCountLabel,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '•',
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        overview.distanceLabel,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selectedTab, required this.onTabSelected});

  final RestaurantDetailsTab selectedTab;
  final ValueChanged<RestaurantDetailsTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = <RestaurantDetailsTab>[
      RestaurantDetailsTab.menu,
      RestaurantDetailsTab.reviews,
      RestaurantDetailsTab.info,
    ];
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF0F172A)
          : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) {
          final active = tab == selectedTab;
          return Expanded(
            child: InkWell(
              key: Key('restaurant-tab-${tab.name}'),
              onTap: () => onTabSelected(tab),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: active ? QBTokens.primary : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  tab == RestaurantDetailsTab.menu
                      ? 'Menu'
                      : tab == RestaurantDetailsTab.reviews
                      ? 'Reviews'
                      : 'Info',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? QBTokens.primary : const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PopularMenuTile extends StatelessWidget {
  const _PopularMenuTile({
    required this.item,
    required this.useRemoteImages,
    required this.onAdd,
    required this.addKey,
  });

  final RestaurantMenuItemModel item;
  final bool useRemoteImages;
  final VoidCallback onAdd;
  final Key addKey;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.priceLabel,
                    style: const TextStyle(
                      color: QBTokens.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: useRemoteImages
                      ? CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const ColoredBox(color: Color(0xFFFCE7F3)),
                          errorWidget: (context, url, error) =>
                              const ColoredBox(color: Color(0xFFFCE7F3)),
                        )
                      : const ColoredBox(color: Color(0xFFFCE7F3)),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    key: addKey,
                    onTap: onAdd,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: QBTokens.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Symbols.add,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
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

class _ComboCard extends StatelessWidget {
  const _ComboCard({
    required this.item,
    required this.useRemoteImages,
    required this.onAdd,
  });

  final RestaurantComboModel item;
  final bool useRemoteImages;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x22F1277B)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          useRemoteImages
              ? CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: double.infinity,
                  height: 124,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const ColoredBox(color: Color(0xFFFCE7F3)),
                  errorWidget: (context, url, error) =>
                      const ColoredBox(color: Color(0xFFFCE7F3)),
                )
              : const SizedBox(
                  width: double.infinity,
                  height: 124,
                  child: ColoredBox(color: Color(0xFFFCE7F3)),
                ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      item.priceLabel,
                      style: const TextStyle(
                        color: QBTokens.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: onAdd,
                  style: FilledButton.styleFrom(
                    backgroundColor: QBTokens.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Symbols.add_shopping_cart, size: 18),
                  label: const Text('Add Combo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrinkTile extends StatelessWidget {
  const _DrinkTile({required this.item, required this.onAdd});

  final RestaurantDrinkModel item;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.priceLabel,
                  style: const TextStyle(
                    color: QBTokens.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0x1AF1277B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Symbols.add, color: QBTokens.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreInfoCard extends StatelessWidget {
  const _StoreInfoCard({required this.info, required this.useRemoteImages});

  final RestaurantStoreInfoModel info;
  final bool useRemoteImages;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      color: isDark ? const Color(0xFF0F172A) : Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Store Info',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Symbols.location_on, color: QBTokens.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.addressLine1,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      info.addressLine2,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Symbols.schedule, color: QBTokens.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.hoursPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      info.hoursSecondary,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: useRemoteImages
                ? CachedNetworkImage(
                    imageUrl: info.mapImageUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const ColoredBox(color: Color(0xFFFCE7F3)),
                    errorWidget: (context, url, error) =>
                        const ColoredBox(color: Color(0xFFFCE7F3)),
                  )
                : const SizedBox(
                    width: double.infinity,
                    height: 160,
                    child: ColoredBox(color: Color(0xFFFCE7F3)),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderSection extends StatelessWidget {
  const _PlaceholderSection({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}
