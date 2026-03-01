import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final savedRestaurantsProvider = FutureProvider<SavedRestaurantsOverview>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getSavedRestaurants();
});

final selectedSavedRestaurantTabProvider =
    NotifierProvider<SelectedSavedRestaurantTabController, String>(
      SelectedSavedRestaurantTabController.new,
    );

class SelectedSavedRestaurantTabController extends Notifier<String> {
  @override
  String build() => 'Restaurants';

  void select(String tab) => state = tab;
}
