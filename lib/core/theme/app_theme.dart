import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    final base = ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark,
    );
    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: base,
      scaffoldBackgroundColor: base.surface,
      // Appliance UI: generous touch targets throughout.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(120, 52),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }
}
