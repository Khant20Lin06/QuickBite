class LoginInput {
  const LoginInput({required this.identifier, required this.password});

  final String identifier;
  final String password;
}

class RegisterInput {
  const RegisterInput({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.acceptTerms,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final bool acceptTerms;
}

class OtpInput {
  const OtpInput({required this.code, required this.channel});

  final String code;
  final String channel;
}

class AuthResult {
  const AuthResult({required this.success, required this.message, this.token});

  final bool success;
  final String message;
  final String? token;
}
