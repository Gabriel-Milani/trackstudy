import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _themeKey = 'theme_mode';
  static const _studyWeekdaysKey = 'study_weekdays';

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return switch (prefs.getString(_themeKey)) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_themeKey, value);
  }

  Future<Set<int>> loadStudyWeekdays() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_studyWeekdaysKey);
    if (raw == null || raw.isEmpty) {
      return {DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday};
    }
    final parsed = raw.map(int.tryParse).whereType<int>().where((d) => d >= 1 && d <= 7).toSet();
    return parsed.isEmpty ? {DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday} : parsed;
  }

  Future<void> saveStudyWeekdays(Set<int> weekdays) async {
    final prefs = await SharedPreferences.getInstance();
    final sorted = weekdays.toList()..sort();
    await prefs.setStringList(_studyWeekdaysKey, sorted.map((e) => '$e').toList());
  }
}
