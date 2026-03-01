import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/invite_home/presentation/pages/invite_friends_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('invite page shows referral code section', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const InviteFriendsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Invite Friends'), findsWidgets);
    expect(find.text('FOODIE500'), findsOneWidget);
    expect(find.byKey(const Key('invite-copy-code-button')), findsOneWidget);
  });
}
