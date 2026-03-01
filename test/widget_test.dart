import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/app/app.dart';

void main() {
  testWidgets('app boots and shows splash branding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: QuickBiteApp()));
    await tester.pump();

    expect(find.text('QuickBite'), findsOneWidget);
  });
}
