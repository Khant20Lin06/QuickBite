import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/vouchers_home/application/vouchers_home_controller.dart';
import 'package:quickbite/features/home/vouchers_home/presentation/pages/vouchers_home_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('voucher actions and empty-state tab behave correctly', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const VouchersHomePage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('voucher-action-free-delivery')));
    await tester.pump();
    expect(find.text('Applied'), findsOneWidget);

    await tester.tap(find.byKey(const Key('voucher-action-food-20')));
    await tester.pump();
    expect(find.text('Copied'), findsOneWidget);

    final context = tester.element(find.byType(VouchersHomePage));
    final container = ProviderScope.containerOf(context);
    container
        .read(selectedVoucherTabProvider.notifier)
        .select(VoucherTab.shops);
    await tester.pump();

    expect(find.byKey(const Key('voucher-empty-state')), findsOneWidget);
  });
}
