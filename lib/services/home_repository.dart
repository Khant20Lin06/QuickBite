import 'package:quickbite/features/home/domain/home_models.dart';

abstract class HomeRepository {
  Future<HomeFeed> getFoodHome();

  Future<GroceryCatalog> getPandamart();

  Future<VoucherCollection> getVouchers();

  Future<OrdersOverview> getOrders();

  Future<ProfileOverview> getProfile();

  Future<SearchResultCollection> getSearchResults();

  Future<ReviewOverview> getReviewOverview();

  Future<AddressDraft> getAddressDraft();

  Future<PaymentMethodsOverview> getPaymentMethods();

  Future<HelpCenterOverview> getHelpCenter();

  Future<SavedRestaurantsOverview> getSavedRestaurants();

  Future<RestaurantDetailsOverview> getRestaurantDetails(String restaurantId);

  Future<AppSettingsOverview> getAppSettings();

  Future<SavedCardsOverview> getSavedCards();

  Future<InviteFriendsOverview> getInviteFriends();

  Future<PrivacyPolicyOverview> getPrivacyPolicy();

  Future<CheckoutOverview> getCheckoutOverview();

  Future<OrderConfirmationOverview> getOrderConfirmation();
}
