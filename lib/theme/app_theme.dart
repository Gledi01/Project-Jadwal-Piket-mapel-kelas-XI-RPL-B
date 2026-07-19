import 'package:flutter/material.dart';

enum AppThemeColor { hijau, biru, ungu, oranye, merah }

extension AppThemeColorX on AppThemeColor {
  String get label {
    switch (this) {
      case AppThemeColor.hijau:
        return 'Hijau';
      case AppThemeColor.biru:
        return 'Biru';
      case AppThemeColor.ungu:
        return 'Ungu';
      case AppThemeColor.oranye:
        return 'Oranye';
      case AppThemeColor.merah:
        return 'Merah';
    }
  }

  Color get seed {
    switch (this) {
      case AppThemeColor.hijau:
        return const Color(0xFF34C759);
      case AppThemeColor.biru:
        return const Color(0xFF2E7CF6);
      case AppThemeColor.ungu:
        return const Color(0xFF8B5CF6);
      case AppThemeColor.oranye:
        return const Color(0xFFFF9500);
      case AppThemeColor.merah:
        return const Color(0xFFEF4444);
    }
  }
}

class AppTheme {
  static ThemeData light(AppThemeColor color) {
    final seed = color.seed;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF7F8FA),
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black.withOpacity(0.05)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: seed.withOpacity(0.15),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  static ThemeData dark(AppThemeColor color) {
    final seed = color.seed;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF0F1115),
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0F1115),
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1A1D23),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1A1D23),
        indicatorColor: seed.withOpacity(0.25),
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
