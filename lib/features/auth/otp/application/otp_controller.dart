import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/auth/domain/auth_models.dart';
import 'package:quickbite/services/auth_providers.dart';
import 'package:quickbite/services/auth_repository.dart';

final otpCountdownEnabledProvider = Provider<bool>((ref) => true);

final otpControllerProvider = NotifierProvider<OtpController, OtpState>(
  OtpController.new,
);

class OtpState {
  const OtpState({
    this.code = '',
    this.secondsRemaining = 59,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String code;
  final int secondsRemaining;
  final bool isSubmitting;
  final String? errorMessage;

  bool get canSubmit => code.length == 4 && !isSubmitting;

  List<String> get digits {
    return List<String>.generate(
      4,
      (index) => index < code.length ? code[index] : '',
    );
  }

  OtpState copyWith({
    String? code,
    int? secondsRemaining,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OtpState(
      code: code ?? this.code,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class OtpController extends Notifier<OtpState> {
  late final AuthRepository _authRepository;
  Timer? _timer;

  @override
  OtpState build() {
    _authRepository = ref.read(authRepositoryProvider);
    ref.onDispose(() => _timer?.cancel());
    if (ref.read(otpCountdownEnabledProvider)) {
      Future<void>.microtask(() => _startCountdown(from: 59));
    }
    return const OtpState();
  }

  void setDigit(int index, String value) {
    final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (sanitized.isEmpty && index < state.code.length) {
      final chars = state.code.split('')..removeAt(index);
      state = state.copyWith(code: chars.join(), clearError: true);
      return;
    }
    if (sanitized.isEmpty || index > 3) {
      return;
    }

    final chars = state.digits;
    chars[index] = sanitized[0];
    state = state.copyWith(
      code: chars.join().replaceAll(' ', ''),
      clearError: true,
    );
  }

  void appendDigit(String value) {
    if (state.code.length >= 4 || value.isEmpty) {
      return;
    }
    final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (sanitized.isEmpty) {
      return;
    }
    state = state.copyWith(
      code: '${state.code}${sanitized[0]}',
      clearError: true,
    );
  }

  void backspace() {
    if (state.code.isEmpty) {
      return;
    }
    state = state.copyWith(
      code: state.code.substring(0, state.code.length - 1),
      clearError: true,
    );
  }

  Future<void> resendCode() async {
    await _authRepository.requestOtp('+1 234 •••• 789');
    _startCountdown(from: 59);
  }

  Future<bool> submit() async {
    if (state.code.length != 4) {
      state = state.copyWith(errorMessage: 'Please enter all 4 digits.');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await _authRepository.verifyOtp(
      OtpInput(code: state.code, channel: 'sms'),
    );
    state = state.copyWith(isSubmitting: false);
    if (!result.success) {
      state = state.copyWith(errorMessage: result.message);
      return false;
    }

    return true;
  }

  void _startCountdown({required int from}) {
    _timer?.cancel();
    state = state.copyWith(secondsRemaining: from);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining <= 0) {
        timer.cancel();
        return;
      }
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
    });
  }
}
