import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/help_home/presentation/pages/help_center_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('help screen filters topics by query', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const HelpCenterPage()));
    await tester.pumpAndSettle();

    expect(find.text('Where is my order?'), findsOneWidget);
    expect(find.text('Refunds & Returns'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'refund');
    await tester.pumpAndSettle();

    expect(find.text('Refunds & Returns'), findsOneWidget);
    expect(find.text('Where is my order?'), findsNothing);
  });
}
