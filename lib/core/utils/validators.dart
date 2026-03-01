abstract final class Validators {
  static bool isLikelyEmail(String input) {
    final value = input.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);
  }

  static bool isLikelyPhone(String input) {
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 7;
  }

  static bool isEmailOrPhone(String input) {
    return isLikelyEmail(input) || isLikelyPhone(input);
  }

  static bool isStrongEnoughPassword(String input) => input.length >= 6;

  static bool isOtpCode(String input) =>
      RegExp(r'^\d{4}$').hasMatch(input.trim());
}
