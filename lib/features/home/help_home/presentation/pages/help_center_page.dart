import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/help_home/application/help_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';
import 'package:quickbite/shared/ui/molecules/home_bottom_nav.dart';

class HelpCenterPage extends ConsumerStatefulWidget {
  const HelpCenterPage({super.key});

  @override
  ConsumerState<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends ConsumerState<HelpCenterPage> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overviewState = ref.watch(helpCenterOverviewProvider);
    final query = ref.watch(helpSearchQueryProvider);
    final queryController = ref.read(helpSearchQueryProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_queryController.text != query) {
      _queryController.value = _queryController.value.copyWith(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            final filteredTopics = query.trim().isEmpty
                ? overview.topics
                : overview.topics
                      .where(
                        (topic) => topic.title.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                      )
                      .toList();
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeProfile)),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              overview.headerTitle,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SearchBar(
                              controller: _queryController,
                              placeholder: overview.searchPlaceholder,
                              onChanged: queryController.setQuery,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'COMMON TOPICS',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 10),
                            for (var i = 0; i < filteredTopics.length; i++) ...[
                              _TopicTile(topic: filteredTopics[i]),
                              if (i != filteredTopics.length - 1)
                                const SizedBox(height: 10),
                            ],
                            const SizedBox(height: 18),
                            const Text(
                              'BROWSE BY CATEGORY',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                for (
                                  var i = 0;
                                  i < overview.categories.length;
                                  i++
                                ) ...[
                                  Expanded(
                                    child: _CategoryCard(
                                      category: overview.categories[i],
                                    ),
                                  ),
                                  if (i != overview.categories.length - 1)
                                    const SizedBox(width: 10),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 90,
                        child: FilledButton.icon(
                          key: const Key('help-chat-button'),
                          onPressed: () {},
                          style: FilledButton.styleFrom(
                            backgroundColor: QBTokens.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Symbols.chat_bubble, fill: 1),
                          label: Text(
                            overview.chatLabel,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
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
              Center(child: Text('Unable to load help center: $error')),
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
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xF2221017) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Symbols.arrow_back_ios, color: QBTokens.primary),
          ),
          const SizedBox(width: 8),
          const Text(
            'Help Center',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.placeholder,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Symbols.search, color: Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
                isDense: true,
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({required this.topic});

  final HelpTopicModel topic;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = _parseColor(topic.iconColorHex);
    return InkWell(
      key: Key('help-topic-${topic.id}'),
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(mapMaterialSymbol(topic.iconName), color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                topic.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const Icon(Symbols.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final HelpCategoryModel category;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
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
          Icon(mapMaterialSymbol(category.iconName), color: QBTokens.primary),
          const SizedBox(height: 8),
          Text(
            category.title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

Color _parseColor(String hex) {
  final normalized = hex.replaceAll('#', '');
  if (normalized.length != 6) {
    return const Color(0xFF64748B);
  }
  return Color(int.parse('FF$normalized', radix: 16));
}
