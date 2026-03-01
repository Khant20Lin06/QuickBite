import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final paymentMethodsProvider = FutureProvider<PaymentMethodsOverview>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getPaymentMethods();
});

final selectedPaymentMethodIdProvider =
    NotifierProvider<SelectedPaymentMethodController, String?>(
      SelectedPaymentMethodController.new,
    );

class SelectedPaymentMethodController extends Notifier<String?> {
  @override
  String? build() => 'visa-4242';

  void select(String id) => state = id;
}
