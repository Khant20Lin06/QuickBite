import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final pandamartCatalogProvider = FutureProvider<GroceryCatalog>((ref) async {
  return ref.read(homeRepositoryProvider).getPandamart();
});

final selectedPandamartCategoryProvider =
    NotifierProvider<SelectedPandamartCategoryController, String?>(
      SelectedPandamartCategoryController.new,
    );

class SelectedPandamartCategoryController extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String categoryId) => state = categoryId;
}

class PandamartCartState {
  const PandamartCartState({this.quantities = const {}});

  final Map<String, int> quantities;

  int quantityFor(String itemId) => quantities[itemId] ?? 0;

  int get totalItems => quantities.values.fold<int>(0, (sum, qty) => sum + qty);

  PandamartCartState copyWith({Map<String, int>? quantities}) {
    return PandamartCartState(quantities: quantities ?? this.quantities);
  }
}

final pandamartCartProvider =
    NotifierProvider<PandamartCartController, PandamartCartState>(
      PandamartCartController.new,
    );

class PandamartCartController extends Notifier<PandamartCartState> {
  @override
  PandamartCartState build() => const PandamartCartState();

  void addItem(String itemId) {
    final next = <String, int>{...state.quantities};
    next[itemId] = (next[itemId] ?? 0) + 1;
    state = state.copyWith(quantities: next);
  }

  void removeItem(String itemId) {
    if (!state.quantities.containsKey(itemId)) {
      return;
    }
    final next = <String, int>{...state.quantities};
    final updated = (next[itemId] ?? 0) - 1;
    if (updated <= 0) {
      next.remove(itemId);
    } else {
      next[itemId] = updated;
    }
    state = state.copyWith(quantities: next);
  }

  double totalPrice(List<GroceryItemModel> items) {
    var total = 0.0;
    for (final item in items) {
      total += item.price * quantityFor(item.id);
    }
    return total;
  }

  int quantityFor(String itemId) => state.quantityFor(itemId);
}
