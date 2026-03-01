import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final checkoutOverviewProvider = FutureProvider<CheckoutOverview>((ref) async {
  return ref.read(homeRepositoryProvider).getCheckoutOverview();
});

final appliedPromoCodeProvider =
    NotifierProvider<AppliedPromoCodeController, String>(
      AppliedPromoCodeController.new,
    );

class AppliedPromoCodeController extends Notifier<String> {
  @override
  String build() => '';

  void apply(String value) => state = value;
}
