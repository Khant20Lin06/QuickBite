import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/payment_home/application/payment_controller.dart';
import 'package:quickbite/features/home/payment_home/presentation/pages/payment_methods_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('payment screen changes selected method', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const PaymentMethodsPage()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PaymentMethodsPage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(selectedPaymentMethodIdProvider), 'visa-4242');

    await tester.tap(find.byKey(const Key('payment-method-mc-8890')));
    await tester.pump();

    expect(container.read(selectedPaymentMethodIdProvider), 'mc-8890');
  });
}
