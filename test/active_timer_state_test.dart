import 'package:flutter_test/flutter_test.dart';
import 'package:trackstudy/services/active_timer_store.dart';

void main() {
  test('active timer v2 survives JSON roundtrip', () {
    final original = ActiveTimerState(
      disciplineId: 7,
      startedAt: DateTime(2026, 9, 28, 18),
      segmentStartedAt: DateTime(2026, 9, 28, 18, 10),
      studySeconds: 600,
      phaseSeconds: 300,
      isPaused: false,
      mode: 'pomodoro',
      phase: 'focus',
      focusMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      cyclesBeforeLongBreak: 4,
      completedCycles: 2,
      notes: 'Capítulo 4',
    );

    final restored = ActiveTimerState.fromJson(original.toJson());
    expect(restored.disciplineId, original.disciplineId);
    expect(restored.startedAt, original.startedAt);
    expect(restored.segmentStartedAt, original.segmentStartedAt);
    expect(restored.studySeconds, 600);
    expect(restored.phaseSeconds, 300);
    expect(restored.mode, 'pomodoro');
    expect(restored.completedCycles, 2);
    expect(restored.notes, 'Capítulo 4');
  });

  test('legacy v1 active timer is migrated in memory', () {
    final restored = ActiveTimerState.fromJson({
      'disciplineId': 1,
      'startedAt': DateTime(2026, 9, 28, 18).toIso8601String(),
      'segmentStartedAt': null,
      'accumulatedSeconds': 900,
      'isPaused': true,
      'pomodoroEnabled': true,
      'focusMinutes': 25,
      'notes': 'legado',
    });
    expect(restored.studySeconds, 900);
    expect(restored.phaseSeconds, 900);
    expect(restored.mode, 'pomodoro');
  });
}
