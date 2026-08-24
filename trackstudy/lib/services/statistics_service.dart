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
    final disciplines = await database.disciplinesDao.getAllDisciplines();
    final statistics = await Future.wait(
      disciplines.map((discipline) async {
        final seconds = start == null || end == null
            ? await database.studySessionsDao.getTotalSecondsByDiscipline(
                discipline.id,
              )
            : await database.studySessionsDao
                  .getTotalSecondsByDisciplineBetween(
                    discipline.id,
                    start,
                    end,
                  );
        return DisciplineStatistics(
          discipline: discipline,
          totalSeconds: seconds,
        );
      }),
    );
    statistics.sort((a, b) => b.totalSeconds.compareTo(a.totalSeconds));
    return statistics;
  }

  static DateTime startOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime exclusiveEndOfDay(DateTime date) =>
      startOfDay(date).add(const Duration(days: 1));
}
