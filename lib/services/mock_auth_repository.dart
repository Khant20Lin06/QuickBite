import 'dart:async';

import 'package:quickbite/core/utils/validators.dart';
import 'package:quickbite/features/auth/domain/auth_models.dart';
import 'package:quickbite/services/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository();

  @override
  Future<AuthResult> login(LoginInput input) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!Validators.isEmailOrPhone(input.identifier) ||
        !Validators.isStrongEnoughPassword(input.password)) {
      return const AuthResult(success: false, message: 'Invalid credentials.');
    }

    return const AuthResult(
      success: true,
      message: 'Logged in successfully (mock).',
      token: 'mock-token',
    );
  }

  @override
  Future<AuthResult> register(RegisterInput input) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (input.fullName.trim().isEmpty ||
        !Validators.isLikelyEmail(input.email) ||
        !Validators.isLikelyPhone(input.phone) ||
        !Validators.isStrongEnoughPassword(input.password) ||
        !input.acceptTerms) {
      return const AuthResult(
        success: false,
        message: 'Please provide valid registration details.',
      );
    }

    return const AuthResult(
      success: true,
      message: 'Account created successfully (mock).',
      token: 'mock-token',
    );
  }

  @override
  Future<void> requestOtp(String phoneOrEmail) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> sendResetLink(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!Validators.isLikelyEmail(email)) {
      throw const FormatException('Invalid email address.');
    }
  }

  @override
  Future<AuthResult> verifyOtp(OtpInput input) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final isValid = Validators.isOtpCode(input.code);
    if (!isValid) {
      return const AuthResult(
        success: false,
        message: 'Invalid verification code.',
      );
    }

    return const AuthResult(
      success: true,
      message: 'Verification successful (mock).',
      token: 'verified-mock-token',
    );
  }
}
