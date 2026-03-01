import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/order_confirmation_home/presentation/pages/order_confirmation_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('order confirmation renders success state', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const OrderConfirmationPage()));
    await tester.pumpAndSettle();

    expect(find.text('Order Placed Successfully!'), findsOneWidget);
    expect(
      find.byKey(const Key('order-confirmation-track-button')),
      findsOneWidget,
    );
  });
}
