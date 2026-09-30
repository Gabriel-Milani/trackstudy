import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/daos/activities_dao.dart';
import 'package:trackstudy/theme/app_colors.dart';
import 'package:trackstudy/widgets/dashboard_widgets.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key, required this.database});

  final AppDatabase database;

  String _date(DateTime value) =>
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';

  bool _isOverdue(Activity activity) {
    if (activity.isCompleted) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(activity.dueAt.year, activity.dueAt.month, activity.dueAt.day);
    return due.isBefore(today);
  }

  Future<void> _openForm(BuildContext context, {Activity? existing}) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _ActivityFormDialog(database: database, existing: existing),
    );
  }

  Future<void> _delete(BuildContext context, Activity activity) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir atividade?'),
        content: Text('A atividade "${activity.title}" será removida permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await database.activitiesDao.deleteActivity(activity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderBar(
        icon: Icons.checklist_rounded,
        title: 'Atividades e prazos',
        subtitle: 'Organize suas entregas e nunca perca um prazo.',
      ),
      body: StreamBuilder<List<ActivityWithDiscipline>>(
        stream: database.activitiesDao.watchActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Não foi possível carregar as atividades.'));
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
              final overdue = _isOverdue(item.activity);
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
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SoftIconButton(
                        icon: Icons.edit_rounded,
                        tooltip: 'Editar',
                        background: AppColors.disciplineBg[0],
                        iconColor: AppColors.disciplineFg[0],
                        onTap: () => _openForm(context, existing: item.activity),
                      ),
                      const SizedBox(width: 6),
                      SoftIconButton(
                        icon: Icons.delete_outline_rounded,
                        tooltip: 'Excluir',
                        background: const Color(0xFFFEE2E2),
                        iconColor: AppColors.alert,
                        onTap: () => _delete(context, item.activity),
                      ),
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
  final _formKey = GlobalKey<FormState>();
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
    if (date != null && mounted) {
      setState(() => _dueAt = DateTime(date.year, date.month, date.day));
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final title = _titleController.text.trim();
    final minutes = int.parse(_minutesController.text.trim());
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
      title: Text(widget.existing == null ? 'Nova atividade' : 'Editar atividade'),
      content: Form(
        key: _formKey,
        child: StreamBuilder<List<Discipline>>(
          stream: widget.database.disciplinesDao.watchAllDisciplines(),
          builder: (context, snapshot) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: _disciplineId,
                decoration: const InputDecoration(labelText: 'Disciplina'),
                validator: (value) => value == null ? 'Selecione uma disciplina.' : null,
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
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Atividade'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Informe o nome da atividade.'
                    : null,
              ),
              TextFormField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tempo estimado (min)'),
                validator: (value) {
                  final minutes = int.tryParse(value?.trim() ?? '');
                  if (minutes == null) return 'Informe um número válido.';
                  if (minutes <= 0) return 'Informe um tempo maior que zero.';
                  return null;
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Prazo'),
                subtitle: Text(
                  '${_dueAt.day.toString().padLeft(2, '0')}/'
                  '${_dueAt.month.toString().padLeft(2, '0')}/${_dueAt.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDueDate,
              ),
            ],
          ),
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
