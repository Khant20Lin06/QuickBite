import 'package:quickbite/core/constants/home_assets.dart';
import 'package:quickbite/core/constants/home_design_assets.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_repository.dart';

class MockHomeRepository implements HomeRepository {
  const MockHomeRepository();

  @override
  Future<HomeFeed> getFoodHome() async {
    return const HomeFeed(
      address: '123 Orchard Road, Singapore',
      searchPlaceholder: 'Food, groceries, and more',
      promoBanner: PromoBannerModel(
        title: '50% OFF',
        subtitle: 'on your first 3 orders',
        ctaLabel: 'Claim Now',
        imageAsset: HomeAssets.promoBackground,
      ),
      mainTiles: [
        CategoryChipModel(
          id: 'food_delivery',
          title: 'Food Delivery',
          subtitle: 'Order from your favorites',
          imageAsset: HomeAssets.pizza,
        ),
        CategoryChipModel(
          id: 'pandamart',
          title: 'Pandamart',
          subtitle: 'Groceries in 20 mins',
          imageAsset: HomeAssets.grocery,
        ),
        CategoryChipModel(
          id: 'pickup',
          title: 'Pick-up',
          iconName: 'shopping_bag',
        ),
        CategoryChipModel(id: 'shops', title: 'Shops', iconName: 'storefront'),
      ],
      voucherSummaries: [
        VoucherSummaryModel(
          id: 'welcome-gift',
          title: 'Welcome Gift',
          subtitle: r'$10 OFF your order',
          terms: r'Min. spend $20',
          iconName: 'confirmation_number',
        ),
        VoucherSummaryModel(
          id: 'free-delivery',
          title: 'Free Delivery',
          subtitle: 'On all Mart orders',
          terms: 'Limited time offer',
          iconName: 'delivery_dining',
        ),
      ],
      restaurants: [
        RestaurantCardModel(
          id: 'pizza-express',
          name: 'Pizza Express - Orchard',
          cuisineLine: 'Italian | Pizza | \$\$',
          rating: 4.8,
          reviewCountLabel: '(1.2k+)',
          deliveryEta: '20-30 min',
          imageAsset: HomeAssets.pizza,
          promoTag: 'PROMO',
        ),
        RestaurantCardModel(
          id: 'burger-king',
          name: 'Burger King - Somerset',
          cuisineLine: 'American | Fast Food | \$',
          rating: 4.2,
          reviewCountLabel: '(500+)',
          deliveryEta: '15-25 min',
          imageAsset: HomeAssets.burger,
        ),
      ],
    );
  }

  @override
  Future<GroceryCatalog> getPandamart() async {
    return const GroceryCatalog(
      title: 'Pandamart',
      deliveryEta: 'Delivery in 20 mins',
      searchPlaceholder: 'Search for groceries...',
      categories: [
        CategoryChipModel(
          id: 'produce',
          title: 'Fresh Produce',
          imageAsset: HomeAssets.grocery,
        ),
        CategoryChipModel(
          id: 'dairy',
          title: 'Dairy & Eggs',
          imageAsset: HomeAssets.dairy,
        ),
        CategoryChipModel(
          id: 'snacks',
          title: 'Snacks',
          imageAsset: HomeAssets.burger,
        ),
        CategoryChipModel(
          id: 'beverages',
          title: 'Beverages',
          imageAsset: HomeAssets.promoBackground,
        ),
        CategoryChipModel(id: 'more', title: 'More', iconName: 'more_horiz'),
      ],
      items: [
        GroceryItemModel(
          id: 'banana',
          name: 'Premium Fresh Organic Cavendish Bananas',
          unitLabel: '1kg',
          price: 2.40,
          originalPrice: 2.80,
          badgeText: 'SAVE 10%',
          imageAsset: HomeAssets.grocery,
        ),
        GroceryItemModel(
          id: 'frozen-pizza',
          name: 'Artisanal Frozen Pepperoni Pizza',
          unitLabel: '400g',
          price: 8.90,
          imageAsset: HomeAssets.pizza,
        ),
        GroceryItemModel(
          id: 'orange-juice',
          name: 'Fresh Squeezed Orange Juice',
          unitLabel: '500ml',
          price: 4.50,
          imageAsset: HomeAssets.promoBackground,
        ),
        GroceryItemModel(
          id: 'cheddar',
          name: 'Gourmet Aged Cheddar Cheese',
          unitLabel: '200g',
          price: 6.75,
          badgeText: 'NEW',
          imageAsset: HomeAssets.dairy,
        ),
      ],
    );
  }

  @override
  Future<VoucherCollection> getVouchers() async {
    return const VoucherCollection(
      title: 'Vouchers & Offers',
      tabs: [
        VoucherTab.foodDelivery,
        VoucherTab.pandamart,
        VoucherTab.shops,
        VoucherTab.subscriptions,
      ],
      vouchers: [
        VoucherModel(
          id: 'free-delivery',
          tab: VoucherTab.foodDelivery,
          title: 'Free Delivery',
          description: 'Valid for orders above \$15 at selected restaurants',
          expiryLabel: 'Expires: 31 Oct 2023',
          minSpendLabel: 'Min. spend \$15.00',
          iconName: 'delivery_dining',
          actionType: VoucherActionType.apply,
          badgeLabel: 'NEW',
        ),
        VoucherModel(
          id: 'food-20',
          tab: VoucherTab.foodDelivery,
          title: '20% OFF',
          description: 'Applicable to all food delivery orders',
          expiryLabel: 'Expires: 15 Nov 2023',
          minSpendLabel: 'Min. spend \$20.00',
          iconName: 'restaurant',
          actionType: VoucherActionType.copyCode,
        ),
        VoucherModel(
          id: 'delivery-5',
          tab: VoucherTab.foodDelivery,
          title: '\$5 Off Delivery',
          description: 'Save on shipping for your next 3 orders',
          expiryLabel: 'Expires: 12 Nov 2023',
          minSpendLabel: 'Min. spend \$10.00',
          iconName: 'payments',
          actionType: VoucherActionType.apply,
        ),
        VoucherModel(
          id: 'mart-expired',
          tab: VoucherTab.pandamart,
          title: '10% Off Mart',
          description: 'Exclusive grocery discounts',
          expiryLabel: 'Expired: 01 Oct 2023',
          minSpendLabel: 'Expired voucher',
          iconName: 'shopping_basket',
          actionType: VoucherActionType.claimed,
          disabled: true,
        ),
      ],
      inviteReward: InviteRewardModel(
        title: 'Refer a friend and get \$5',
        subtitle: 'Share your referral link with friends',
        actionLabel: 'Invite',
        iconName: 'celebration',
      ),
    );
  }

  @override
  Future<OrdersOverview> getOrders() async {
    return const OrdersOverview(
      activeOrder: ActiveOrderModel(
        id: 'active-88291',
        restaurantName: 'Pizza Express - Orchard',
        orderLabel: 'Order #88291 | 3 items',
        arrivalLabel: 'Arriving in 12m',
        progressTitle: 'Preparing your meal',
        progressActionLabel: 'Track',
        progressValue: 0.66,
        imageAsset: HomeAssets.pizza,
      ),
      pastOrders: [
        PastOrderModel(
          id: 'past-1',
          name: 'Burger King - Somerset',
          totalLabel: '\$24.50',
          dateLabel: '12 Oct 2023, 18:45',
          itemsLabel:
              '1x Whopper Jr. Meal, 1x Chicken Fries (9pc), 1x Pepsi Max',
          imageAsset: HomeAssets.burger,
        ),
        PastOrderModel(
          id: 'past-2',
          name: 'Pandamart - Central',
          totalLabel: '\$42.10',
          dateLabel: '08 Oct 2023, 14:20',
          itemsLabel:
              'Fresh Milk 2L, Eggs (30pc), Avocados (3pk), Wholemeal Bread...',
          imageAsset: HomeAssets.grocery,
          iconName: 'shopping_cart',
        ),
        PastOrderModel(
          id: 'past-3',
          name: 'Pasta Mania',
          totalLabel: '\$18.90',
          dateLabel: '01 Oct 2023, 20:15',
          itemsLabel: '1x Carbonara, 1x Garlic Bread',
          imageAsset: HomeAssets.dairy,
        ),
      ],
    );
  }

  @override
  Future<ProfileOverview> getProfile() async {
    return const ProfileOverview(
      name: 'Alex Johnson',
      memberSince: 'Member since 2023',
      avatarAsset: HomeAssets.profileUser,
      primaryItems: [
        ProfileMenuItemModel(
          id: 'payment',
          title: 'Payment Methods',
          iconName: 'credit_card',
        ),
        ProfileMenuItemModel(
          id: 'addresses',
          title: 'Addresses',
          iconName: 'location_on',
        ),
        ProfileMenuItemModel(
          id: 'vouchers',
          title: 'Vouchers',
          iconName: 'confirmation_number',
          badgeLabel: '3 New',
        ),
        ProfileMenuItemModel(
          id: 'help',
          title: 'Help Center',
          iconName: 'help_center',
        ),
        ProfileMenuItemModel(
          id: 'settings',
          title: 'Settings',
          iconName: 'settings',
        ),
      ],
      secondaryItems: [
        ProfileMenuItemModel(
          id: 'invite',
          title: 'Invite Friends',
          iconName: 'card_giftcard',
        ),
        ProfileMenuItemModel(
          id: 'privacy',
          title: 'Privacy Policy',
          iconName: 'security',
        ),
      ],
      versionLabel: 'Version 4.12.0 (2024)',
    );
  }

  @override
  Future<SearchResultCollection> getSearchResults() async {
    return const SearchResultCollection(
      query: 'Pizza',
      resultCountLabel: '12 results for "Pizza"',
      filters: [
        SearchFilterModel(
          id: 'cuisine',
          label: 'Cuisine',
          filled: true,
          hasTrailingExpand: true,
        ),
        SearchFilterModel(id: 'rating', label: 'Rating 4.0+'),
        SearchFilterModel(
          id: 'price',
          label: 'Price Range',
          hasTrailingExpand: true,
        ),
        SearchFilterModel(
          id: 'delivery_fee',
          label: 'Delivery Fee',
          hasTrailingExpand: true,
        ),
      ],
      results: [
        SearchResultModel(
          id: 'search-1',
          title: 'Pizza Express - Orchard',
          subtitle: 'Italian | Pizza | \$\$',
          rating: '4.8',
          reviewCountLabel: '(1.2k+)',
          deliveryEta: '25-35 min',
          imageAsset: HomeAssets.pizza,
          badges: ['PROMO', 'FREE DELIVERY'],
          highlightLabel: 'Free delivery above \$15',
          highlightIconName: 'delivery_dining',
        ),
        SearchResultModel(
          id: 'search-2',
          title: 'Gourmet Market - Somerset',
          subtitle: 'Groceries | Fresh Food | \$\$\$',
          rating: '4.6',
          reviewCountLabel: '(800+)',
          deliveryEta: '15-20 min',
          imageAsset: HomeAssets.grocery,
          badges: ['MART'],
          highlightLabel: 'Up to 20% off selected items',
          highlightIconName: 'sell',
        ),
        SearchResultModel(
          id: 'search-3',
          title: 'The Burger Hub',
          subtitle: 'Burgers | American | \$\$',
          rating: '4.2',
          reviewCountLabel: '(500+)',
          deliveryEta: '30-45 min',
          imageAsset: HomeAssets.burger,
        ),
      ],
    );
  }

  @override
  Future<ReviewOverview> getReviewOverview() async {
    return const ReviewOverview(
      restaurantName: 'Pizza Express - Orchard',
      orderLabel: 'Order #FP-92841 | Yesterday',
      heroImageAsset: HomeAssets.pizza,
      attachedImageAssets: [HomeAssets.dairy],
    );
  }

  @override
  Future<AddressDraft> getAddressDraft() async {
    return const AddressDraft(
      streetName: '123 Orchard Road',
      buildingUnit: '',
      noteForRider: '',
      mapImageAsset: HomeAssets.addressMap,
      selectedLabel: AddressLabelType.home,
    );
  }

  @override
  Future<PaymentMethodsOverview> getPaymentMethods() async {
    return const PaymentMethodsOverview(
      cards: [
        PaymentMethodModel(
          id: 'visa-4242',
          title: 'Visa •••• 4242',
          subtitle: 'Expires 12/26',
          iconName: 'credit_card',
          badgeLabel: 'DEFAULT',
          selected: true,
        ),
        PaymentMethodModel(
          id: 'mc-8890',
          title: 'Mastercard •••• 8890',
          subtitle: 'Expires 09/25',
          iconName: 'payment',
        ),
      ],
      wallets: [
        PaymentMethodModel(
          id: 'apple-pay',
          title: 'Apple Pay',
          subtitle: 'Quick & secure checkout',
          iconName: 'ios',
        ),
        PaymentMethodModel(
          id: 'paypal',
          title: 'PayPal',
          subtitle: 'Connect your account',
          iconName: 'account_balance_wallet',
        ),
      ],
      otherMethods: [
        PaymentMethodModel(
          id: 'cod',
          title: 'Cash on Delivery',
          subtitle: 'Pay when your order arrives',
          iconName: 'payments',
        ),
      ],
    );
  }

  @override
  Future<HelpCenterOverview> getHelpCenter() async {
    return const HelpCenterOverview(
      headerTitle: 'How can we help?',
      searchPlaceholder: 'Search for help articles...',
      topics: [
        HelpTopicModel(
          id: 'order-status',
          title: 'Where is my order?',
          iconName: 'local_shipping',
          iconColorHex: '#3B82F6',
        ),
        HelpTopicModel(
          id: 'refunds',
          title: 'Refunds & Returns',
          iconName: 'payments',
          iconColorHex: '#22C55E',
        ),
        HelpTopicModel(
          id: 'payment-issues',
          title: 'Payment Issues',
          iconName: 'error',
          iconColorHex: '#F59E0B',
        ),
        HelpTopicModel(
          id: 'account',
          title: 'Account Settings',
          iconName: 'account_circle',
          iconColorHex: '#A855F7',
        ),
        HelpTopicModel(
          id: 'vouchers',
          title: 'Vouchers & Promos',
          iconName: 'confirmation_number',
          iconColorHex: '#F1277B',
        ),
      ],
      categories: [
        HelpCategoryModel(
          id: 'grocery',
          title: 'Grocery Support',
          iconName: 'shopping_basket',
        ),
        HelpCategoryModel(
          id: 'food',
          title: 'Food Support',
          iconName: 'restaurant',
        ),
      ],
      chatLabel: 'Chat with our Agent',
    );
  }

  @override
  Future<SavedRestaurantsOverview> getSavedRestaurants() async {
    return const SavedRestaurantsOverview(
      tabs: ['Restaurants', 'Groceries'],
      selectedTab: 'Restaurants',
      restaurants: [
        FavoriteRestaurantModel(
          id: 'the-burger-joint',
          name: 'The Burger Joint',
          ratingLabel: '4.8',
          metadataLabel: '(500+) • 20-30 min',
          deliveryOfferLabel: 'Free delivery over \$15',
          imageUrl: HomeDesignAssets.favoritesBurger,
        ),
        FavoriteRestaurantModel(
          id: 'sushi-zen',
          name: 'Sushi Zen',
          ratingLabel: '4.9',
          metadataLabel: '(1.2k) • 30-45 min',
          deliveryOfferLabel: '\$2.99 delivery fee',
          imageUrl: HomeDesignAssets.favoritesSushi,
        ),
        FavoriteRestaurantModel(
          id: 'bella-pizza',
          name: 'Bella Pizza',
          ratingLabel: '4.7',
          metadataLabel: '(800+) • 15-25 min',
          deliveryOfferLabel: 'Free delivery',
          imageUrl: HomeDesignAssets.favoritesPizza,
        ),
      ],
    );
  }

  @override
  Future<RestaurantDetailsOverview> getRestaurantDetails(
    String restaurantId,
  ) async {
    return const RestaurantDetailsOverview(
      name: 'Burger Haven',
      cuisineLine: 'Burger • American • Fast Food',
      ratingValue: '4.8',
      reviewCountLabel: '(500+ reviews)',
      distanceLabel: '1.2 miles',
      heroImageUrl: HomeDesignAssets.restaurantHero,
      logoImageUrl: HomeDesignAssets.restaurantLogo,
      popularItems: [
        RestaurantMenuItemModel(
          id: 'smokehouse',
          title: 'The Smokehouse BBQ',
          description:
              'Double patty, cheddar, crispy onions, BBQ sauce, and smoked bacon on a brioche bun.',
          priceLabel: '\$14.99',
          imageUrl: HomeDesignAssets.restaurantPopularBbq,
        ),
        RestaurantMenuItemModel(
          id: 'classic-cheeseburger',
          title: 'Classic Cheeseburger',
          description:
              'Angus beef, lettuce, tomato, pickles, and our signature sauce.',
          priceLabel: '\$11.50',
          imageUrl: HomeDesignAssets.restaurantPopularClassic,
        ),
      ],
      comboItems: [
        RestaurantComboModel(
          id: 'duo-box',
          title: 'The Duo Box',
          description: '2 Burgers + 2 Fries + 2 Drinks',
          priceLabel: '\$24.99',
          imageUrl: HomeDesignAssets.restaurantComboDuo,
        ),
        RestaurantComboModel(
          id: 'party-platter',
          title: 'Party Platter',
          description: '4 Burgers + 1 Large Wings + 4 Drinks',
          priceLabel: '\$42.99',
          imageUrl: HomeDesignAssets.restaurantComboParty,
        ),
      ],
      drinks: [
        RestaurantDrinkModel(
          id: 'milkshake',
          title: 'Hand-spun Milkshake',
          description: 'Vanilla, Chocolate or Strawberry',
          priceLabel: '\$5.99',
        ),
        RestaurantDrinkModel(
          id: 'iced-tea',
          title: 'Iced Lemon Tea',
          description: 'Freshly brewed daily',
          priceLabel: '\$2.50',
        ),
      ],
      storeInfo: RestaurantStoreInfoModel(
        addressLine1: '123 Foodie Ave, Gourmet City',
        addressLine2: 'Main Square Mall, Ground Floor',
        hoursPrimary: 'Open until 11:00 PM',
        hoursSecondary: 'Monday - Sunday: 10:00 AM - 11:00 PM',
        mapImageUrl: HomeDesignAssets.restaurantMap,
      ),
      cartItemCount: 2,
      cartTotalLabel: '\$26.49',
    );
  }

  @override
  Future<AppSettingsOverview> getAppSettings() async {
    return const AppSettingsOverview(
      accountItems: [
        AccountSettingsItemModel(
          id: 'account-info',
          title: 'Account Info',
          subtitle: 'Manage your profile and address',
          iconName: 'person',
        ),
        AccountSettingsItemModel(
          id: 'notifications',
          title: 'Notification Settings',
          subtitle: 'Customize order updates & promos',
          iconName: 'notifications_active',
        ),
      ],
      preferenceCacheLabel: '124 MB',
      legalItems: [
        LegalSettingsItemModel(
          id: 'privacy-policy',
          title: 'Privacy Policy',
          iconName: 'policy',
        ),
        LegalSettingsItemModel(
          id: 'terms',
          title: 'Terms of Service',
          iconName: 'description',
        ),
      ],
      versionLabel: 'App Version 2.4.0 (102)',
      footerLogoUrl: HomeDesignAssets.settingsFooterLogo,
    );
  }

  @override
  Future<SavedCardsOverview> getSavedCards() async {
    return const SavedCardsOverview(
      primaryMaskedNumber: '**** **** **** 4242',
      primaryCardHolder: 'ALEX JOHNSON',
      primaryExpiresLabel: '12/26',
      cards: [
        SavedCardModel(
          id: 'visa-4242',
          title: 'Visa ending in 4242',
          subtitle: 'Expires 12/2026',
          iconName: 'credit_card',
          badgeLabel: 'Default',
          brandLogoUrl: HomeDesignAssets.cardVisaLogo,
          selected: true,
        ),
        SavedCardModel(
          id: 'master-8888',
          title: 'Mastercard ending in 8888',
          subtitle: 'Expires 09/2025',
          iconName: 'payment',
          brandLogoUrl: HomeDesignAssets.cardMasterLogo,
        ),
        SavedCardModel(
          id: 'apple-pay',
          title: 'Apple Pay',
          subtitle: 'Connected via iCloud',
          iconName: 'account_balance_wallet',
        ),
      ],
    );
  }

  @override
  Future<InviteFriendsOverview> getInviteFriends() async {
    return const InviteFriendsOverview(
      heroImageUrl: HomeDesignAssets.inviteFriendsHero,
      title: 'Invite Friends, Get \$5 Off',
      subtitle:
          'Share the love of food with your friends and get rewarded for every referral that completes their first order.',
      referralCode: 'FOODIE500',
      steps: [
        InviteStepModel(
          stepNumber: 1,
          title: 'Send invite link',
          subtitle: 'Invite your friends to try the app with your code.',
        ),
        InviteStepModel(
          stepNumber: 2,
          title: 'They order food',
          subtitle:
              'Your friend gets \$5 off their first order using your link.',
        ),
        InviteStepModel(
          stepNumber: 3,
          title: 'You get rewarded',
          subtitle:
              'Once they complete their first order, you will receive \$5 in your wallet!',
        ),
      ],
    );
  }

  @override
  Future<PrivacyPolicyOverview> getPrivacyPolicy() async {
    return const PrivacyPolicyOverview(
      lastUpdated: 'October 2023',
      introduction:
          'This policy describes how we collect, use, and share your personal information when you use our food delivery services.',
      dataCollectionItems: [
        'Name, email, and phone number',
        'Delivery addresses and location data',
        'Order history and preferences',
        'Payment information (processed securely)',
      ],
      useCases: [
        PrivacyHighlightModel(
          title: 'Service Delivery',
          subtitle:
              'Facilitating food and grocery orders from local merchants to your doorstep.',
        ),
        PrivacyHighlightModel(
          title: 'Personalization',
          subtitle:
              'Tailoring restaurant recommendations and offers based on your tastes.',
        ),
      ],
      thirdPartySharingText:
          'We may share your information with our business partners, including merchants and delivery couriers, to fulfill your orders.',
      userRights: [
        'Right to access and export your data',
        'Right to request deletion of your account',
        'Right to opt-out of marketing communications',
      ],
    );
  }

  @override
  Future<CheckoutOverview> getCheckoutOverview() async {
    return const CheckoutOverview(
      deliveryAddress: '123 Sunshine Street, Yangon',
      deliveryEta: '15-25 mins',
      items: [
        CheckoutLineItemModel(
          id: 'chicken-burger',
          title: 'Chicken Burger',
          subtitle: 'x1 • Extra Cheese',
          priceLabel: '\$5.00',
          iconName: 'fastfood',
        ),
        CheckoutLineItemModel(
          id: 'iced-coffee',
          title: 'Iced Coffee',
          subtitle: 'x2 • Regular Size',
          priceLabel: '\$6.00',
          iconName: 'local_drink',
        ),
      ],
      paymentMethodTitle: 'KBZPay',
      paymentMethodSubtitle: 'Balance: \$450.00',
      subtotalLabel: '\$11.00',
      deliveryFeeLabel: '\$1.50',
      taxFeeLabel: '\$0.80',
      totalLabel: '\$13.30',
    );
  }

  @override
  Future<OrderConfirmationOverview> getOrderConfirmation() async {
    return const OrderConfirmationOverview(
      title: 'Order Placed Successfully!',
      subtitle:
          'Your food is being prepared and will arrive shortly. Hang tight!',
      orderIdLabel: '#FD-8829',
      arrivalLabel: '25-35 mins',
      illustrationUrl: HomeDesignAssets.orderConfirmationHero,
    );
  }
}
