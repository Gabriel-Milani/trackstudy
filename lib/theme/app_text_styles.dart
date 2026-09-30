import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle greeting(Color color) =>
      TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color);

  static TextStyle subtitle(Color color) =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color);

  static TextStyle sectionTitle(Color color) =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color);

  static TextStyle cardTitle(Color color) =>
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color);

  static TextStyle cardSubtitle(Color color) =>
      TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: color);

  static TextStyle statValue(Color color) =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color);

  static TextStyle statLabel(Color color) =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle legenda(Color color) =>
      TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: color);
}
