import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/food_home/application/food_home_controller.dart';
import 'package:quickbite/features/home/food_home/presentation/pages/food_home_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('food home renders and category interaction updates selection', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const FoodHomePage()));
    await tester.pumpAndSettle();

    expect(find.text('Available Vouchers'), findsOneWidget);
    expect(find.byKey(const Key('home-tile-pickup')), findsOneWidget);
    expect(find.byKey(const Key('home-basket-count')), findsOneWidget);
    expect(find.text('2'), findsWidgets);

    final context = tester.element(find.byType(FoodHomePage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(selectedHomeTileProvider), 'food_delivery');

    await tester.tap(find.byKey(const Key('home-tile-pickup')));
    await tester.pump();

    expect(container.read(selectedHomeTileProvider), 'pickup');
  });
}
