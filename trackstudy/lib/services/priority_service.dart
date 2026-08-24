import 'package:trackstudy/database/app_database.dart';

class DisciplinePriority {
  const DisciplinePriority({
    required this.discipline,
    required this.studiedMinutes,
    required this.remainingMinutes,
    required this.score,
    this.nextActivity,
  });

  final Discipline discipline;
  final int studiedMinutes;
  final int remainingMinutes;
  final double score;
  final Activity? nextActivity;
}

class PriorityService {
  PriorityService(this.database);

  final AppDatabase database;

  Future<List<DisciplinePriority>> calculatePriorities({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final weekStart = startOfWeek(current);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final remainingDays = remainingWeekdays(current);
    final disciplines = await database.disciplinesDao.getAllDisciplines();

    final priorities = await Future.wait(
      disciplines.map((discipline) async {
        final seconds = await database.studySessionsDao
            .getTotalSecondsByDisciplineBetween(
              discipline.id,
              weekStart,
              weekEnd,
            );
        final studiedMinutes = seconds ~/ Duration.secondsPerMinute;
        final remaining = discipline.weeklyGoalMinutes - studiedMinutes;
        final remainingMinutes = remaining > 0 ? remaining : 0;
        final baseScore = calculateScore(
          goalMinutes: discipline.weeklyGoalMinutes,
          studiedMinutes: studiedMinutes,
          remainingDays: remainingDays,
        );
        final pending = await database.activitiesDao
            .getPendingActivitiesByDiscipline(discipline.id);
        final nextActivity = pending.firstOrNull;
        final score = baseScore + activityUrgency(nextActivity, current);

        return DisciplinePriority(
          discipline: discipline,
          studiedMinutes: studiedMinutes,
          remainingMinutes: remainingMinutes,
          score: score,
          nextActivity: nextActivity,
        );
      }),
    );

    priorities.sort((a, b) => b.score.compareTo(a.score));
    return priorities;
  }

  static DateTime startOfWeek(DateTime date) {
    final midnight = DateTime(date.year, date.month, date.day);
    return midnight.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  static int remainingWeekdays(DateTime date) {
    var day = DateTime(date.year, date.month, date.day);
    final nextMonday = startOfWeek(day).add(const Duration(days: 7));
    var count = 0;
    while (day.isBefore(nextMonday)) {
      if (day.weekday <= DateTime.friday) count++;
      day = day.add(const Duration(days: 1));
    }
    return count;
  }

  static double calculateScore({
    required int goalMinutes,
    required int studiedMinutes,
    required int remainingDays,
  }) {
    final remainingMinutes = goalMinutes - studiedMinutes;
    if (remainingMinutes <= 0) return 0;
    if (remainingDays <= 0) return remainingMinutes.toDouble();
    return remainingMinutes / remainingDays;
  }

  static double activityUrgency(Activity? activity, DateTime now) {
    if (activity == null) return 0;
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      activity.dueAt.year,
      activity.dueAt.month,
      activity.dueAt.day,
    );
    final days = due.difference(today).inDays;
    if (days < 0) return 10000.0 + activity.estimatedMinutes;
    if (days <= 7) return activity.estimatedMinutes / (days + 1);
    return 0;
  }
}
