import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/daos/study_sessions_dao.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.database});

  final AppDatabase database;

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _dateAndTime(DateTime date) =>
      '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} - '
      '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

  String _duration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}min';
    return minutes > 0 ? '$minutes min' : '${duration.inSeconds} s';
  }

  Future<void> _openForm(
    BuildContext context, {
    StudySessionWithDiscipline? existing,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (_) =>
          _SessionFormDialog(database: database, existing: existing),
    );
  }

  Future<void> _delete(BuildContext context, StudySession session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir sessão?'),
        content: const Text('Essa ação removerá a sessão dos relatórios.'),
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
      await database.studySessionsDao.deleteStudySession(session);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(
            tooltip: 'Registrar sessão manualmente',
            onPressed: () => _openForm(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<List<StudySessionWithDiscipline>>(
        stream: database.studySessionsDao.watchSessionsWithDiscipline(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Não foi possível carregar o histórico.'),
            );
          }
          final sessions =
              snapshot.data ?? const <StudySessionWithDiscipline>[];
          if (sessions.isEmpty) {
            return const Center(child: Text('Nenhuma sessão registrada.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = sessions[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(item.discipline.name),
                subtitle: Text(
                  [
                    _dateAndTime(item.session.startedAt),
                    if (item.session.notes?.isNotEmpty == true)
                      item.session.notes!,
                  ].join('\n'),
                ),
                isThreeLine: item.session.notes?.isNotEmpty == true,
                trailing: PopupMenuButton<String>(
                  onSelected: (action) {
                    if (action == 'edit') {
                      _openForm(context, existing: item);
                    } else {
                      _delete(context, item.session);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'duration',
                      enabled: false,
                      child: Text(_duration(item.session.durationSeconds)),
                    ),
                    const PopupMenuItem(value: 'edit', child: Text('Editar')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Sessão manual'),
      ),
    );
  }
}

class _SessionFormDialog extends StatefulWidget {
  const _SessionFormDialog({required this.database, this.existing});

  final AppDatabase database;
  final StudySessionWithDiscipline? existing;

  @override
  State<_SessionFormDialog> createState() => _SessionFormDialogState();
}

class _SessionFormDialogState extends State<_SessionFormDialog> {
  late int? _disciplineId = widget.existing?.discipline.id;
  late DateTime _startedAt =
      widget.existing?.session.startedAt ?? DateTime.now();
  late final TextEditingController _minutesController = TextEditingController(
    text: widget.existing == null
        ? ''
        : (widget.existing!.session.durationSeconds ~/ 60).toString(),
  );
  late final TextEditingController _notesController = TextEditingController(
    text: widget.existing?.session.notes ?? '',
  );

  @override
  void dispose() {
    _minutesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startedAt),
    );
    if (time == null || !mounted) return;
    setState(() {
      _startedAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final minutes = int.tryParse(_minutesController.text);
    if (_disciplineId == null || minutes == null || minutes <= 0) return;
    final endedAt = _startedAt.add(Duration(minutes: minutes));
    final notes = _notesController.text.trim();
    final existing = widget.existing?.session;
    if (existing == null) {
      await widget.database.studySessionsDao.insertStudySession(
        StudySessionsCompanion.insert(
          disciplineId: _disciplineId!,
          startedAt: _startedAt,
          endedAt: endedAt,
          durationSeconds: minutes * 60,
          notes: Value(notes.isEmpty ? null : notes),
        ),
      );
    } else {
      await widget.database.studySessionsDao.updateStudySession(
        existing.copyWith(
          disciplineId: _disciplineId,
          startedAt: _startedAt,
          endedAt: endedAt,
          durationSeconds: minutes * 60,
          notes: Value(notes.isEmpty ? null : notes),
        ),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Registrar sessão' : 'Editar sessão',
      ),
      content: SizedBox(
        width: 400,
        child: StreamBuilder<List<Discipline>>(
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
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duração em minutos',
                ),
              ),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Observação'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data e hora de início'),
                subtitle: Text(_startedAt.toString().substring(0, 16)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
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
