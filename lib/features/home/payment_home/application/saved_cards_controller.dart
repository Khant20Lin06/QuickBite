import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final savedCardsOverviewProvider = FutureProvider<SavedCardsOverview>((ref) {
  return ref.read(homeRepositoryProvider).getSavedCards();
});

final selectedSavedCardIdProvider =
    NotifierProvider<SelectedSavedCardIdController, String?>(
      SelectedSavedCardIdController.new,
    );

class SelectedSavedCardIdController extends Notifier<String?> {
  @override
  String? build() => 'visa-4242';

  void select(String cardId) => state = cardId;
}
