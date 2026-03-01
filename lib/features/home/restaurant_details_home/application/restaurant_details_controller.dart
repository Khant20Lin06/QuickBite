import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

const defaultRestaurantId = 'the-burger-joint';

final restaurantDetailsProvider = FutureProvider<RestaurantDetailsOverview>((
  ref,
) async {
  return ref
      .read(homeRepositoryProvider)
      .getRestaurantDetails(defaultRestaurantId);
});

final selectedRestaurantDetailsTabProvider =
    NotifierProvider<
      SelectedRestaurantDetailsTabController,
      RestaurantDetailsTab
    >(SelectedRestaurantDetailsTabController.new);

class SelectedRestaurantDetailsTabController
    extends Notifier<RestaurantDetailsTab> {
  @override
  RestaurantDetailsTab build() => RestaurantDetailsTab.menu;

  void select(RestaurantDetailsTab tab) => state = tab;
}

final restaurantCartCountProvider =
    NotifierProvider<RestaurantCartCountController, int>(
      RestaurantCartCountController.new,
    );

class RestaurantCartCountController extends Notifier<int> {
  @override
  int build() => 2;

  void addItem() => state = state + 1;
}
