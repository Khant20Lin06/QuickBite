import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/auth/otp/application/otp_controller.dart';
import 'package:quickbite/app/theme.dart';

Widget testWrapper(Widget child, {ThemeMode themeMode = ThemeMode.light}) {
  return testWrapperWithOverrides(
    child,
    themeMode: themeMode,
    overrides: const [],
  );
}

Widget testWrapperWithOverrides(
  Widget child, {
  ThemeMode themeMode = ThemeMode.light,
  List overrides = const [],
}) {
  return ProviderScope(
    overrides: [
      otpCountdownEnabledProvider.overrideWithValue(false),
      ...overrides,
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: QBTheme.light(),
      darkTheme: QBTheme.dark(),
      themeMode: themeMode,
      home: child,
    ),
  );
}
