import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/pandamart_home/application/pandamart_home_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/home_section_header.dart';
import 'package:quickbite/shared/ui/molecules/product_card.dart';
import 'package:quickbite/shared/ui/molecules/sticky_cart_bar.dart';

class PandamartHomePage extends ConsumerWidget {
  const PandamartHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(pandamartCatalogProvider);
    final cartState = ref.watch(pandamartCartProvider);
    final cartController = ref.read(pandamartCartProvider.notifier);
    final selectedCategoryId = ref.watch(selectedPandamartCategoryProvider);
    final selectedCategoryController = ref.read(
      selectedPandamartCategoryProvider.notifier,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : Colors.white,
      child: SafeArea(
        bottom: false,
        child: catalogState.when(
          data: (catalog) {
            final totalPrice = cartController.totalPrice(catalog.items);
            return Column(
              children: [
                _PandamartHeader(
                  title: catalog.title,
                  deliveryEta: catalog.deliveryEta,
                  searchPlaceholder: catalog.searchPlaceholder,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      0,
                      cartState.totalItems > 0 ? 90 : 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 108,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: catalog.categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final category = catalog.categories[index];
                              return _CategoryBubble(
                                category: category,
                                selected: selectedCategoryId == category.id,
                                onPressed: () => selectedCategoryController
                                    .select(category.id),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: HomeSectionHeader(
                            title: 'Popular Near You',
                            actionLabel: 'View all',
                            onActionPressed: () {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: catalog.items.isEmpty
                              ? const _EmptyCatalog()
                              : GridView.builder(
                                  itemCount: catalog.items.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.60,
                                      ),
                                  itemBuilder: (context, index) {
                                    final item = catalog.items[index];
                                    return ProductCard(
                                      itemId: item.id,
                                      title: item.name,
                                      unitLabel: item.unitLabel,
                                      priceLabel: _formatCurrency(item.price),
                                      originalPriceLabel:
                                          item.originalPrice == null
                                          ? null
                                          : _formatCurrency(
                                              item.originalPrice!,
                                            ),
                                      imageAsset: item.imageAsset,
                                      badgeText: item.badgeText,
                                      itemQuantity: cartState.quantityFor(
                                        item.id,
                                      ),
                                      onAddPressed: () =>
                                          cartController.addItem(item.id),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (cartState.totalItems > 0)
                  StickyCartBar(
                    itemCount: cartState.totalItems,
                    totalLabel: _formatCurrency(totalPrice),
                    onPressed: () {},
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load catalog: $error')),
        ),
      ),
    );
  }
}

class _PandamartHeader extends StatelessWidget {
  const _PandamartHeader({
    required this.title,
    required this.deliveryEta,
    required this.searchPlaceholder,
  });

  final String title;
  final String deliveryEta;
  final String searchPlaceholder;

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
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Row(
              children: [
                IconButton(
                  key: const Key('pandamart-back'),
                  onPressed: () => context.go(AppRoutes.homeFood),
                  color: QBTokens.primary,
                  icon: const Icon(Symbols.chevron_left, size: 28),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Symbols.schedule,
                            color: QBTokens.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              deliveryEta,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: QBTokens.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: const Key('pandamart-info'),
                  onPressed: () {},
                  icon: const Icon(Symbols.info),
                ),
                IconButton(
                  key: const Key('pandamart-vouchers'),
                  onPressed: () => context.go(AppRoutes.homeVouchers),
                  icon: const Icon(Symbols.favorite),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(
                    Symbols.search,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
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
        ],
      ),
    );
  }
}

class _CategoryBubble extends StatelessWidget {
  const _CategoryBubble({
    required this.category,
    required this.selected,
    required this.onPressed,
  });

  final CategoryChipModel category;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: category.title,
      selected: selected,
      child: InkWell(
        key: Key('pandamart-category-${category.id}'),
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: category.id == 'produce'
                    ? const Color(0xFFFDF2F8)
                    : (isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC)),
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? QBTokens.primary
                      : (isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0)),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: category.imageAsset != null
                  ? Image.asset(category.imageAsset!, fit: BoxFit.cover)
                  : Center(
                      child: Icon(
                        mapMaterialSymbol(category.iconName ?? 'more_horiz'),
                        color: QBTokens.primary,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 74,
              child: Text(
                category.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      key: const Key('pandamart-empty-state'),
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
          Icon(Symbols.inventory_2, color: Color(0xFF94A3B8)),
          SizedBox(height: 8),
          Text(
            'No grocery items available right now.',
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

String _formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';
