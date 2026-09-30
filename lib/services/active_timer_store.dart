import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ActiveTimerState {
  const ActiveTimerState({
    required this.disciplineId,
    required this.startedAt,
    required this.studySeconds,
    required this.phaseSeconds,
    required this.isPaused,
    required this.mode,
    required this.phase,
    required this.focusMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.cyclesBeforeLongBreak,
    required this.completedCycles,
    required this.notes,
    this.segmentStartedAt,
  });

  final int disciplineId;
  final DateTime startedAt;
  final DateTime? segmentStartedAt;
  final int studySeconds;
  final int phaseSeconds;
  final bool isPaused;
  final String mode;
  final String phase;
  final int focusMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int cyclesBeforeLongBreak;
  final int completedCycles;
  final String notes;

  Map<String, Object?> toJson() => {
        'disciplineId': disciplineId,
        'startedAt': startedAt.toIso8601String(),
        'segmentStartedAt': segmentStartedAt?.toIso8601String(),
        'studySeconds': studySeconds,
        'phaseSeconds': phaseSeconds,
        'isPaused': isPaused,
        'mode': mode,
        'phase': phase,
        'focusMinutes': focusMinutes,
        'shortBreakMinutes': shortBreakMinutes,
        'longBreakMinutes': longBreakMinutes,
        'cyclesBeforeLongBreak': cyclesBeforeLongBreak,
        'completedCycles': completedCycles,
        'notes': notes,
      };

  static ActiveTimerState fromJson(Map<String, dynamic> json) {
    // Compatibilidade com o formato v1 entregue anteriormente.
    final oldAccumulated = json['accumulatedSeconds'] as int?;
    final oldPomodoro = json['pomodoroEnabled'] as bool?;
    return ActiveTimerState(
      disciplineId: json['disciplineId'] as int,
      startedAt: DateTime.parse(json['startedAt'] as String),
      segmentStartedAt: json['segmentStartedAt'] == null
          ? null
          : DateTime.parse(json['segmentStartedAt'] as String),
      studySeconds: json['studySeconds'] as int? ?? oldAccumulated ?? 0,
      phaseSeconds: json['phaseSeconds'] as int? ?? oldAccumulated ?? 0,
      isPaused: json['isPaused'] as bool? ?? false,
      mode: json['mode'] as String? ?? (oldPomodoro == true ? 'pomodoro' : 'stopwatch'),
      phase: json['phase'] as String? ?? 'focus',
      focusMinutes: json['focusMinutes'] as int? ?? 25,
      shortBreakMinutes: json['shortBreakMinutes'] as int? ?? 5,
      longBreakMinutes: json['longBreakMinutes'] as int? ?? 15,
      cyclesBeforeLongBreak: json['cyclesBeforeLongBreak'] as int? ?? 4,
      completedCycles: json['completedCycles'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
    );
  }
}

class ActiveTimerStore {
  static const _key = 'active_timer_state_v2';
  static const _legacyKey = 'active_timer_state_v1';

  Future<ActiveTimerState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key) ?? prefs.getString(_legacyKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final state = ActiveTimerState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (!prefs.containsKey(_key)) {
        await save(state);
        await prefs.remove(_legacyKey);
      }
      return state;
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> save(ActiveTimerState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    await prefs.remove(_legacyKey);
  }
}
