import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickbite/app/routes.dart';
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

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    overridePlatformDefaultLocation: true,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        name: 'otp',
        builder: (context, state) => const OtpPage(),
      ),
      GoRoute(
        path: AppRoutes.homeFood,
        name: 'homeFood',
        builder: (context, state) => const FoodHomePage(),
      ),
      GoRoute(
        path: AppRoutes.homePandamart,
        name: 'homePandamart',
        builder: (context, state) => const PandamartHomePage(),
      ),
      GoRoute(
        path: AppRoutes.homeVouchers,
        name: 'homeVouchers',
        builder: (context, state) => const VouchersHomePage(),
      ),
      GoRoute(
        path: AppRoutes.homeOrders,
        name: 'homeOrders',
        builder: (context, state) => const OrdersHomePage(),
      ),
      GoRoute(
        path: AppRoutes.homeProfile,
        name: 'homeProfile',
        builder: (context, state) => const ProfileHomePage(),
      ),
      GoRoute(
        path: AppRoutes.homeSearch,
        name: 'homeSearch',
        builder: (context, state) => const SearchResultsPage(),
      ),
      GoRoute(
        path: AppRoutes.homeReview,
        name: 'homeReview',
        builder: (context, state) => const ReviewPage(),
      ),
      GoRoute(
        path: AppRoutes.homeAddress,
        name: 'homeAddress',
        builder: (context, state) => const AddAddressPage(),
      ),
      GoRoute(
        path: AppRoutes.homePayments,
        name: 'homePayments',
        builder: (context, state) => const SavedCardsPage(),
      ),
      GoRoute(
        path: AppRoutes.homeHelp,
        name: 'homeHelp',
        builder: (context, state) => const HelpCenterPage(),
      ),
      GoRoute(
        path: AppRoutes.homeFavorites,
        name: 'homeFavorites',
        builder: (context, state) => const SavedRestaurantsPage(),
      ),
      GoRoute(
        path: AppRoutes.homeRestaurantDetails,
        name: 'homeRestaurantDetails',
        builder: (context, state) => const RestaurantDetailsPage(),
      ),
      GoRoute(
        path: AppRoutes.homeSettings,
        name: 'homeSettings',
        builder: (context, state) => const AppSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.homeInvite,
        name: 'homeInvite',
        builder: (context, state) => const InviteFriendsPage(),
      ),
      GoRoute(
        path: AppRoutes.homePrivacy,
        name: 'homePrivacy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: AppRoutes.homeAddCard,
        name: 'homeAddCard',
        builder: (context, state) => const AddNewCardPage(),
      ),
      GoRoute(
        path: AppRoutes.homeCheckout,
        name: 'homeCheckout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: AppRoutes.homeOrderConfirmation,
        name: 'homeOrderConfirmation',
        builder: (context, state) => const OrderConfirmationPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri.toString()}')),
    ),
  );
});
