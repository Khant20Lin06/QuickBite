import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/settings_home/application/app_settings_controller.dart';
import 'package:quickbite/features/home/settings_home/presentation/pages/app_settings_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('settings page switches app language state', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const AppSettingsPage()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(AppSettingsPage));
    final container = ProviderScope.containerOf(context);
    expect(container.read(selectedAppLanguageProvider), 'EN');

    await tester.tap(find.byKey(const Key('settings-language-MM')));
    await tester.pump();

    expect(container.read(selectedAppLanguageProvider), 'MM');
  });
}
