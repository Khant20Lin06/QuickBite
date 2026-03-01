import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final vouchersCollectionProvider = FutureProvider<VoucherCollection>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getVouchers();
});

final selectedVoucherTabProvider =
    NotifierProvider<SelectedVoucherTabController, VoucherTab>(
      SelectedVoucherTabController.new,
    );

class SelectedVoucherTabController extends Notifier<VoucherTab> {
  @override
  VoucherTab build() => VoucherTab.foodDelivery;

  void select(VoucherTab tab) => state = tab;
}

class VoucherInteractionState {
  const VoucherInteractionState({
    this.appliedVoucherIds = const {},
    this.copiedVoucherIds = const {},
  });

  final Set<String> appliedVoucherIds;
  final Set<String> copiedVoucherIds;

  VoucherInteractionState copyWith({
    Set<String>? appliedVoucherIds,
    Set<String>? copiedVoucherIds,
  }) {
    return VoucherInteractionState(
      appliedVoucherIds: appliedVoucherIds ?? this.appliedVoucherIds,
      copiedVoucherIds: copiedVoucherIds ?? this.copiedVoucherIds,
    );
  }
}

final voucherInteractionProvider =
    NotifierProvider<VoucherInteractionController, VoucherInteractionState>(
      VoucherInteractionController.new,
    );

class VoucherInteractionController extends Notifier<VoucherInteractionState> {
  @override
  VoucherInteractionState build() => const VoucherInteractionState();

  void applyVoucher(String voucherId) {
    final next = <String>{...state.appliedVoucherIds, voucherId};
    state = state.copyWith(appliedVoucherIds: next);
  }

  void markCopied(String voucherId) {
    final next = <String>{...state.copiedVoucherIds, voucherId};
    state = state.copyWith(copiedVoucherIds: next);
  }
}
