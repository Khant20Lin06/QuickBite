import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:quickbite/features/auth/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:quickbite/features/auth/login/presentation/pages/login_page.dart';
import 'package:quickbite/features/auth/otp/presentation/pages/otp_page.dart';
import 'package:quickbite/features/auth/register/presentation/pages/register_page.dart';
import 'package:quickbite/features/home/checkout_home/presentation/pages/checkout_page.dart';
import 'package:quickbite/features/home/address_home/presentation/pages/add_address_page.dart';
import 'package:quickbite/features/home/favorites_home/presentation/pages/saved_restaurants_page.dart';
import 'package:quickbite/features/home/food_home/presentation/pages/food_home_page.dart';
import 'package:quickbite/features/home/help_home/presentation/pages/help_center_page.dart';
import 'package:quickbite/features/home/invite_home/presentation/pages/invite_friends_page.dart';
import 'package:quickbite/features/home/order_confirmation_home/presentation/pages/order_confirmation_page.dart';
import 'package:quickbite/features/home/orders_home/presentation/pages/orders_home_page.dart';
import 'package:quickbite/features/home/pandamart_home/presentation/pages/pandamart_home_page.dart';
import 'package:quickbite/features/home/payment_home/presentation/pages/add_new_card_page.dart';
import 'package:quickbite/features/home/payment_home/presentation/pages/saved_cards_page.dart';
import 'package:quickbite/features/home/profile_home/presentation/pages/profile_home_page.dart';
import 'package:quickbite/features/home/privacy_home/presentation/pages/privacy_policy_page.dart';
import 'package:quickbite/features/home/restaurant_details_home/presentation/pages/restaurant_details_page.dart';
import 'package:quickbite/features/home/review_home/presentation/pages/review_page.dart';
import 'package:quickbite/features/home/search_home/presentation/pages/search_results_page.dart';
import 'package:quickbite/features/home/settings_home/presentation/pages/app_settings_page.dart';
import 'package:quickbite/features/home/vouchers_home/presentation/pages/vouchers_home_page.dart';
import 'package:quickbite/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:quickbite/features/splash/presentation/pages/splash_page.dart';

import '../helpers/test_wrapper.dart';

const _devices = <Device>[
  Device(name: 'phone_390x844', size: Size(390, 844), devicePixelRatio: 3),
  Device(name: 'phone_412x915', size: Size(412, 915), devicePixelRatio: 3),
];

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('golden_splash', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_splash',
      lightWidget: const SplashPage(enableAutoRedirect: false),
      darkWidget: const SplashPage(enableAutoRedirect: false),
    );
  });

  testGoldens('golden_onboarding', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_onboarding',
      lightWidget: const OnboardingPage(useRemoteImage: false),
      darkWidget: const OnboardingPage(useRemoteImage: false),
    );
  });

  testGoldens('golden_login', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_login',
      lightWidget: const LoginPage(useRemoteImages: false),
      darkWidget: const LoginPage(useRemoteImages: false),
    );
  });

  testGoldens('golden_register', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_register',
      lightWidget: const RegisterPage(useRemoteImages: false),
      darkWidget: const RegisterPage(useRemoteImages: false),
    );
  });

  testGoldens('golden_forgot', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_forgot_password',
      lightWidget: const ForgotPasswordPage(),
      darkWidget: const ForgotPasswordPage(),
    );
  });

  testGoldens('golden_otp', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_otp',
      lightWidget: const OtpPage(),
      darkWidget: const OtpPage(),
    );
  });

  testGoldens('golden_home_food', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_food',
      lightWidget: const FoodHomePage(),
      darkWidget: const FoodHomePage(),
    );
  });

  testGoldens('golden_home_pandamart', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_pandamart',
      lightWidget: const PandamartHomePage(),
      darkWidget: const PandamartHomePage(),
    );
  });

  testGoldens('golden_home_vouchers', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_vouchers',
      lightWidget: const VouchersHomePage(),
      darkWidget: const VouchersHomePage(),
    );
  });

  testGoldens('golden_home_orders', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_orders',
      lightWidget: const OrdersHomePage(),
      darkWidget: const OrdersHomePage(),
    );
  });

  testGoldens('golden_home_profile', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_profile',
      lightWidget: const ProfileHomePage(),
      darkWidget: const ProfileHomePage(),
    );
  });

  testGoldens('golden_home_search', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_search',
      lightWidget: const SearchResultsPage(),
      darkWidget: const SearchResultsPage(),
    );
  });

  testGoldens('golden_home_review', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_review',
      lightWidget: const ReviewPage(),
      darkWidget: const ReviewPage(),
    );
  });

  testGoldens('golden_home_address', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_address',
      lightWidget: const AddAddressPage(),
      darkWidget: const AddAddressPage(),
    );
  });

  testGoldens('golden_home_payments', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_payments',
      lightWidget: const SavedCardsPage(useRemoteImages: false),
      darkWidget: const SavedCardsPage(useRemoteImages: false),
    );
  });

  testGoldens('golden_home_help', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_help',
      lightWidget: const HelpCenterPage(),
      darkWidget: const HelpCenterPage(),
    );
  });

  testGoldens('golden_home_add_card', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_add_card',
      lightWidget: const AddNewCardPage(),
      darkWidget: const AddNewCardPage(),
    );
  });

  testGoldens('golden_home_favorites', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_favorites',
      lightWidget: const SavedRestaurantsPage(useRemoteImages: false),
      darkWidget: const SavedRestaurantsPage(useRemoteImages: false),
    );
  });

  testGoldens('golden_home_restaurant_details', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_restaurant_details',
      lightWidget: const RestaurantDetailsPage(useRemoteImages: false),
      darkWidget: const RestaurantDetailsPage(useRemoteImages: false),
    );
  });

  testGoldens('golden_home_settings', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_settings',
      lightWidget: const AppSettingsPage(useRemoteImages: false),
      darkWidget: const AppSettingsPage(useRemoteImages: false),
    );
  });

  testGoldens('golden_home_invite', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_invite',
      lightWidget: const InviteFriendsPage(useRemoteImages: false),
      darkWidget: const InviteFriendsPage(useRemoteImages: false),
    );
  });

  testGoldens('golden_home_privacy', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_privacy',
      lightWidget: const PrivacyPolicyPage(),
      darkWidget: const PrivacyPolicyPage(),
    );
  });

  testGoldens('golden_home_checkout', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_checkout',
      lightWidget: const CheckoutPage(),
      darkWidget: const CheckoutPage(),
    );
  });

  testGoldens('golden_home_order_confirmation', (tester) async {
    await _captureLightDark(
      tester,
      name: 'mvp_home_order_confirmation',
      lightWidget: const OrderConfirmationPage(useRemoteImages: false),
      darkWidget: const OrderConfirmationPage(useRemoteImages: false),
    );
  });
}

Future<void> _captureLightDark(
  WidgetTester tester, {
  required String name,
  required Widget lightWidget,
  required Widget darkWidget,
}) async {
  await mockNetworkImagesFor(() async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: _devices)
      ..addScenario(name: '${name}_light', widget: testWrapper(lightWidget))
      ..addScenario(
        name: '${name}_dark',
        widget: testWrapper(darkWidget, themeMode: ThemeMode.dark),
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, name);
  });
}
