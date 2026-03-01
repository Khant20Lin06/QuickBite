import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/app/tokens.dart';

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setMode(ThemeMode mode) => state = mode;
}

abstract final class QBTheme {
  static ThemeData light() {
    final base = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: QBTokens.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: QBTokens.backgroundLight,
      fontFamily: 'Plus Jakarta Sans',
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: 'Plus Jakarta Sans'),
      inputDecorationTheme: _inputDecorationTheme(false),
      elevatedButtonTheme: _elevatedButtonTheme(),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(false),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(QBTokens.radiusXl),
          side: const BorderSide(color: _QBPalette.slate100),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: QBTokens.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: QBTokens.backgroundDark,
      fontFamily: 'Plus Jakarta Sans',
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: 'Plus Jakarta Sans'),
      inputDecorationTheme: _inputDecorationTheme(true),
      elevatedButtonTheme: _elevatedButtonTheme(),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(true),
      cardTheme: CardThemeData(
        color: QBTokens.backgroundDark,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(QBTokens.radiusXl),
          side: const BorderSide(color: _QBPalette.slate800),
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(bool isDark) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(QBTokens.radiusMd),
        borderSide: BorderSide(
          color: isDark ? _QBPalette.slate700 : _QBPalette.slate200,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(QBTokens.radiusMd),
        borderSide: BorderSide(
          color: isDark ? _QBPalette.slate700 : _QBPalette.slate200,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(QBTokens.radiusMd),
        borderSide: BorderSide(color: QBTokens.primary, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      filled: true,
      fillColor: isDark ? _QBPalette.slate900 : _QBPalette.slate50,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: QBTokens.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: QBTokens.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(bool isDark) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isDark ? _QBPalette.slate800 : _QBPalette.slate200,
        ),
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

abstract final class _QBPalette {
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
}
