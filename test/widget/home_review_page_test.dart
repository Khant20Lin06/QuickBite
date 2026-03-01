import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/features/home/review_home/application/review_controller.dart';
import 'package:quickbite/features/home/review_home/presentation/pages/review_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('review screen updates rating and removes photo', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const ReviewPage()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(ReviewPage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(reviewFormProvider).foodRating, 4);

    await tester.tap(
      find
          .descendant(
            of: find.byKey(const Key('review-food-stars')),
            matching: find.byIcon(Symbols.star),
          )
          .first,
    );
    await tester.pump();
    expect(container.read(reviewFormProvider).foodRating, 1);

    await tester.ensureVisible(
      find.byKey(const Key('review-remove-photo-button')),
    );
    await tester.tap(find.byKey(const Key('review-remove-photo-button')));
    await tester.pump();
    expect(container.read(reviewFormProvider).photos, isEmpty);
  });
}
