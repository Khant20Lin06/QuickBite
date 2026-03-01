import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final foodHomeFeedProvider = FutureProvider<HomeFeed>((ref) async {
  return ref.read(homeRepositoryProvider).getFoodHome();
});

final selectedHomeTileProvider =
    NotifierProvider<SelectedHomeTileController, String>(
      SelectedHomeTileController.new,
    );

class SelectedHomeTileController extends Notifier<String> {
  @override
  String build() => 'food_delivery';

  void select(String tileId) => state = tileId;
}
