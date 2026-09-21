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

    final sessions = await database.studySessionsDao.getSessionsBetween(
      weekStart,
      weekEnd,
    );

    final dailyMinutes = List<int>.filled(7, 0);
    var longestSessionSeconds = 0;
    for (final session in sessions) {
      final dayIndex = session.startedAt.difference(weekStart).inDays;
      if (dayIndex >= 0 && dayIndex < 7) {
        dailyMinutes[dayIndex] +=
            session.durationSeconds ~/ Duration.secondsPerMinute;
      }
      if (session.durationSeconds > longestSessionSeconds) {
        longestSessionSeconds = session.durationSeconds;
      }
    }

    final totalMinutes = dailyMinutes.fold<int>(0, (a, b) => a + b);
    final today = DateTime(current.year, current.month, current.day);
    final daysSoFar = today.difference(weekStart).inDays + 1;
    final average = daysSoFar > 0 ? totalMinutes / daysSoFar : 0.0;

    final streak = await _calculateStreak(current);

    return DashboardSummary(
      totalMinutesThisWeek: totalMinutes,
      sessionsThisWeek: sessions.length,
      longestSessionMinutes: longestSessionSeconds ~/ Duration.secondsPerMinute,
      averageDailyMinutes: average,
      streakDays: streak,
      dailyMinutes: dailyMinutes,
    );
  }

  Future<int> _calculateStreak(DateTime now) async {
    var streak = 0;
    var day = DateTime(now.year, now.month, now.day);
    while (true) {
      final nextDay = day.add(const Duration(days: 1));
      final sessions = await database.studySessionsDao.getSessionsBetween(
        day,
        nextDay,
      );
      if (sessions.isEmpty) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Minutos estudados por dia nos últimos [days] dias (padrão: 84 = 12
  /// semanas), usado no calendário de consistência dos Relatórios.
  /// A chave do mapa é a data normalizada (sem horário).
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

    final result = <DateTime, int>{};
    for (final session in sessions) {
      final day = DateTime(
        session.startedAt.year,
        session.startedAt.month,
        session.startedAt.day,
      );
      result[day] =
          (result[day] ?? 0) +
          session.durationSeconds ~/ Duration.secondsPerMinute;
    }
    return result;
  }
}
