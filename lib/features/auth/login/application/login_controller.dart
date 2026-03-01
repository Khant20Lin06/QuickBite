import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/core/utils/validators.dart';
import 'package:quickbite/features/auth/domain/auth_models.dart';
import 'package:quickbite/services/auth_providers.dart';
import 'package:quickbite/services/auth_repository.dart';

final loginControllerProvider =
    NotifierProvider<LoginController, LoginFormState>(LoginController.new);

class LoginFormState {
  const LoginFormState({
    this.identifier = '',
    this.password = '',
    this.obscurePassword = true,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String identifier;
  final String password;
  final bool obscurePassword;
  final bool isSubmitting;
  final String? errorMessage;

  bool get isValid =>
      Validators.isEmailOrPhone(identifier) &&
      Validators.isStrongEnoughPassword(password);

  LoginFormState copyWith({
    String? identifier,
    String? password,
    bool? obscurePassword,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginFormState(
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class LoginController extends Notifier<LoginFormState> {
  late final AuthRepository _authRepository;

  @override
  LoginFormState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return const LoginFormState();
  }

  void setIdentifier(String value) {
    state = state.copyWith(identifier: value, clearError: true);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, clearError: true);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<bool> submit() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Please enter a valid email or phone and password.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await _authRepository.login(
      LoginInput(identifier: state.identifier.trim(), password: state.password),
    );

    state = state.copyWith(isSubmitting: false);
    if (!result.success) {
      state = state.copyWith(errorMessage: result.message);
      return false;
    }

    return true;
  }
}
