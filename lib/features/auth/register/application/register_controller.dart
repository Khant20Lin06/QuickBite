import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/core/utils/validators.dart';
import 'package:quickbite/features/auth/domain/auth_models.dart';
import 'package:quickbite/services/auth_providers.dart';
import 'package:quickbite/services/auth_repository.dart';

final registerControllerProvider =
    NotifierProvider<RegisterController, RegisterFormState>(
      RegisterController.new,
    );

class RegisterFormState {
  const RegisterFormState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.acceptTerms = false,
    this.obscurePassword = true,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final bool acceptTerms;
  final bool obscurePassword;
  final bool isSubmitting;
  final String? errorMessage;

  bool get isValid =>
      fullName.trim().isNotEmpty &&
      Validators.isLikelyEmail(email) &&
      Validators.isLikelyPhone(phone) &&
      Validators.isStrongEnoughPassword(password) &&
      acceptTerms;

  RegisterFormState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? password,
    bool? acceptTerms,
    bool? obscurePassword,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RegisterFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class RegisterController extends Notifier<RegisterFormState> {
  late final AuthRepository _authRepository;

  @override
  RegisterFormState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return const RegisterFormState();
  }

  void setFullName(String value) {
    state = state.copyWith(fullName: value, clearError: true);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value, clearError: true);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value, clearError: true);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, clearError: true);
  }

  void setAcceptTerms(bool value) {
    state = state.copyWith(acceptTerms: value, clearError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<bool> submit() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Please fill all fields correctly and accept the terms.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await _authRepository.register(
      RegisterInput(
        fullName: state.fullName.trim(),
        email: state.email.trim(),
        phone: state.phone.trim(),
        password: state.password,
        acceptTerms: state.acceptTerms,
      ),
    );

    state = state.copyWith(isSubmitting: false);
    if (!result.success) {
      state = state.copyWith(errorMessage: result.message);
      return false;
    }

    return true;
  }
}
