import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/search_home/presentation/pages/search_results_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('search page clears query and shows empty state', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const SearchResultsPage()));
    await tester.pumpAndSettle();

    expect(find.textContaining('results for "Pizza"'), findsOneWidget);

    await tester.tap(find.byKey(const Key('search-clear-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('search-empty-state')), findsOneWidget);
    expect(find.text('No results found'), findsOneWidget);
  });
}
