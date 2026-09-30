import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light
  static const lightBackground = Color(0xFFF7F8FC);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightBorder = Color(0xFFE2E8F0);

  // Dark
  static const darkBackground = Color(0xFF0B0F1A);
  static const darkCard = Color(0xFF161B2C);
  static const darkTextPrimary = Color(0xFFF1F5F9);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkBorder = Color(0xFF232A3D);

  // Gradiente principal (índigo -> roxo)
  static const gradientStart = Color(0xFF4F46E5);
  static const gradientEnd = Color(0xFF7C3AED);
  static const gradientStartDark = Color(0xFF818CF8);
  static const gradientEndDark = Color(0xFFA78BFA);

  static const primaryLight = Color(0xFF4F46E5);
  static const primaryDark = Color(0xFF818CF8);

  static const success = Color(0xFF16A34A);
  static const alert = Color(0xFFDC2626);
  static const warning = Color(0xFFD97706);

  /// Paleta de cores por disciplina: fundo claro + cor do ícone.
  /// O índice usado é `discipline.id % disciplinePalette.length`.
  static const List<Color> disciplineBg = [
    Color(0xFFEEF2FF),
    Color(0xFFECFDF5),
    Color(0xFFF5F3FF),
    Color(0xFFF3E8FF),
  ];

  static const List<Color> disciplineFg = [
    Color(0xFF4F46E5),
    Color(0xFF16A34A),
    Color(0xFF8B5CF6),
    Color(0xFF9333EA),
  ];

  static LinearGradient heroGradient(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [gradientStartDark, gradientEndDark]
          : [gradientStart, gradientEnd],
    );
  }
}
