import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/active_timer_store.dart';
import 'package:trackstudy/services/external_file_service.dart';
import 'package:trackstudy/services/storage/file_storage.dart';

class BackupPreview {
  const BackupPreview({
    required this.createdAt,
    required this.disciplines,
    required this.activities,
    required this.sessions,
  });

  final DateTime? createdAt;
  final int disciplines;
  final int activities;
  final int sessions;
}

class BackupService {
  BackupService(this.database);

  final AppDatabase database;
  static const fileName = 'trackstudy_backup.json';

  Future<Map<String, Object?>> _payload() async {
    final disciplines = await database.disciplinesDao.getAllDisciplines();
    final activities = await database.activitiesDao.watchActivities().first;
    final sessions = await database.studySessionsDao.getAllStudySessions();
    return <String, Object?>{
      'formatVersion': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'disciplines': [
        for (final d in disciplines)
          {
            'id': d.id,
            'name': d.name,
            'weeklyGoalMinutes': d.weeklyGoalMinutes,
            'category': d.category,
          },
      ],
      'activities': [
        for (final item in activities)
          {
            'id': item.activity.id,
            'disciplineId': item.activity.disciplineId,
            'title': item.activity.title,
            'dueAt': item.activity.dueAt.toIso8601String(),
            'estimatedMinutes': item.activity.estimatedMinutes,
            'isCompleted': item.activity.isCompleted,
          },
      ],
      'sessions': [
        for (final s in sessions)
          {
            'id': s.id,
            'disciplineId': s.disciplineId,
            'startedAt': s.startedAt.toIso8601String(),
            'endedAt': s.endedAt.toIso8601String(),
            'durationSeconds': s.durationSeconds,
            'notes': s.notes,
          },
      ],
    };
  }

  List<int> _encode(Map<String, Object?> payload) =>
      utf8.encode(const JsonEncoder.withIndent('  ').convert(payload));

  Future<String> createBackup() async {
    return writeAppFile(fileName, _encode(await _payload()));
  }

  Future<String?> exportBackup() async {
    final now = DateTime.now();
    final stamp = '${now.year}${_two(now.month)}${_two(now.day)}_${_two(now.hour)}${_two(now.minute)}';
    return ExternalFileService.saveBytes(
      suggestedName: 'trackstudy_backup_$stamp.json',
      bytes: _encode(await _payload()),
      allowedExtensions: const ['json'],
    );
  }

  Future<List<int>?> pickBackupFile() => ExternalFileService.pickJsonBytes();

  BackupPreview preview(List<int> bytes) {
    final payload = _decodeAndValidate(bytes);
    return BackupPreview(
      createdAt: DateTime.tryParse(payload['createdAt'] as String? ?? ''),
      disciplines: (payload['disciplines'] as List<dynamic>).length,
      activities: (payload['activities'] as List<dynamic>).length,
      sessions: (payload['sessions'] as List<dynamic>).length,
    );
  }

  Future<bool> restoreLatestBackup() async {
    final bytes = await readAppFile(fileName);
    if (bytes == null) return false;
    await restoreBytes(bytes);
    return true;
  }

  Future<void> restoreBytes(List<int> bytes) async {
    final payload = _decodeAndValidate(bytes);
    // Cria uma cópia interna do estado atual antes de qualquer substituição.
    await writeAppFile('trackstudy_pre_restore_backup.json', _encode(await _payload()));
    await ActiveTimerStore().clear();

    final disciplines = payload['disciplines'] as List<dynamic>;
    final activities = payload['activities'] as List<dynamic>;
    final sessions = payload['sessions'] as List<dynamic>;

    await database.transaction(() async {
      await database.delete(database.studySessions).go();
      await database.delete(database.activities).go();
      await database.delete(database.disciplines).go();

      for (final raw in disciplines) {
        final d = raw as Map<String, dynamic>;
        await database.into(database.disciplines).insert(
          DisciplinesCompanion.insert(
            id: Value(d['id'] as int),
            name: d['name'] as String,
            weeklyGoalMinutes: d['weeklyGoalMinutes'] as int,
            category: Value(d['category'] as String? ?? 'outras'),
          ),
        );
      }
      for (final raw in activities) {
        final a = raw as Map<String, dynamic>;
        await database.into(database.activities).insert(
          ActivitiesCompanion.insert(
            id: Value(a['id'] as int),
            disciplineId: a['disciplineId'] as int,
            title: a['title'] as String,
            dueAt: DateTime.parse(a['dueAt'] as String),
            estimatedMinutes: Value(a['estimatedMinutes'] as int? ?? 0),
            isCompleted: Value(a['isCompleted'] as bool? ?? false),
          ),
        );
      }
      for (final raw in sessions) {
        final s = raw as Map<String, dynamic>;
        await database.into(database.studySessions).insert(
          StudySessionsCompanion.insert(
            id: Value(s['id'] as int),
            disciplineId: s['disciplineId'] as int,
            startedAt: DateTime.parse(s['startedAt'] as String),
            endedAt: DateTime.parse(s['endedAt'] as String),
            durationSeconds: s['durationSeconds'] as int,
            notes: Value(s['notes'] as String?),
          ),
        );
      }
    });
  }

  Map<String, dynamic> _decodeAndValidate(List<int> bytes) {
    final decoded = jsonDecode(utf8.decode(bytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Arquivo de backup inválido.');
    }
    if (decoded['formatVersion'] != 1) {
      throw const FormatException('Versão de backup não suportada.');
    }
    for (final key in ['disciplines', 'activities', 'sessions']) {
      if (decoded[key] is! List<dynamic>) {
        throw FormatException('Backup inválido: campo $key ausente.');
      }
    }
    return decoded;
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
