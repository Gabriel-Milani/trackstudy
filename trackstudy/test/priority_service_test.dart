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
}
