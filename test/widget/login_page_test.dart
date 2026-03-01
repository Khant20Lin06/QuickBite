import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbite/features/auth/domain/auth_models.dart';
import 'package:quickbite/features/auth/login/presentation/pages/login_page.dart';
import 'package:quickbite/services/auth_providers.dart';
import 'package:quickbite/services/auth_repository.dart';

import '../helpers/test_wrapper.dart';

void main() {
  testWidgets('login form validates and shows loading state', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      testWrapperWithOverrides(
        const LoginPage(),
        overrides: [
          authRepositoryProvider.overrideWithValue(_FailingAuthRepository()),
        ],
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(
      find.text('Please enter a valid email or phone and password.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.byKey(const Key('qb_loading_indicator')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('qb_loading_indicator')), findsNothing);
  });
}

class _FailingAuthRepository implements AuthRepository {
  @override
  Future<AuthResult> login(LoginInput input) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return const AuthResult(success: false, message: 'Invalid credentials.');
  }

  @override
  Future<AuthResult> register(RegisterInput input) async {
    return const AuthResult(success: false, message: 'Not used in this test.');
  }

  @override
  Future<void> requestOtp(String phoneOrEmail) async {}

  @override
  Future<void> sendResetLink(String email) async {}

  @override
  Future<AuthResult> verifyOtp(OtpInput input) async {
    return const AuthResult(success: false, message: 'Not used in this test.');
  }
}
