import 'package:drift/drift.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/tables/activities_table.dart';
import 'package:trackstudy/database/tables/disciplines_table.dart';

part 'activities_dao.g.dart';

@DriftAccessor(tables: [Activities, Disciplines])
class ActivitiesDao extends DatabaseAccessor<AppDatabase>
    with _$ActivitiesDaoMixin {
  ActivitiesDao(super.attachedDatabase);

  Stream<List<ActivityWithDiscipline>> watchActivities() {
    final query =
        select(activities).join([
          innerJoin(
            disciplines,
            disciplines.id.equalsExp(activities.disciplineId),
          ),
        ])..orderBy([
          OrderingTerm.asc(activities.isCompleted),
          OrderingTerm.asc(activities.dueAt),
        ]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => ActivityWithDiscipline(
              activity: row.readTable(activities),
              discipline: row.readTable(disciplines),
            ),
          )
          .toList(),
    );
  }

  Future<List<Activity>> getPendingActivitiesByDiscipline(int disciplineId) {
    return (select(activities)
          ..where(
            (activity) =>
                activity.disciplineId.equals(disciplineId) &
                activity.isCompleted.equals(false),
          )
          ..orderBy([(activity) => OrderingTerm.asc(activity.dueAt)]))
        .get();
  }

  Future<int> insertActivity(ActivitiesCompanion activity) =>
      into(activities).insert(activity);

  Future<bool> updateActivity(Activity activity) =>
      update(activities).replace(activity);

  Future<int> deleteActivity(Activity activity) =>
      delete(activities).delete(activity);
}

class ActivityWithDiscipline {
  const ActivityWithDiscipline({
    required this.activity,
    required this.discipline,
  });

  final Activity activity;
  final Discipline discipline;
}
