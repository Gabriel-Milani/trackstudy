import 'package:flutter/material.dart';

class ThemeController extends InheritedWidget {
  const ThemeController({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  final ThemeMode themeMode;
  final Future<void> Function(ThemeMode mode) setThemeMode;

  Future<void> toggleTheme() => setThemeMode(
        themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
      );

  static ThemeController of(BuildContext context) {
    final controller =
        context.dependOnInheritedWidgetOfExactType<ThemeController>();
    assert(controller != null, 'ThemeController não encontrado no contexto.');
    return controller!;
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) =>
      themeMode != oldWidget.themeMode;
}
