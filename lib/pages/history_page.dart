import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/daos/study_sessions_dao.dart';
import 'package:trackstudy/theme/app_colors.dart';
import 'package:trackstudy/theme/discipline_category.dart';
import 'package:trackstudy/widgets/dashboard_widgets.dart';

enum HistoryPeriod { all, today, week, month }

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  AppDatabase get database => widget.database;
  HistoryPeriod _period = HistoryPeriod.all;
  int? _disciplineId;
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _periodLabel(HistoryPeriod period) => switch (period) {
        HistoryPeriod.all => 'Tudo',
        HistoryPeriod.today => 'Hoje',
        HistoryPeriod.week => '7 dias',
        HistoryPeriod.month => '30 dias',
      };

  bool _matchesPeriod(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(date.year, date.month, date.day);
    return switch (_period) {
      HistoryPeriod.all => true,
      HistoryPeriod.today => sessionDay == today,
      HistoryPeriod.week => !sessionDay.isBefore(today.subtract(const Duration(days: 6))),
      HistoryPeriod.month => !sessionDay.isBefore(today.subtract(const Duration(days: 29))),
    };
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _dateAndTime(DateTime date) =>
      '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year} - '
      '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

  String _dayLabel(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return 'Hoje';
    if (day == today.subtract(const Duration(days: 1))) return 'Ontem';
    return '${_twoDigits(day.day)}/${_twoDigits(day.month)}/${day.year}';
  }

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
        actionsAlignment: MainAxisAlignment.center,
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
      appBar: AppHeaderBar(
        icon: Icons.history_rounded,
        title: 'Histórico',
        subtitle: 'Acompanhe suas últimas sessões de estudo.',
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
          final allSessions =
              snapshot.data ?? const <StudySessionWithDiscipline>[];
          if (allSessions.isEmpty) {
            return const Center(child: Text('Nenhuma sessão registrada.'));
          }
          final disciplineMap = <int, Discipline>{
            for (final item in allSessions) item.discipline.id: item.discipline,
          };
          final sessions = allSessions
              .where(
                (item) =>
                    (_disciplineId == null || item.discipline.id == _disciplineId) &&
                    _matchesPeriod(item.session.startedAt) &&
                    (_search.isEmpty ||
                        item.discipline.name.toLowerCase().contains(_search) ||
                        (item.session.notes ?? '').toLowerCase().contains(_search)),
              )
              .toList();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<HistoryPeriod>(
                        initialValue: _period,
                        decoration: const InputDecoration(
                          labelText: 'Período',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: HistoryPeriod.values
                            .map(
                              (period) => DropdownMenuItem(
                                value: period,
                                child: Text(_periodLabel(period)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _period = value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _disciplineId ?? 0,
                        decoration: const InputDecoration(
                          labelText: 'Disciplina',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem<int>(
                            value: 0,
                            child: Text('Todas'),
                          ),
                          ...disciplineMap.values.map(
                            (discipline) => DropdownMenuItem<int>(
                              value: discipline.id,
                              child: Text(
                                discipline.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) => setState(
                          () => _disciplineId = value == 0 ? null : value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar disciplina ou anotação',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _search.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _search = '');
                            },
                            icon: const Icon(Icons.clear),
                          ),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) => setState(() => _search = value.trim().toLowerCase()),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: sessions.isEmpty
                    ? const Center(child: Text('Nenhuma sessão neste filtro.'))
                    : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final item = sessions[index];
              final category = DisciplineCategory.fromKey(
                item.discipline.category,
              );
              final bg =
                  AppColors.disciplineBg[category.colorIndex %
                      AppColors.disciplineBg.length];
              final fg =
                  AppColors.disciplineFg[category.colorIndex %
                      AppColors.disciplineFg.length];
              final day = DateTime(item.session.startedAt.year, item.session.startedAt.month, item.session.startedAt.day);
              final previousDay = index == 0
                  ? null
                  : DateTime(sessions[index - 1].session.startedAt.year, sessions[index - 1].session.startedAt.month, sessions[index - 1].session.startedAt.day);
              final showHeader = previousDay == null || previousDay != day;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
                      child: Text(_dayLabel(day), style: Theme.of(context).textTheme.titleSmall),
                    ),
                  Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(category.icon, color: fg, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.discipline.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                Text(_duration(item.session.durationSeconds)),
                              ],
                            ),
                            Text(
                              '${category.label} • Meta semanal: ${item.discipline.weeklyGoalMinutes} min',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(_dateAndTime(item.session.startedAt)),
                            if (item.session.notes?.isNotEmpty == true)
                              Text(
                                item.session.notes!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SoftIconButton(
                                  icon: Icons.edit_rounded,
                                  tooltip: 'Editar',
                                  background: AppColors.disciplineBg[0],
                                  iconColor: AppColors.disciplineFg[0],
                                  onTap: () =>
                                      _openForm(context, existing: item),
                                ),
                                const SizedBox(width: 6),
                                SoftIconButton(
                                  icon: Icons.delete_outline_rounded,
                                  tooltip: 'Excluir',
                                  background: const Color(0xFFFEE2E2),
                                  iconColor: AppColors.alert,
                                  onTap: () => _delete(context, item.session),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                  ),
                ],
              );
            },
          ),
              ),
            ],
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
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        // Força formato 24h (07:55, 19:55) e some com o seletor AM/PM.
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
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
    if (_disciplineId == null || minutes == null || minutes <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma disciplina e informe uma duração maior que zero.'),
        ),
      );
      return;
    }
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
