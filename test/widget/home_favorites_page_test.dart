import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/favorites_home/presentation/pages/saved_restaurants_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('favorites page renders restaurant cards', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const SavedRestaurantsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Favorites'), findsWidgets);
    expect(find.text('The Burger Joint'), findsOneWidget);
    expect(
      find.byKey(const Key('favorite-order-the-burger-joint')),
      findsOneWidget,
    );
  });
}
