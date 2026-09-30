// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disciplines_dao.dart';

// ignore_for_file: type=lint
mixin _$DisciplinesDaoMixin on DatabaseAccessor<AppDatabase> {
  $DisciplinesTable get disciplines => attachedDatabase.disciplines;
  DisciplinesDaoManager get managers => DisciplinesDaoManager(this);
}

class DisciplinesDaoManager {
  final _$DisciplinesDaoMixin _db;
  DisciplinesDaoManager(this._db);
  $$DisciplinesTableTableManager get disciplines =>
      $$DisciplinesTableTableManager(_db.attachedDatabase, _db.disciplines);
}
