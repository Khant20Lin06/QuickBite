import 'package:quickbite/features/auth/domain/auth_models.dart';

abstract class AuthRepository {
  Future<AuthResult> login(LoginInput input);

  Future<AuthResult> register(RegisterInput input);

  Future<void> sendResetLink(String email);

  Future<void> requestOtp(String phoneOrEmail);

  Future<AuthResult> verifyOtp(OtpInput input);
}
