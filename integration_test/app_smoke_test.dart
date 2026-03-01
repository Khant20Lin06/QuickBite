import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:quickbite/app/app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('auth success to home chain smoke test', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: QuickBiteApp()));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsOneWidget);

    await tester.ensureVisible(find.text('Already have an account? Log in'));
    await tester.tap(find.text('Already have an account? Log in'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome Back'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
    expect(find.text('Restaurants Near You'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-search-bar')));
    await tester.pumpAndSettle();
    expect(find.textContaining('results for "Pizza"'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom-nav-orders')));
    await tester.pumpAndSettle();
    expect(find.text('My Orders'), findsOneWidget);

    await tester.tap(find.byKey(const Key('orders-tab-past')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Receipt').first);
    await tester.pumpAndSettle();
    expect(find.text('Write a Review'), findsOneWidget);

    await tester.tap(find.byIcon(Symbols.close).first);
    await tester.pumpAndSettle();
    expect(find.text('My Orders'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom-nav-profile')));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsWidgets);

    await tester.tap(find.byKey(const Key('profile-menu-payment')));
    await tester.pumpAndSettle();
    expect(find.text('Payment Methods'), findsOneWidget);
    await tester.tap(find.byIcon(Symbols.arrow_back_ios_new).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile-menu-addresses')));
    await tester.pumpAndSettle();
    expect(find.text('Add New Address'), findsOneWidget);
    await tester.tap(find.byIcon(Symbols.arrow_back_ios).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('profile-menu-help')));
    await tester.pumpAndSettle();
    expect(find.text('Help Center'), findsWidgets);

    await tester.tap(find.byKey(const Key('bottom-nav-home')));
    await tester.pumpAndSettle();
    expect(find.text('Restaurants Near You'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-favorites-button')));
    await tester.pumpAndSettle();
    expect(find.text('Favorites'), findsWidgets);

    await tester.tap(find.byKey(const Key('favorite-order-the-burger-joint')));
    await tester.pumpAndSettle();
    expect(find.text('Burger Haven'), findsOneWidget);

    await tester.tap(find.byKey(const Key('restaurant-view-cart-button')));
    await tester.pumpAndSettle();
    expect(find.text('Checkout'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const Key('checkout-place-order-button')),
    );
    await tester.tap(find.byKey(const Key('checkout-place-order-button')));
    await tester.pumpAndSettle();
    expect(find.text('Order Placed Successfully!'), findsOneWidget);

    await tester.tap(find.byKey(const Key('order-confirmation-home-button')));
    await tester.pumpAndSettle();
    expect(find.text('Restaurants Near You'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home-tile-pandamart')));
    await tester.pumpAndSettle();
    expect(find.text('Popular Near You'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pandamart-vouchers')));
    await tester.pumpAndSettle();
    expect(find.text('Vouchers & Offers'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom-nav-profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-menu-settings')));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.byKey(const Key('settings-legal-privacy-policy')));
    await tester.pumpAndSettle();
    expect(find.text('Privacy Policy'), findsWidgets);

    await tester.tap(find.byKey(const Key('bottom-nav-profile')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-menu-invite')));
    await tester.pumpAndSettle();
    expect(find.text('Invite Friends'), findsWidgets);
  });
}
