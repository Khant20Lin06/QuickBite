import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/orders_home/application/orders_home_controller.dart';
import 'package:quickbite/features/home/orders_home/presentation/pages/orders_home_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('orders page switches active and past tabs', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const OrdersHomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Track Order'), findsOneWidget);

    final context = tester.element(find.byType(OrdersHomePage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(selectedOrdersTabProvider), OrdersTab.active);

    await tester.tap(find.byKey(const Key('orders-tab-past')));
    await tester.pumpAndSettle();

    expect(container.read(selectedOrdersTabProvider), OrdersTab.past);
    expect(find.text('Track Order'), findsNothing);
    expect(find.text('PAST ORDERS'), findsOneWidget);
  });
}
