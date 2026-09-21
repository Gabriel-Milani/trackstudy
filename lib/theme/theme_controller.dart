import 'package:flutter/material.dart';

/// Disponibiliza o modo de tema atual (claro por padrão) e uma função pra
/// alternar entre claro e escuro, acessível de qualquer tela do app.
class ThemeController extends InheritedWidget {
  const ThemeController({
    super.key,
    required this.themeMode,
    required this.toggleTheme,
    required super.child,
  });

  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  static ThemeController of(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<ThemeController>();
    assert(controller != null, 'ThemeController não encontrado no contexto.');
    return controller!;
  }

  @override
  bool updateShouldNotify(ThemeController oldWidget) =>
      themeMode != oldWidget.themeMode;
}
