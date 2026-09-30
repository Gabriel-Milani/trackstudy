import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/priority_service.dart';

class WeeklySummary {
  const WeeklySummary({
    required this.currentMinutes,
    required this.previousMinutes,
    required this.totalGoalMinutes,
    required this.goalsReached,
    required this.disciplineCount,
  });

  final int currentMinutes;
  final int previousMinutes;
  final int totalGoalMinutes;
  final int goalsReached;
  final int disciplineCount;

  int get differenceMinutes => currentMinutes - previousMinutes;
  double get progress =>
      totalGoalMinutes == 0 ? 0 : currentMinutes / totalGoalMinutes;
}

class WeeklySummaryService {
  WeeklySummaryService(this.database);

  final AppDatabase database;

  Future<WeeklySummary> calculate({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final currentStart = PriorityService.startOfWeek(current);
    final currentEnd = currentStart.add(const Duration(days: 7));
    final previousStart = currentStart.subtract(const Duration(days: 7));
    final disciplines = await database.disciplinesDao.getAllDisciplines();
    var currentSeconds = 0;
    var previousSeconds = 0;
    var totalGoalMinutes = 0;
    var goalsReached = 0;
    for (final discipline in disciplines) {
      final currentDisciplineSeconds = await database.studySessionsDao
          .getTotalSecondsByDisciplineBetween(
            discipline.id,
            currentStart,
            currentEnd,
          );
      final previousDisciplineSeconds = await database.studySessionsDao
          .getTotalSecondsByDisciplineBetween(
            discipline.id,
            previousStart,
            currentStart,
          );
      currentSeconds += currentDisciplineSeconds;
      previousSeconds += previousDisciplineSeconds;
      totalGoalMinutes += discipline.weeklyGoalMinutes;
      if (currentDisciplineSeconds ~/ 60 >= discipline.weeklyGoalMinutes) {
        goalsReached++;
      }
    }
    return WeeklySummary(
      currentMinutes: currentSeconds ~/ 60,
      previousMinutes: previousSeconds ~/ 60,
      totalGoalMinutes: totalGoalMinutes,
      goalsReached: goalsReached,
      disciplineCount: disciplines.length,
    );
  }
}
