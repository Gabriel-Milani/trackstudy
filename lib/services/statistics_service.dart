import 'package:trackstudy/database/app_database.dart';

class DisciplineStatistics {
  const DisciplineStatistics({
    required this.discipline,
    required this.totalSeconds,
  });

  final Discipline discipline;
  final int totalSeconds;

  int get totalMinutes => totalSeconds ~/ Duration.secondsPerMinute;
}

class StatisticsService {
  StatisticsService(this.database);

  final AppDatabase database;

  Future<List<DisciplineStatistics>> getStatistics({
    DateTime? start,
    DateTime? end,
  }) async {
    final results = await Future.wait([
      database.disciplinesDao.getAllDisciplines(),
      database.studySessionsDao.getTotalsByDiscipline(start: start, end: end),
    ]);
    final disciplines = results[0] as List<Discipline>;
    final totals = results[1] as Map<int, int>;
    final statistics = disciplines
        .map(
          (discipline) => DisciplineStatistics(
            discipline: discipline,
            totalSeconds: totals[discipline.id] ?? 0,
          ),
        )
        .toList();
    statistics.sort((a, b) => b.totalSeconds.compareTo(a.totalSeconds));
    return statistics;
  }

  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month);

  static DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime exclusiveEndOfDay(DateTime date) =>
      startOfDay(date).add(const Duration(days: 1));
}
