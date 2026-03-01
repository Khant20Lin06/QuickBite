import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/features/home/order_confirmation_home/application/order_confirmation_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class OrderConfirmationPage extends ConsumerWidget {
  const OrderConfirmationPage({super.key, this.useRemoteImages = true});

  final bool useRemoteImages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(orderConfirmationOverviewProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeCheckout)),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 260,
                                        height: 260,
                                        decoration: BoxDecoration(
                                          color: const Color(0x1AF1277B),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0x33F1277B),
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 190,
                                        height: 190,
                                        child: useRemoteImages
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    overview.illustrationUrl,
                                                fit: BoxFit.contain,
                                                placeholder: (context, url) =>
                                                    const ColoredBox(
                                                      color: Color(0xFFFCE7F3),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const ColoredBox(
                                                          color: Color(
                                                            0xFFFCE7F3,
                                                          ),
                                                        ),
                                              )
                                            : const ColoredBox(
                                                color: Color(0xFFFCE7F3),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    overview.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      height: 1.12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    overview.subtitle,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 15,
                                      height: 1.45,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _InfoCard(
                                          label: 'ORDER ID',
                                          value: overview.orderIdLabel,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _InfoCard(
                                          label: 'EST. ARRIVAL',
                                          value: overview.arrivalLabel,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  FilledButton.icon(
                                    key: const Key(
                                      'order-confirmation-track-button',
                                    ),
                                    onPressed: () =>
                                        context.go(AppRoutes.homeOrders),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: QBTokens.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(54),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(Symbols.local_shipping),
                                    label: const Text(
                                      'Track My Order',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  FilledButton(
                                    key: const Key(
                                      'order-confirmation-home-button',
                                    ),
                                    onPressed: () =>
                                        context.go(AppRoutes.homeFood),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF1F5F9),
                                      foregroundColor: isDark
                                          ? const Color(0xFFE2E8F0)
                                          : const Color(0xFF475569),
                                      minimumSize: const Size.fromHeight(54),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Back to Home',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: 132,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFCBD5E1),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ],
                          ),
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
              Center(child: Text('Unable to load confirmation: $error')),
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
          IconButton(onPressed: onBack, icon: const Icon(Symbols.arrow_back)),
          const Expanded(
            child: Text(
              'Order Status',
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x1AF1277B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33F1277B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: QBTokens.primary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
