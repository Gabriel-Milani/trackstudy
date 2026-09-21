import 'package:flutter/material.dart';

/// Categoria de uma disciplina, usada para escolher o ícone e a cor
/// mostrados nos cards (Exatas, Tecnológicas, Humanas, Biológicas, Outras).
enum DisciplineCategory {
  exatas,
  tecnologia,
  humanas,
  biologicas,
  outras;

  static DisciplineCategory fromKey(String key) {
    return DisciplineCategory.values.firstWhere(
      (category) => category.key == key,
      orElse: () => DisciplineCategory.outras,
    );
  }

  String get key => switch (this) {
    DisciplineCategory.exatas => 'exatas',
    DisciplineCategory.tecnologia => 'tecnologia',
    DisciplineCategory.humanas => 'humanas',
    DisciplineCategory.biologicas => 'biologicas',
    DisciplineCategory.outras => 'outras',
  };

  String get label => switch (this) {
    DisciplineCategory.exatas => 'Exatas',
    DisciplineCategory.tecnologia => 'Tecnológicas',
    DisciplineCategory.humanas => 'Humanas',
    DisciplineCategory.biologicas => 'Biológicas',
    DisciplineCategory.outras => 'Outras',
  };

  /// Flutter não tem um glifo de "π" pronto; calculadora comunica bem
  /// "Exatas" sem ambiguidade. Troque por outro Icons.* se preferir.
  IconData get icon => switch (this) {
    DisciplineCategory.exatas => Icons.calculate_rounded,
    DisciplineCategory.tecnologia => Icons.code_rounded,
    DisciplineCategory.humanas => Icons.menu_book_rounded,
    DisciplineCategory.biologicas => Icons.pets_rounded,
    DisciplineCategory.outras => Icons.category_rounded,
  };

  int get colorIndex => switch (this) {
    DisciplineCategory.exatas => 0,
    DisciplineCategory.tecnologia => 1,
    DisciplineCategory.humanas => 2,
    DisciplineCategory.biologicas => 3,
    DisciplineCategory.outras => 0,
  };
}
