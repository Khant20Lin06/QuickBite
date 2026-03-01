import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/routes.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/payment_home/application/payment_controller.dart';
import 'package:quickbite/shared/ui/layout/mobile_frame_scaffold.dart';

class PaymentMethodsPage extends ConsumerWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewState = ref.watch(paymentMethodsProvider);
    final selectedMethodId = ref.watch(selectedPaymentMethodIdProvider);
    final selectedController = ref.read(
      selectedPaymentMethodIdProvider.notifier,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MobileFrameScaffold(
      frameColor: isDark ? const Color(0xFF1A1A1A) : QBTokens.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: overviewState.when(
          data: (overview) {
            return Column(
              children: [
                _Header(onBack: () => context.go(AppRoutes.homeProfile)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel('CREDIT / DEBIT CARDS'),
                        const SizedBox(height: 10),
                        for (var i = 0; i < overview.cards.length; i++) ...[
                          _MethodTile(
                            method: overview.cards[i],
                            selected: selectedMethodId == overview.cards[i].id,
                            onTap: () =>
                                selectedController.select(overview.cards[i].id),
                          ),
                          if (i != overview.cards.length - 1)
                            const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 20),
                        const _SectionLabel('DIGITAL WALLETS'),
                        const SizedBox(height: 10),
                        for (var i = 0; i < overview.wallets.length; i++) ...[
                          _MethodTile(
                            method: overview.wallets[i],
                            selected:
                                selectedMethodId == overview.wallets[i].id,
                            onTap: () => selectedController.select(
                              overview.wallets[i].id,
                            ),
                          ),
                          if (i != overview.wallets.length - 1)
                            const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 20),
                        const _SectionLabel('OTHER METHODS'),
                        const SizedBox(height: 10),
                        for (
                          var i = 0;
                          i < overview.otherMethods.length;
                          i++
                        ) ...[
                          _MethodTile(
                            method: overview.otherMethods[i],
                            selected:
                                selectedMethodId == overview.otherMethods[i].id,
                            onTap: () => selectedController.select(
                              overview.otherMethods[i].id,
                            ),
                          ),
                          if (i != overview.otherMethods.length - 1)
                            const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 26),
                        const _SecurityFooter(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xCC0F172A)
                        : const Color(0xCCFFFFFF),
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFF1F5F9),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('payment-add-method-button'),
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: QBTokens.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Symbols.add_circle),
                      label: const Text(
                        'Add New Payment Method',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Unable to load payment methods: $error')),
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
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0F172A)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF334155)
                : const Color(0xFFF1F5F9),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Symbols.arrow_back_ios),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Payment Methods',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethodModel method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      key: Key('payment-method-${method.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                mapMaterialSymbol(method.iconName),
                color: method.iconName == 'ios'
                    ? (isDark ? Colors.white : Colors.black)
                    : const Color(0xFF475569),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    method.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (method.badgeLabel != null) ...[
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0x1AF1277B),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  method.badgeLabel!,
                  style: const TextStyle(
                    color: QBTokens.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? QBTokens.primary : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: selected
                  ? Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: QBTokens.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityFooter extends StatelessWidget {
  const _SecurityFooter();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.verified_user, color: Color(0xFF94A3B8), size: 20),
              SizedBox(width: 10),
              Icon(Symbols.security, color: Color(0xFF94A3B8), size: 20),
              SizedBox(width: 10),
              Icon(Symbols.lock, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'SECURE 256-BIT SSL ENCRYPTED PAYMENT',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
