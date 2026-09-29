import 'package:flutter_test/flutter_test.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/priority_service.dart';

void main() {
  test('startOfWeek returns Monday at midnight', () {
    final result = PriorityService.startOfWeek(DateTime(2026, 8, 24, 14, 30));

    expect(result, DateTime(2026, 8, 24));
  });

  test('startOfWeek handles Sunday', () {
    final result = PriorityService.startOfWeek(DateTime(2026, 8, 30, 23, 59));

    expect(result, DateTime(2026, 8, 24));
  });

  test('remainingWeekdays counts from current day through Friday', () {
    expect(PriorityService.remainingWeekdays(DateTime(2026, 8, 24)), 5);
    expect(PriorityService.remainingWeekdays(DateTime(2026, 8, 28)), 1);
    expect(PriorityService.remainingWeekdays(DateTime(2026, 8, 29)), 0);
  });

  test('score divides remaining goal by remaining weekdays', () {
    final score = PriorityService.calculateScore(
      goalMinutes: 300,
      studiedMinutes: 100,
      remainingDays: 4,
    );

    expect(score, 50);
  });

  test('score is zero when goal is reached or exceeded', () {
    expect(
      PriorityService.calculateScore(
        goalMinutes: 300,
        studiedMinutes: 300,
        remainingDays: 2,
      ),
      0,
    );
    expect(
      PriorityService.calculateScore(
        goalMinutes: 300,
        studiedMinutes: 400,
        remainingDays: 2,
      ),
      0,
    );
  });

  test('score uses absolute deficit when no weekdays remain', () {
    final score = PriorityService.calculateScore(
      goalMinutes: 300,
      studiedMinutes: 120,
      remainingDays: 0,
    );

    expect(score, 180);
  });

  test('overdue activity has stronger urgency than future activity', () {
    final now = DateTime(2026, 8, 24);
    final overdue = Activity(
      id: 1,
      disciplineId: 1,
      title: 'Prova',
      dueAt: DateTime(2026, 8, 23),
      estimatedMinutes: 120,
      isCompleted: false,
    );
    final future = overdue.copyWith(dueAt: DateTime(2026, 9, 20));

    expect(
      PriorityService.activityUrgency(overdue, now),
      greaterThan(PriorityService.activityUrgency(future, now)),
    );
  });

  test('activity due today is urgent but not overdue-level', () {
    final now = DateTime(2026, 9, 28, 20, 30);
    final today = Activity(
      id: 2,
      disciplineId: 1,
      title: 'Entrega hoje',
      dueAt: DateTime(2026, 9, 28),
      estimatedMinutes: 60,
      isCompleted: false,
    );

    final score = PriorityService.activityUrgency(today, now);
    expect(score, 60);
    expect(score, lessThan(10000));
  });

  test('activities urgency sums all pending activities', () {
    final now = DateTime(2026, 9, 28);
    final today = Activity(
      id: 1,
      disciplineId: 1,
      title: 'Lista',
      dueAt: DateTime(2026, 9, 28),
      estimatedMinutes: 60,
      isCompleted: false,
    );
    final tomorrow = today.copyWith(
      id: 2,
      title: 'Revisao',
      dueAt: DateTime(2026, 9, 29),
      estimatedMinutes: 40,
    );

    expect(PriorityService.activitiesUrgency([today, tomorrow], now), 80);
  });

  test('review intervals increase with the study history', () {
    expect(PriorityService.reviewIntervalForSessions(1), 1);
    expect(PriorityService.reviewIntervalForSessions(2), 3);
    expect(PriorityService.reviewIntervalForSessions(4), 7);
    expect(PriorityService.reviewIntervalForSessions(7), 14);
    expect(PriorityService.reviewIntervalForSessions(8), 30);
  });

  test('review becomes urgent only when its interval is due', () {
    final lastStudy = DateTime(2026, 9, 20, 18);

    expect(
      PriorityService.nextReviewDate(lastStudy: lastStudy, sessionCount: 2),
      DateTime(2026, 9, 23),
    );
    expect(
      PriorityService.reviewUrgency(
        lastStudy: lastStudy,
        sessionCount: 2,
        now: DateTime(2026, 9, 22),
      ),
      0,
    );
    expect(
      PriorityService.reviewUrgency(
        lastStudy: lastStudy,
        sessionCount: 2,
        now: DateTime(2026, 9, 25),
      ),
      16,
    );
  });

  test('remainingStudyDays respects configured weekend days', () {
    expect(
      PriorityService.remainingStudyDays(DateTime(2026, 8, 29), {
        DateTime.saturday,
        DateTime.sunday,
      }),
      2,
    );
  });
}
