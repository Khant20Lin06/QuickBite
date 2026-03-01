import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/payment_home/application/saved_cards_controller.dart';
import 'package:quickbite/features/home/payment_home/presentation/pages/saved_cards_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('saved cards screen updates selected card', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const SavedCardsPage()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SavedCardsPage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(selectedSavedCardIdProvider), 'visa-4242');

    await tester.tap(find.byKey(const Key('saved-card-master-8888')));
    await tester.pump();

    expect(container.read(selectedSavedCardIdProvider), 'master-8888');
  });
}
