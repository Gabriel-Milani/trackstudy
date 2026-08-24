import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/daos/activities_dao.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key, required this.database});

  final AppDatabase database;

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';

  Future<void> _openForm(BuildContext context, {Activity? existing}) async {
    await showDialog<void>(
      context: context,
      builder: (_) =>
          _ActivityFormDialog(database: database, existing: existing),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atividades e prazos')),
      body: StreamBuilder<List<ActivityWithDiscipline>>(
        stream: database.activitiesDao.watchActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final activities = snapshot.data ?? const <ActivityWithDiscipline>[];
          if (activities.isEmpty) {
            return const Center(child: Text('Nenhuma atividade cadastrada.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final item = activities[index];
              final overdue =
                  !item.activity.isCompleted &&
                  item.activity.dueAt.isBefore(DateTime.now());
              return Card(
                child: CheckboxListTile(
                  value: item.activity.isCompleted,
                  onChanged: (value) => database.activitiesDao.updateActivity(
                    item.activity.copyWith(isCompleted: value ?? false),
                  ),
                  title: Text(
                    item.activity.title,
                    style: TextStyle(
                      decoration: item.activity.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    '${item.discipline.name} • ${_date(item.activity.dueAt)} • '
                    '${item.activity.estimatedMinutes} min${overdue ? ' • Atrasada' : ''}',
                    style: overdue
                        ? TextStyle(color: Theme.of(context).colorScheme.error)
                        : null,
                  ),
                  secondary: PopupMenuButton<String>(
                    onSelected: (action) {
                      if (action == 'edit') {
                        _openForm(context, existing: item.activity);
                      } else {
                        database.activitiesDao.deleteActivity(item.activity);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(value: 'delete', child: Text('Excluir')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_task),
        label: const Text('Atividade'),
      ),
    );
  }
}

class _ActivityFormDialog extends StatefulWidget {
  const _ActivityFormDialog({required this.database, this.existing});

  final AppDatabase database;
  final Activity? existing;

  @override
  State<_ActivityFormDialog> createState() => _ActivityFormDialogState();
}

class _ActivityFormDialogState extends State<_ActivityFormDialog> {
  late int? _disciplineId = widget.existing?.disciplineId;
  late DateTime _dueAt = widget.existing?.dueAt ?? DateTime.now();
  late final _titleController = TextEditingController(
    text: widget.existing?.title ?? '',
  );
  late final _minutesController = TextEditingController(
    text: widget.existing?.estimatedMinutes.toString() ?? '',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date != null && mounted) setState(() => _dueAt = date);
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    if (_disciplineId == null || title.isEmpty || minutes < 0) return;
    final existing = widget.existing;
    if (existing == null) {
      await widget.database.activitiesDao.insertActivity(
        ActivitiesCompanion.insert(
          disciplineId: _disciplineId!,
          title: title,
          dueAt: _dueAt,
          estimatedMinutes: Value(minutes),
        ),
      );
    } else {
      await widget.database.activitiesDao.updateActivity(
        existing.copyWith(
          disciplineId: _disciplineId,
          title: title,
          dueAt: _dueAt,
          estimatedMinutes: minutes,
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Nova atividade' : 'Editar atividade',
      ),
      content: StreamBuilder<List<Discipline>>(
        stream: widget.database.disciplinesDao.watchAllDisciplines(),
        builder: (context, snapshot) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _disciplineId,
              decoration: const InputDecoration(labelText: 'Disciplina'),
              items: (snapshot.data ?? const <Discipline>[])
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _disciplineId = value),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Atividade'),
            ),
            TextField(
              controller: _minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tempo estimado (min)',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Prazo'),
              subtitle: Text(_dueAt.toString().substring(0, 10)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDueDate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Salvar')),
      ],
    );
  }
}
