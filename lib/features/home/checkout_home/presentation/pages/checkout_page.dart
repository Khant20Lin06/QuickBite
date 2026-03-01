import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/checkout_home/application/checkout_controller.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  late final TextEditingController _promoController;

  @override
  void initState() {
    super.initState();
    _promoController = TextEditingController();
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overviewState = ref.watch(checkoutOverviewProvider);
    final promoController = ref.read(appliedPromoCodeProvider.notifier);
    final appliedPromo = ref.watch(appliedPromoCodeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_promoController.text != appliedPromo) {
      _promoController.value = _promoController.value.copyWith(
        text: appliedPromo,
        selection: TextSelection.collapsed(offset: appliedPromo.length),
      );
    }

    return MobileFrameScaffold(
      frameColor: isDark ? QBTokens.backgroundDark : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            return Column(
              children: [
                _Header(
                  onBack: () {
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.homeFood);
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: _AddressCard(
                            address: overview.deliveryAddress,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: _EtaCard(eta: overview.deliveryEta),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text(
                            'Order Summary',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                for (
                                  var i = 0;
                                  i < overview.items.length;
                                  i++
                                ) ...[
                                  _SummaryLineItem(item: overview.items[i]),
                                  if (i != overview.items.length - 1)
                                    Divider(
                                      height: 1,
                                      color: isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFF1F5F9),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: _PromoCodeCard(
                            controller: _promoController,
                            onApply: () => promoController.apply(
                              _promoController.text.trim(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: _PaymentMethodCard(overview: overview),
                        ),
                        const SizedBox(height: 16),
                        _BreakdownCard(
                          overview: overview,
                          onPlaceOrder: () =>
                              context.go(AppRoutes.homeOrderConfirmation),
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
              Center(child: Text('Unable to load checkout: $error')),
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
              'Checkout',
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

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0x1AF1277B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Symbols.location_on, color: QBTokens.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  address,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.homeAddress),
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

class _EtaCard extends StatelessWidget {
  const _EtaCard({required this.eta});

  final String eta;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33F1277B)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x1AF1277B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Symbols.schedule, color: QBTokens.primary),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ESTIMATED DELIVERY',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                eta,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryLineItem extends StatelessWidget {
  const _SummaryLineItem({required this.item});

  final CheckoutLineItemModel item;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              mapMaterialSymbol(item.iconName),
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.priceLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _PromoCodeCard extends StatelessWidget {
  const _PromoCodeCard({required this.controller, required this.onApply});

  final TextEditingController controller;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4DF1277B),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          const Icon(Symbols.confirmation_number, color: QBTokens.primary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Apply promo code',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          TextButton(
            onPressed: onApply,
            child: const Text(
              'APPLY',
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

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.overview});

  final CheckoutOverview overview;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0x1A0070BA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Symbols.account_balance_wallet,
              color: Color(0xFF0070BA),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Method',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${overview.paymentMethodTitle} • ${overview.paymentMethodSubtitle}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.go(AppRoutes.homePayments),
            child: const Text(
              'Change',
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

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.overview, required this.onPlaceOrder});

  final CheckoutOverview overview;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        children: [
          _PriceLine(label: 'Subtotal', value: overview.subtotalLabel),
          const SizedBox(height: 8),
          _PriceLine(label: 'Delivery Fee', value: overview.deliveryFeeLabel),
          const SizedBox(height: 8),
          _PriceLine(label: 'Tax & Fees', value: overview.taxFeeLabel),
          const SizedBox(height: 10),
          Divider(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 6),
          _PriceLine(
            label: 'Total Amount',
            value: overview.totalLabel,
            emphasize: true,
          ),
          const SizedBox(height: 12),
          FilledButton(
            key: const Key('checkout-place-order-button'),
            onPressed: onPlaceOrder,
            style: FilledButton.styleFrom(
              backgroundColor: QBTokens.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Place Order',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 6),
                Icon(Symbols.arrow_forward),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'By placing the order, you agree to our Terms & Conditions',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: emphasize ? null : const Color(0xFF64748B),
              fontSize: emphasize ? 20 : 15,
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          maxLines: 1,
          style: TextStyle(
            color: emphasize ? QBTokens.primary : null,
            fontSize: emphasize ? 22 : 15,
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
