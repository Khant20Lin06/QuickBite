import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/core/utils/validators.dart';
import 'package:quickbite/services/auth_providers.dart';
import 'package:quickbite/services/auth_repository.dart';

final forgotPasswordControllerProvider =
    NotifierProvider<ForgotPasswordController, ForgotPasswordState>(
      ForgotPasswordController.new,
    );

class ForgotPasswordState {
  const ForgotPasswordState({
    this.email = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.success = false,
  });

  final String email;
  final bool isSubmitting;
  final String? errorMessage;
  final bool success;

  bool get isValidEmail => Validators.isLikelyEmail(email);

  ForgotPasswordState copyWith({
    String? email,
    bool? isSubmitting,
    String? errorMessage,
    bool? success,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      success: success ?? this.success,
    );
  }
}

class ForgotPasswordController extends Notifier<ForgotPasswordState> {
  late final AuthRepository _authRepository;

  @override
  ForgotPasswordState build() {
    _authRepository = ref.read(authRepositoryProvider);
    return const ForgotPasswordState();
  }

  void setEmail(String value) {
    state = state.copyWith(email: value, clearError: true, success: false);
  }

  Future<bool> submit() async {
    if (!state.isValidEmail) {
      state = state.copyWith(
        errorMessage: 'Please enter a valid email address.',
        success: false,
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
      success: false,
    );
    try {
      await _authRepository.sendResetLink(state.email.trim());
      state = state.copyWith(isSubmitting: false, success: true);
      return true;
    } on FormatException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.message,
        success: false,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Unable to send reset link right now.',
        success: false,
      );
      return false;
    }
  }
}
