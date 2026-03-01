import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/search_home/application/search_home_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/home_bottom_nav.dart';

class SearchResultsPage extends ConsumerStatefulWidget {
  const SearchResultsPage({super.key});

  @override
  ConsumerState<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(searchUiProvider).query;
    _queryController = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultState = ref.watch(searchResultsProvider);
    final uiState = ref.watch(searchUiProvider);
    final uiController = ref.read(searchUiProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_queryController.text != uiState.query) {
      _queryController.value = _queryController.value.copyWith(
        text: uiState.query,
        selection: TextSelection.collapsed(offset: uiState.query.length),
      );
    }

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: resultState.when(
          data: (results) {
            final effectiveQuery = uiState.query.isEmpty
                ? results.query
                : uiState.query;
            return Column(
              children: [
                _SearchHeader(
                  controller: _queryController,
                  filters: results.filters,
                  selectedFilterId: uiState.selectedFilterId,
                  onQueryChanged: uiController.setQuery,
                  onClear: () {
                    _queryController.clear();
                    uiController.clearQuery();
                  },
                  onFilterSelected: uiController.selectFilter,
                ),
                Expanded(
                  child: uiState.showEmpty
                      ? _SearchEmptyState(query: effectiveQuery)
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                results.resultCountLabel,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              for (
                                var i = 0;
                                i < results.results.length;
                                i++
                              ) ...[
                                _SearchResultCard(result: results.results[i]),
                                if (i != results.results.length - 1)
                                  const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),
                ),
                HomeBottomNav(
                  current: HomeBottomNavItem.home,
                  onItemTap: (item) {
                    if (item == HomeBottomNavItem.orders) {
                      context.go(AppRoutes.homeOrders);
                    } else if (item == HomeBottomNavItem.vouchers) {
                      context.go(AppRoutes.homeVouchers);
                    } else if (item == HomeBottomNavItem.profile) {
                      context.go(AppRoutes.homeProfile);
                    } else if (item == HomeBottomNavItem.home) {
                      context.go(AppRoutes.homeFood);
                    }
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load results: $error')),
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.filters,
    required this.selectedFilterId,
    required this.onQueryChanged,
    required this.onClear,
    required this.onFilterSelected,
  });

  final TextEditingController controller;
  final List<SearchFilterModel> filters;
  final String selectedFilterId;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF2221017) : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go(AppRoutes.homeFood),
                  icon: const Icon(Symbols.arrow_back_ios_new),
                ),
                Expanded(
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
                        const SizedBox(width: 10),
                        const Icon(
                          Symbols.search,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: controller,
                            onChanged: onQueryChanged,
                            decoration: const InputDecoration(
                              hintText: 'Search for food or shops',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          key: const Key('search-clear-button'),
                          onPressed: onClear,
                          icon: const Icon(Symbols.close, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(onPressed: () {}, icon: const Icon(Symbols.tune)),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final active = filter.id == selectedFilterId;
                return _FilterChip(
                  filter: filter,
                  active: active,
                  onTap: () => onFilterSelected(filter.id),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.active,
    required this.onTap,
  });

  final SearchFilterModel filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ActionChip(
      key: Key('search-filter-${filter.id}'),
      onPressed: onTap,
      avatar: filter.iconName == null
          ? null
          : Icon(
              mapMaterialSymbol(filter.iconName!),
              size: 14,
              color: active ? Colors.white : const Color(0xFF64748B),
            ),
      side: active
          ? BorderSide.none
          : BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
      backgroundColor: active
          ? QBTokens.primary
          : (isDark ? const Color(0xFF1E293B) : Colors.white),
      labelStyle: TextStyle(
        color: active ? Colors.white : const Color(0xFF475569),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(filter.label),
          if (filter.hasTrailingExpand) ...[
            const SizedBox(width: 2),
            Icon(
              Symbols.expand_more,
              size: 14,
              color: active ? Colors.white : const Color(0xFF64748B),
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.result});

  final SearchResultModel result;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0x800F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(result.imageAsset, fit: BoxFit.cover),
                  ),
                ),
                if (result.badges.isNotEmpty)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < result.badges.length; i++) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: i == 0
                                  ? QBTokens.primary
                                  : const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              result.badges[i],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (i != result.badges.length - 1)
                            const SizedBox(height: 6),
                        ],
                      ],
                    ),
                  ),
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      result.deliveryEta,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        result.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                        ),
                      ),
                      if (result.highlightLabel != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              mapMaterialSymbol(
                                result.highlightIconName ?? 'sell',
                              ),
                              color: QBTokens.primary,
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                result.highlightLabel!,
                                style: const TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Symbols.star,
                        color: Color(0xFFEAB308),
                        size: 16,
                        fill: 1,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        result.rating,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        result.reviewCountLabel,
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
          ),
        ],
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  const _SearchEmptyState({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Symbols.search_off,
                color: Color(0xFF94A3B8),
                size: 50,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No results found',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'We could not find any results for "$query". Try another search.',
              key: const Key('search-empty-state'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go(AppRoutes.homeFood),
              style: FilledButton.styleFrom(
                backgroundColor: QBTokens.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
              ),
              child: const Text(
                'Back Home',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
