import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/favorites_home/application/saved_restaurants_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class SavedRestaurantsPage extends ConsumerWidget {
  const SavedRestaurantsPage({super.key, this.useRemoteImages = true});

  final bool useRemoteImages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(savedRestaurantsProvider);
    final selectedTab = ref.watch(selectedSavedRestaurantTabProvider);
    final tabController = ref.read(selectedSavedRestaurantTabProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            final restaurants = selectedTab == 'Restaurants'
                ? overview.restaurants
                : const <FavoriteRestaurantModel>[];
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeFood)),
                _Tabs(
                  tabs: overview.tabs,
                  selectedTab: selectedTab,
                  onTabSelected: tabController.select,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == restaurants.length - 1 ? 0 : 14,
                        ),
                        child: _RestaurantCard(
                          restaurant: restaurant,
                          useRemoteImages: useRemoteImages,
                          onOrderTap: () =>
                              context.go(AppRoutes.homeRestaurantDetails),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load favorites: $error')),
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
      color: isDark ? const Color(0xFF221017) : Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Symbols.arrow_back_ios),
          ),
          const Expanded(
            child: Text(
              'Favorites',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Symbols.search)),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF221017) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) {
          final active = tab == selectedTab;
          return Expanded(
            child: InkWell(
              key: Key('favorites-tab-$tab'),
              onTap: () => onTabSelected(tab),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: active ? QBTokens.primary : Colors.transparent,
                      width: 2.4,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? QBTokens.primary : const Color(0xFF94A3B8),
                    fontSize: 13,
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

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.restaurant,
    required this.useRemoteImages,
    required this.onOrderTap,
  });

  final FavoriteRestaurantModel restaurant;
  final bool useRemoteImages;
  final VoidCallback onOrderTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: useRemoteImages
                    ? CachedNetworkImage(
                        imageUrl: restaurant.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ColoredBox(color: Color(0xFFFCE7F3)),
                        errorWidget: (context, url, error) =>
                            const ColoredBox(color: Color(0xFFFCE7F3)),
                      )
                    : const ColoredBox(color: Color(0xFFFCE7F3)),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Symbols.favorite,
                    color: QBTokens.primary,
                    fill: 1,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Symbols.star,
                      fill: 1,
                      color: Color(0xFFFACC15),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.ratingLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.metadataLabel,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.deliveryOfferLabel,
                        style: TextStyle(
                          color:
                              restaurant.deliveryOfferLabel.startsWith('Free')
                              ? QBTokens.primary
                              : const Color(0xFF64748B),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    FilledButton(
                      key: Key('favorite-order-${restaurant.id}'),
                      onPressed: onOrderTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: QBTokens.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(106, 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Order Now'),
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
