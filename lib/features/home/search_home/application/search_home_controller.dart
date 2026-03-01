import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final searchResultsProvider = FutureProvider<SearchResultCollection>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getSearchResults();
});

class SearchUiState {
  const SearchUiState({
    this.query = 'Pizza',
    this.selectedFilterId = 'cuisine',
    this.showEmpty = false,
  });

  final String query;
  final String selectedFilterId;
  final bool showEmpty;

  SearchUiState copyWith({
    String? query,
    String? selectedFilterId,
    bool? showEmpty,
  }) {
    return SearchUiState(
      query: query ?? this.query,
      selectedFilterId: selectedFilterId ?? this.selectedFilterId,
      showEmpty: showEmpty ?? this.showEmpty,
    );
  }
}

final searchUiProvider = NotifierProvider<SearchUiController, SearchUiState>(
  SearchUiController.new,
);

class SearchUiController extends Notifier<SearchUiState> {
  @override
  SearchUiState build() => const SearchUiState();

  void setQuery(String value) {
    final trimmed = value.trim();
    state = state.copyWith(
      query: value,
      showEmpty: trimmed.isEmpty || trimmed.toLowerCase() == 'xyz',
    );
  }

  void clearQuery() {
    state = state.copyWith(query: '', showEmpty: true);
  }

  void selectFilter(String filterId) {
    state = state.copyWith(selectedFilterId: filterId);
  }
}
