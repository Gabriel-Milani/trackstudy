import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/pages/home_page.dart';

void main() {
  runApp(TrackStudyApp(database: AppDatabase()));
}

class TrackStudyApp extends StatelessWidget {
  const TrackStudyApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackStudy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: HomePage(database: database),
    );
  }
}
