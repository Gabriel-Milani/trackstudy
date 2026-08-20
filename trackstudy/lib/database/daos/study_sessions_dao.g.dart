// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_sessions_dao.dart';

// ignore_for_file: type=lint
mixin _$StudySessionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DisciplinesTable get disciplines => attachedDatabase.disciplines;
  $StudySessionsTable get studySessions => attachedDatabase.studySessions;
  StudySessionsDaoManager get managers => StudySessionsDaoManager(this);
}

class StudySessionsDaoManager {
  final _$StudySessionsDaoMixin _db;
  StudySessionsDaoManager(this._db);
  $$DisciplinesTableTableManager get disciplines =>
      $$DisciplinesTableTableManager(_db.attachedDatabase, _db.disciplines);
  $$StudySessionsTableTableManager get studySessions =>
      $$StudySessionsTableTableManager(_db.attachedDatabase, _db.studySessions);
}
