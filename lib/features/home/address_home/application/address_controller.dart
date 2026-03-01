import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final addressDraftProvider = FutureProvider<AddressDraft>((ref) async {
  return ref.read(homeRepositoryProvider).getAddressDraft();
});

class AddressFormState {
  const AddressFormState({
    this.selectedLabel = AddressLabelType.home,
    this.streetName = '',
    this.buildingUnit = '',
    this.noteForRider = '',
    this.initialized = false,
  });

  final AddressLabelType selectedLabel;
  final String streetName;
  final String buildingUnit;
  final String noteForRider;
  final bool initialized;

  AddressFormState copyWith({
    AddressLabelType? selectedLabel,
    String? streetName,
    String? buildingUnit,
    String? noteForRider,
    bool? initialized,
  }) {
    return AddressFormState(
      selectedLabel: selectedLabel ?? this.selectedLabel,
      streetName: streetName ?? this.streetName,
      buildingUnit: buildingUnit ?? this.buildingUnit,
      noteForRider: noteForRider ?? this.noteForRider,
      initialized: initialized ?? this.initialized,
    );
  }
}

final addressFormProvider =
    NotifierProvider<AddressFormController, AddressFormState>(
      AddressFormController.new,
    );

class AddressFormController extends Notifier<AddressFormState> {
  @override
  AddressFormState build() => const AddressFormState();

  void seedFromDraft(AddressDraft draft) {
    if (state.initialized) {
      return;
    }
    state = state.copyWith(
      selectedLabel: draft.selectedLabel,
      streetName: draft.streetName,
      buildingUnit: draft.buildingUnit,
      noteForRider: draft.noteForRider,
      initialized: true,
    );
  }

  void setLabel(AddressLabelType value) {
    state = state.copyWith(selectedLabel: value);
  }

  void setStreetName(String value) {
    state = state.copyWith(streetName: value);
  }

  void setBuildingUnit(String value) {
    state = state.copyWith(buildingUnit: value);
  }

  void setNoteForRider(String value) {
    state = state.copyWith(noteForRider: value);
  }
}
