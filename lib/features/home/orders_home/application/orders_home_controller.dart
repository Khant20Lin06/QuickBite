import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final ordersOverviewProvider = FutureProvider<OrdersOverview>((ref) async {
  return ref.read(homeRepositoryProvider).getOrders();
});

final selectedOrdersTabProvider =
    NotifierProvider<SelectedOrdersTabController, OrdersTab>(
      SelectedOrdersTabController.new,
    );

class SelectedOrdersTabController extends Notifier<OrdersTab> {
  @override
  OrdersTab build() => OrdersTab.active;

  void select(OrdersTab tab) => state = tab;
}
