enum VoucherTab { foodDelivery, pandamart, shops, subscriptions }

enum VoucherActionType { apply, copyCode, claimed }

class CategoryChipModel {
  const CategoryChipModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageAsset,
    this.iconName,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? imageAsset;
  final String? iconName;
}

class PromoBannerModel {
  const PromoBannerModel({
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.imageAsset,
  });

  final String title;
  final String subtitle;
  final String ctaLabel;
  final String imageAsset;
}

class VoucherSummaryModel {
  const VoucherSummaryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.terms,
    required this.iconName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String terms;
  final String iconName;
}

class RestaurantCardModel {
  const RestaurantCardModel({
    required this.id,
    required this.name,
    required this.cuisineLine,
    required this.rating,
    required this.reviewCountLabel,
    required this.deliveryEta,
    required this.imageAsset,
    this.promoTag,
  });

  final String id;
  final String name;
  final String cuisineLine;
  final double rating;
  final String reviewCountLabel;
  final String deliveryEta;
  final String imageAsset;
  final String? promoTag;
}

class HomeFeed {
  const HomeFeed({
    required this.address,
    required this.searchPlaceholder,
    required this.promoBanner,
    required this.mainTiles,
    required this.voucherSummaries,
    required this.restaurants,
  });

  final String address;
  final String searchPlaceholder;
  final PromoBannerModel promoBanner;
  final List<CategoryChipModel> mainTiles;
  final List<VoucherSummaryModel> voucherSummaries;
  final List<RestaurantCardModel> restaurants;
}

class GroceryItemModel {
  const GroceryItemModel({
    required this.id,
    required this.name,
    required this.unitLabel,
    required this.price,
    required this.imageAsset,
    this.originalPrice,
    this.badgeText,
  });

  final String id;
  final String name;
  final String unitLabel;
  final double price;
  final String imageAsset;
  final double? originalPrice;
  final String? badgeText;
}

class GroceryCatalog {
  const GroceryCatalog({
    required this.title,
    required this.deliveryEta,
    required this.searchPlaceholder,
    required this.categories,
    required this.items,
  });

  final String title;
  final String deliveryEta;
  final String searchPlaceholder;
  final List<CategoryChipModel> categories;
  final List<GroceryItemModel> items;
}

class CartSummaryModel {
  const CartSummaryModel({required this.itemCount, required this.totalPrice});

  final int itemCount;
  final double totalPrice;
}

class VoucherModel {
  const VoucherModel({
    required this.id,
    required this.tab,
    required this.title,
    required this.description,
    required this.expiryLabel,
    required this.minSpendLabel,
    required this.iconName,
    required this.actionType,
    this.badgeLabel,
    this.disabled = false,
  });

  final String id;
  final VoucherTab tab;
  final String title;
  final String description;
  final String expiryLabel;
  final String minSpendLabel;
  final String iconName;
  final VoucherActionType actionType;
  final String? badgeLabel;
  final bool disabled;
}

class InviteRewardModel {
  const InviteRewardModel({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.iconName,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final String iconName;
}

class VoucherCollection {
  const VoucherCollection({
    required this.title,
    required this.tabs,
    required this.vouchers,
    required this.inviteReward,
  });

  final String title;
  final List<VoucherTab> tabs;
  final List<VoucherModel> vouchers;
  final InviteRewardModel inviteReward;
}

enum OrdersTab { active, past }

class ActiveOrderModel {
  const ActiveOrderModel({
    required this.id,
    required this.restaurantName,
    required this.orderLabel,
    required this.arrivalLabel,
    required this.progressTitle,
    required this.progressActionLabel,
    required this.progressValue,
    required this.imageAsset,
  });

  final String id;
  final String restaurantName;
  final String orderLabel;
  final String arrivalLabel;
  final String progressTitle;
  final String progressActionLabel;
  final double progressValue;
  final String imageAsset;
}

class PastOrderModel {
  const PastOrderModel({
    required this.id,
    required this.name,
    required this.totalLabel,
    required this.dateLabel,
    required this.itemsLabel,
    required this.imageAsset,
    this.iconName,
  });

  final String id;
  final String name;
  final String totalLabel;
  final String dateLabel;
  final String itemsLabel;
  final String imageAsset;
  final String? iconName;
}

class OrdersOverview {
  const OrdersOverview({required this.activeOrder, required this.pastOrders});

  final ActiveOrderModel activeOrder;
  final List<PastOrderModel> pastOrders;
}

class ProfileMenuItemModel {
  const ProfileMenuItemModel({
    required this.id,
    required this.title,
    required this.iconName,
    this.badgeLabel,
  });

  final String id;
  final String title;
  final String iconName;
  final String? badgeLabel;
}

class ProfileOverview {
  const ProfileOverview({
    required this.name,
    required this.memberSince,
    required this.avatarAsset,
    required this.primaryItems,
    required this.secondaryItems,
    required this.versionLabel,
  });

  final String name;
  final String memberSince;
  final String avatarAsset;
  final List<ProfileMenuItemModel> primaryItems;
  final List<ProfileMenuItemModel> secondaryItems;
  final String versionLabel;
}

class SearchFilterModel {
  const SearchFilterModel({
    required this.id,
    required this.label,
    this.iconName,
    this.filled = false,
    this.hasTrailingExpand = false,
  });

  final String id;
  final String label;
  final String? iconName;
  final bool filled;
  final bool hasTrailingExpand;
}

class SearchResultModel {
  const SearchResultModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.reviewCountLabel,
    required this.deliveryEta,
    required this.imageAsset,
    this.badges = const [],
    this.highlightLabel,
    this.highlightIconName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String rating;
  final String reviewCountLabel;
  final String deliveryEta;
  final String imageAsset;
  final List<String> badges;
  final String? highlightLabel;
  final String? highlightIconName;
}

class SearchResultCollection {
  const SearchResultCollection({
    required this.query,
    required this.resultCountLabel,
    required this.filters,
    required this.results,
  });

  final String query;
  final String resultCountLabel;
  final List<SearchFilterModel> filters;
  final List<SearchResultModel> results;
}

class ReviewOverview {
  const ReviewOverview({
    required this.restaurantName,
    required this.orderLabel,
    required this.heroImageAsset,
    required this.attachedImageAssets,
  });

  final String restaurantName;
  final String orderLabel;
  final String heroImageAsset;
  final List<String> attachedImageAssets;
}

enum AddressLabelType { home, work, other }

class AddressDraft {
  const AddressDraft({
    required this.streetName,
    required this.buildingUnit,
    required this.noteForRider,
    required this.mapImageAsset,
    this.selectedLabel = AddressLabelType.home,
  });

  final String streetName;
  final String buildingUnit;
  final String noteForRider;
  final String mapImageAsset;
  final AddressLabelType selectedLabel;
}

class PaymentMethodModel {
  const PaymentMethodModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    this.badgeLabel,
    this.selected = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final String? badgeLabel;
  final bool selected;
}

class PaymentMethodsOverview {
  const PaymentMethodsOverview({
    required this.cards,
    required this.wallets,
    required this.otherMethods,
  });

  final List<PaymentMethodModel> cards;
  final List<PaymentMethodModel> wallets;
  final List<PaymentMethodModel> otherMethods;
}

class HelpTopicModel {
  const HelpTopicModel({
    required this.id,
    required this.title,
    required this.iconName,
    required this.iconColorHex,
  });

  final String id;
  final String title;
  final String iconName;
  final String iconColorHex;
}

class HelpCategoryModel {
  const HelpCategoryModel({
    required this.id,
    required this.title,
    required this.iconName,
  });

  final String id;
  final String title;
  final String iconName;
}

class HelpCenterOverview {
  const HelpCenterOverview({
    required this.headerTitle,
    required this.searchPlaceholder,
    required this.topics,
    required this.categories,
    required this.chatLabel,
  });

  final String headerTitle;
  final String searchPlaceholder;
  final List<HelpTopicModel> topics;
  final List<HelpCategoryModel> categories;
  final String chatLabel;
}

class FavoriteRestaurantModel {
  const FavoriteRestaurantModel({
    required this.id,
    required this.name,
    required this.ratingLabel,
    required this.metadataLabel,
    required this.deliveryOfferLabel,
    required this.imageUrl,
    this.isFavorite = true,
  });

  final String id;
  final String name;
  final String ratingLabel;
  final String metadataLabel;
  final String deliveryOfferLabel;
  final String imageUrl;
  final bool isFavorite;
}

class SavedRestaurantsOverview {
  const SavedRestaurantsOverview({
    required this.tabs,
    required this.selectedTab,
    required this.restaurants,
  });

  final List<String> tabs;
  final String selectedTab;
  final List<FavoriteRestaurantModel> restaurants;
}

enum RestaurantDetailsTab { menu, reviews, info }

class RestaurantMenuItemModel {
  const RestaurantMenuItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final String priceLabel;
  final String imageUrl;
}

class RestaurantComboModel {
  const RestaurantComboModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priceLabel,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final String priceLabel;
  final String imageUrl;
}

class RestaurantDrinkModel {
  const RestaurantDrinkModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priceLabel,
  });

  final String id;
  final String title;
  final String description;
  final String priceLabel;
}

class RestaurantStoreInfoModel {
  const RestaurantStoreInfoModel({
    required this.addressLine1,
    required this.addressLine2,
    required this.hoursPrimary,
    required this.hoursSecondary,
    required this.mapImageUrl,
  });

  final String addressLine1;
  final String addressLine2;
  final String hoursPrimary;
  final String hoursSecondary;
  final String mapImageUrl;
}

class RestaurantDetailsOverview {
  const RestaurantDetailsOverview({
    required this.name,
    required this.cuisineLine,
    required this.ratingValue,
    required this.reviewCountLabel,
    required this.distanceLabel,
    required this.heroImageUrl,
    required this.logoImageUrl,
    required this.popularItems,
    required this.comboItems,
    required this.drinks,
    required this.storeInfo,
    required this.cartItemCount,
    required this.cartTotalLabel,
  });

  final String name;
  final String cuisineLine;
  final String ratingValue;
  final String reviewCountLabel;
  final String distanceLabel;
  final String heroImageUrl;
  final String logoImageUrl;
  final List<RestaurantMenuItemModel> popularItems;
  final List<RestaurantComboModel> comboItems;
  final List<RestaurantDrinkModel> drinks;
  final RestaurantStoreInfoModel storeInfo;
  final int cartItemCount;
  final String cartTotalLabel;
}

class AccountSettingsItemModel {
  const AccountSettingsItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconName;
}

class LegalSettingsItemModel {
  const LegalSettingsItemModel({
    required this.id,
    required this.title,
    required this.iconName,
  });

  final String id;
  final String title;
  final String iconName;
}

class AppSettingsOverview {
  const AppSettingsOverview({
    required this.accountItems,
    required this.preferenceCacheLabel,
    required this.legalItems,
    required this.versionLabel,
    required this.footerLogoUrl,
  });

  final List<AccountSettingsItemModel> accountItems;
  final String preferenceCacheLabel;
  final List<LegalSettingsItemModel> legalItems;
  final String versionLabel;
  final String footerLogoUrl;
}

class SavedCardModel {
  const SavedCardModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    this.brandLogoUrl,
    this.badgeLabel,
    this.selected = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final String? brandLogoUrl;
  final String? badgeLabel;
  final bool selected;
}

class SavedCardsOverview {
  const SavedCardsOverview({
    required this.primaryMaskedNumber,
    required this.primaryCardHolder,
    required this.primaryExpiresLabel,
    required this.cards,
  });

  final String primaryMaskedNumber;
  final String primaryCardHolder;
  final String primaryExpiresLabel;
  final List<SavedCardModel> cards;
}

class InviteStepModel {
  const InviteStepModel({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
  });

  final int stepNumber;
  final String title;
  final String subtitle;
}

class InviteFriendsOverview {
  const InviteFriendsOverview({
    required this.heroImageUrl,
    required this.title,
    required this.subtitle,
    required this.referralCode,
    required this.steps,
  });

  final String heroImageUrl;
  final String title;
  final String subtitle;
  final String referralCode;
  final List<InviteStepModel> steps;
}

class PrivacyHighlightModel {
  const PrivacyHighlightModel({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

class PrivacyPolicyOverview {
  const PrivacyPolicyOverview({
    required this.lastUpdated,
    required this.introduction,
    required this.dataCollectionItems,
    required this.useCases,
    required this.thirdPartySharingText,
    required this.userRights,
  });

  final String lastUpdated;
  final String introduction;
  final List<String> dataCollectionItems;
  final List<PrivacyHighlightModel> useCases;
  final String thirdPartySharingText;
  final List<String> userRights;
}

class CheckoutLineItemModel {
  const CheckoutLineItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priceLabel,
    required this.iconName,
  });

  final String id;
  final String title;
  final String subtitle;
  final String priceLabel;
  final String iconName;
}

class CheckoutOverview {
  const CheckoutOverview({
    required this.deliveryAddress,
    required this.deliveryEta,
    required this.items,
    required this.paymentMethodTitle,
    required this.paymentMethodSubtitle,
    required this.subtotalLabel,
    required this.deliveryFeeLabel,
    required this.taxFeeLabel,
    required this.totalLabel,
  });

  final String deliveryAddress;
  final String deliveryEta;
  final List<CheckoutLineItemModel> items;
  final String paymentMethodTitle;
  final String paymentMethodSubtitle;
  final String subtotalLabel;
  final String deliveryFeeLabel;
  final String taxFeeLabel;
  final String totalLabel;
}

class OrderConfirmationOverview {
  const OrderConfirmationOverview({
    required this.title,
    required this.subtitle,
    required this.orderIdLabel,
    required this.arrivalLabel,
    required this.illustrationUrl,
  });

  final String title;
  final String subtitle;
  final String orderIdLabel;
  final String arrivalLabel;
  final String illustrationUrl;
}
