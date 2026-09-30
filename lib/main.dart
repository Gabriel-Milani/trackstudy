import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/pages/home_page.dart';
import 'package:trackstudy/services/app_preferences.dart';
import 'package:trackstudy/theme/app_theme.dart';
import 'package:trackstudy/theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(TrackStudyApp(database: AppDatabase()));
}

class TrackStudyApp extends StatefulWidget {
  const TrackStudyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TrackStudyApp> createState() => _TrackStudyAppState();
}

class _TrackStudyAppState extends State<TrackStudyApp> {
  final _preferences = AppPreferences();
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await _preferences.loadThemeMode();
    if (mounted) setState(() => _themeMode = mode);
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    await _preferences.saveThemeMode(mode);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      themeMode: _themeMode,
      setThemeMode: _setThemeMode,
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
