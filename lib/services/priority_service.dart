import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/app_preferences.dart';

class DisciplinePriority {
  const DisciplinePriority({
    required this.discipline,
    required this.studiedMinutes,
    required this.remainingMinutes,
    required this.score,
    required this.daysSinceLastStudy,
    required this.reviewIntervalDays,
    this.nextReviewAt,
    this.pendingActivities = const <Activity>[],
    this.nextActivity,
  });

  final Discipline discipline;
  final int studiedMinutes;
  final int remainingMinutes;
  final double score;
  final int? daysSinceLastStudy;
  final int reviewIntervalDays;
  final DateTime? nextReviewAt;
  final List<Activity> pendingActivities;
  final Activity? nextActivity;

  List<String> reasons(DateTime now) {
    final result = <String>[];
    if (remainingMinutes > 0) {
      result.add('$remainingMinutes min restantes da meta semanal');
    }
    final overdueCount = pendingActivities.where((activity) {
      final today = DateTime(now.year, now.month, now.day);
      final due = DateTime(
        activity.dueAt.year,
        activity.dueAt.month,
        activity.dueAt.day,
      );
      return due.isBefore(today);
    }).length;
    if (overdueCount > 1) {
      result.add('$overdueCount atividades atrasadas');
    } else if (pendingActivities.length > 1) {
      result.add('${pendingActivities.length} atividades pendentes');
    }
    final activity = pendingActivities.isNotEmpty
        ? pendingActivities.first
        : nextActivity;
    if (activity != null) {
      final today = DateTime(now.year, now.month, now.day);
      final due = DateTime(
        activity.dueAt.year,
        activity.dueAt.month,
        activity.dueAt.day,
      );
      final days = due.difference(today).inDays;
      if (days < 0) {
        result.add('atividade atrasada: ${activity.title}');
      } else if (days == 0) {
        result.add('atividade vence hoje: ${activity.title}');
      } else if (days <= 7) {
        result.add('atividade vence em $days dia${days == 1 ? '' : 's'}');
      }
    }
    if (nextReviewAt != null) {
      final today = DateTime(now.year, now.month, now.day);
      final reviewDay = DateTime(
        nextReviewAt!.year,
        nextReviewAt!.month,
        nextReviewAt!.day,
      );
      final daysLate = today.difference(reviewDay).inDays;
      if (daysLate > 0) {
        result.add(
          'revisao atrasada ha $daysLate dia${daysLate == 1 ? '' : 's'}',
        );
      } else if (daysLate == 0) {
        result.add('revisao recomendada hoje');
      }
    } else if (daysSinceLastStudy != null && daysSinceLastStudy! >= 2) {
      result.add('${daysSinceLastStudy!} dias sem estudar esta disciplina');
    }
    return result.take(3).toList();
  }
}

class PriorityService {
  PriorityService(this.database);
  final AppDatabase database;

  Future<List<DisciplinePriority>> calculatePriorities({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final weekStart = startOfWeek(current);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final weekdays = await AppPreferences().loadStudyWeekdays();
    final remainingDays = remainingStudyDays(current, weekdays);

    final results = await Future.wait([
      database.disciplinesDao.getAllDisciplines(),
      database.studySessionsDao.getTotalsByDiscipline(
        start: weekStart,
        end: weekEnd,
      ),
      database.activitiesDao.getPendingActivities(),
      database.studySessionsDao.getAllStudySessions(),
    ]);
    final disciplines = results[0] as List<Discipline>;
    final totals = results[1] as Map<int, int>;
    final pending = results[2] as List<Activity>;
    final sessions = results[3] as List<StudySession>;

    final activitiesByDiscipline = <int, List<Activity>>{};
    for (final activity in pending) {
      activitiesByDiscipline
          .putIfAbsent(activity.disciplineId, () => <Activity>[])
          .add(activity);
    }
    final lastStudyByDiscipline = <int, DateTime>{};
    final sessionCountByDiscipline = <int, int>{};
    for (final session in sessions) {
      if (session.startedAt.isAfter(current)) continue;
      lastStudyByDiscipline.putIfAbsent(
        session.disciplineId,
        () => session.startedAt,
      );
      sessionCountByDiscipline.update(
        session.disciplineId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }

    final priorities = disciplines.map((discipline) {
      final seconds = totals[discipline.id] ?? 0;
      final studiedMinutes = seconds ~/ Duration.secondsPerMinute;
      final remaining = discipline.weeklyGoalMinutes - studiedMinutes;
      final remainingMinutes = remaining > 0 ? remaining : 0;
      final pendingActivities =
          activitiesByDiscipline[discipline.id] ?? const <Activity>[];
      final nextActivity = pendingActivities.isEmpty
          ? null
          : pendingActivities.first;
      final lastStudy = lastStudyByDiscipline[discipline.id];
      final sessionCount = sessionCountByDiscipline[discipline.id] ?? 0;
      final daysSince = lastStudy == null
          ? null
          : _daysBetween(lastStudy, current);
      final reviewIntervalDays = reviewIntervalForSessions(sessionCount);
      final nextReviewAt = nextReviewDate(
        lastStudy: lastStudy,
        sessionCount: sessionCount,
      );
      final score =
          calculateScore(
            goalMinutes: discipline.weeklyGoalMinutes,
            studiedMinutes: studiedMinutes,
            remainingDays: remainingDays,
          ) +
          activitiesUrgency(pendingActivities, current) +
          reviewUrgency(
            lastStudy: lastStudy,
            sessionCount: sessionCount,
            now: current,
          );

      return DisciplinePriority(
        discipline: discipline,
        studiedMinutes: studiedMinutes,
        remainingMinutes: remainingMinutes,
        score: score,
        reviewIntervalDays: reviewIntervalDays,
        nextReviewAt: nextReviewAt,
        pendingActivities: pendingActivities,
        nextActivity: nextActivity,
        daysSinceLastStudy: daysSince,
      );
    }).toList();
    priorities.sort((a, b) => b.score.compareTo(a.score));
    return priorities;
  }

  static DateTime startOfWeek(DateTime date) {
    final midnight = DateTime(date.year, date.month, date.day);
    return midnight.subtract(Duration(days: date.weekday - DateTime.monday));
  }

  static int remainingWeekdays(DateTime date) => remainingStudyDays(date, {
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  });

  static int remainingStudyDays(DateTime date, Set<int> studyWeekdays) {
    var day = DateTime(date.year, date.month, date.day);
    final nextMonday = startOfWeek(day).add(const Duration(days: 7));
    var count = 0;
    while (day.isBefore(nextMonday)) {
      if (studyWeekdays.contains(day.weekday)) count++;
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

  static double activitiesUrgency(List<Activity> activities, DateTime now) {
    return activities.fold<double>(
      0,
      (total, activity) => total + activityUrgency(activity, now),
    );
  }

  static int reviewIntervalForSessions(int sessionCount) {
    if (sessionCount <= 1) return 1;
    if (sessionCount == 2) return 3;
    if (sessionCount <= 4) return 7;
    if (sessionCount <= 7) return 14;
    return 30;
  }

  static DateTime? nextReviewDate({
    required DateTime? lastStudy,
    required int sessionCount,
  }) {
    if (lastStudy == null) return null;
    final studyDay = DateTime(lastStudy.year, lastStudy.month, lastStudy.day);
    return studyDay.add(
      Duration(days: reviewIntervalForSessions(sessionCount)),
    );
  }

  static double reviewUrgency({
    required DateTime? lastStudy,
    required int sessionCount,
    required DateTime now,
  }) {
    if (lastStudy == null) return 12;
    final dueAt = nextReviewDate(
      lastStudy: lastStudy,
      sessionCount: sessionCount,
    )!;
    final today = DateTime(now.year, now.month, now.day);
    final daysLate = today.difference(dueAt).inDays;
    if (daysLate < 0) return 0;
    return (10 + (daysLate * 3).clamp(0, 30)).toDouble();
  }

  static int _daysBetween(DateTime from, DateTime to) {
    final a = DateTime(from.year, from.month, from.day);
    final b = DateTime(to.year, to.month, to.day);
    return b.difference(a).inDays.clamp(0, 9999).toInt();
  }
}
