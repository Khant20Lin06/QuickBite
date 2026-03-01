import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/pandamart_home/application/pandamart_home_controller.dart';
import 'package:quickbite/features/home/pandamart_home/presentation/pages/pandamart_home_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('pandamart add-to-cart updates item count and sticky cart', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const PandamartHomePage()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(PandamartHomePage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(pandamartCartProvider).totalItems, 0);

    await tester.tap(find.byKey(const Key('add-product-banana')));
    await tester.pump();

    expect(container.read(pandamartCartProvider).totalItems, 1);
    expect(find.byKey(const Key('sticky-cart-button')), findsOneWidget);
    expect(find.text('\$2.40'), findsWidgets);
  });
}
