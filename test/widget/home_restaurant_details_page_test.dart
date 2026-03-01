import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/restaurant_details_home/application/restaurant_details_controller.dart';
import 'package:quickbite/features/home/restaurant_details_home/presentation/pages/restaurant_details_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('restaurant details add button increments cart count', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const RestaurantDetailsPage()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(RestaurantDetailsPage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(restaurantCartCountProvider), 2);

    await tester.tap(
      find.byKey(const Key('restaurant-popular-add-smokehouse')),
    );
    await tester.pump();

    expect(container.read(restaurantCartCountProvider), 3);
  });
}
