import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/priority_service.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.totalMinutesThisWeek,
    required this.sessionsThisWeek,
    required this.longestSessionMinutes,
    required this.averageDailyMinutes,
    required this.streakDays,
    required this.dailyMinutes,
  });

  final int totalMinutesThisWeek;
  final int sessionsThisWeek;
  final int longestSessionMinutes;
  final double averageDailyMinutes;
  final int streakDays;
  final List<int> dailyMinutes;
}

class DashboardService {
  DashboardService(this.database);

  final AppDatabase database;

  Future<DashboardSummary> calculate({DateTime? now}) async {
    final current = now ?? DateTime.now();
    final weekStart = PriorityService.startOfWeek(current);
    final weekEnd = weekStart.add(const Duration(days: 7));

    final results = await Future.wait([
      database.studySessionsDao.getSessionsBetween(weekStart, weekEnd),
      database.studySessionsDao.getAllStudySessions(),
    ]);
    final sessions = results[0];
    final allSessions = results[1];

    final dailySeconds = List<int>.filled(7, 0);
    var longestSessionSeconds = 0;
    for (final session in sessions) {
      final dayIndex = session.startedAt.difference(weekStart).inDays;
      if (dayIndex >= 0 && dayIndex < 7) {
        dailySeconds[dayIndex] += session.durationSeconds;
      }
      if (session.durationSeconds > longestSessionSeconds) {
        longestSessionSeconds = session.durationSeconds;
      }
    }

    final dailyMinutes = dailySeconds
        .map((seconds) => seconds ~/ Duration.secondsPerMinute)
        .toList(growable: false);
    final totalSeconds = dailySeconds.fold<int>(0, (a, b) => a + b);
    final totalMinutes = totalSeconds ~/ Duration.secondsPerMinute;
    final today = DateTime(current.year, current.month, current.day);
    final daysSoFar = today.difference(weekStart).inDays + 1;
    final average = daysSoFar > 0 ? totalMinutes / daysSoFar : 0.0;

    final streak = _calculateStreak(current, allSessions);

    return DashboardSummary(
      totalMinutesThisWeek: totalMinutes,
      sessionsThisWeek: sessions.length,
      longestSessionMinutes: longestSessionSeconds ~/ Duration.secondsPerMinute,
      averageDailyMinutes: average,
      streakDays: streak,
      dailyMinutes: dailyMinutes,
    );
  }

  int _calculateStreak(DateTime now, List<StudySession> sessions) {
    if (sessions.isEmpty) return 0;
    final studiedDays = <DateTime>{
      for (final session in sessions)
        DateTime(
          session.startedAt.year,
          session.startedAt.month,
          session.startedAt.day,
        ),
    };

    final today = DateTime(now.year, now.month, now.day);
    var day = studiedDays.contains(today)
        ? today
        : today.subtract(const Duration(days: 1));
    var streak = 0;
    while (studiedDays.contains(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<Map<DateTime, int>> getDailyMinutesForLastDays(
    int days, {
    DateTime? now,
  }) async {
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final endExclusive = today.add(const Duration(days: 1));
    final start = endExclusive.subtract(Duration(days: days));

    final sessions = await database.studySessionsDao.getSessionsBetween(
      start,
      endExclusive,
    );

    final secondsPerDay = <DateTime, int>{};
    for (final session in sessions) {
      final day = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );
      secondsPerDay[day] = (secondsPerDay[day] ?? 0) + session.durationSeconds;
    }
    return {
      for (final entry in secondsPerDay.entries)
        entry.key: entry.value ~/ Duration.secondsPerMinute,
    };
  }
}
