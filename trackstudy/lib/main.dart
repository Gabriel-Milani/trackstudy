import 'package:flutter/material.dart';
import 'pages/disciplines_page.dart';

void main() {
  runApp(const TrackStudyApp());
}

class TrackStudyApp extends StatelessWidget {
  const TrackStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackStudy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DisciplinesPage(),
    );
  }
}
