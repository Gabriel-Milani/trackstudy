import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/pages/home_page.dart';
import 'package:trackstudy/theme/app_theme.dart';
import 'package:trackstudy/theme/theme_controller.dart';

void main() {
  runApp(TrackStudyApp(database: AppDatabase()));
}

class TrackStudyApp extends StatefulWidget {
  const TrackStudyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TrackStudyApp> createState() => _TrackStudyAppState();
}

class _TrackStudyAppState extends State<TrackStudyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        title: 'TrackStudy',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _themeMode,
        home: HomePage(database: widget.database),
      ),
    );
  }
}
