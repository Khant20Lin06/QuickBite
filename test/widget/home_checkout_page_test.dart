import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/checkout_home/application/checkout_controller.dart';
import 'package:quickbite/features/home/checkout_home/presentation/pages/checkout_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('checkout applies promo code state', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const CheckoutPage()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).last, 'QBDEAL');
    await tester.tap(find.text('APPLY'));
    await tester.pump();

    final context = tester.element(find.byType(CheckoutPage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(appliedPromoCodeProvider), 'QBDEAL');
  });
}
