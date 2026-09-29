import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      error: AppColors.alert,
      surface: AppColors.lightCard,
    ),
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightCard,
      indicatorColor: AppColors.primaryLight.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      iconTheme: WidgetStateProperty.all(const IconThemeData(size: 20)),
    ),
    textTheme: const TextTheme().apply(
      bodyColor: AppColors.lightTextPrimary,
      displayColor: AppColors.lightTextPrimary,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      error: AppColors.alert,
      surface: AppColors.darkCard,
    ),
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.darkCard,
      indicatorColor: AppColors.primaryDark.withValues(alpha: 0.2),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
      iconTheme: WidgetStateProperty.all(const IconThemeData(size: 20)),
    ),
    textTheme: const TextTheme().apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    ),
  );
}
