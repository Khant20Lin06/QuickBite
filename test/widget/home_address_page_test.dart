import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/home/address_home/application/address_controller.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/features/home/address_home/presentation/pages/add_address_page.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('address screen toggles label and keeps fields', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(testWrapper(const AddAddressPage()));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(AddAddressPage));
    final container = ProviderScope.containerOf(context);
    expect(
      container.read(addressFormProvider).selectedLabel,
      AddressLabelType.home,
    );

    await tester.tap(find.byKey(const Key('address-label-Work')));
    await tester.pump();
    expect(
      container.read(addressFormProvider).selectedLabel,
      AddressLabelType.work,
    );

    await tester.enterText(
      find.byType(TextFormField).at(1),
      'ION Orchard, #04-12',
    );
    await tester.pump();
    expect(
      container.read(addressFormProvider).buildingUnit,
      'ION Orchard, #04-12',
    );
  });
}
