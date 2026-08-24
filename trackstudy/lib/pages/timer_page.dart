import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final _notesController = TextEditingController();
  Timer? _timer;
  DateTime? _startedAt;
  DateTime? _segmentStartedAt;
  Duration _accumulated = Duration.zero;
  Duration _elapsed = Duration.zero;
  bool _isActive = false;
  bool _isPaused = false;
  bool _pomodoroEnabled = false;
  int _focusMinutes = 25;
  int? _selectedDisciplineId;

  void _startTimer() {
    if (_selectedDisciplineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma disciplina.')),
      );
      return;
    }
    final now = DateTime.now();
    _startedAt = now;
    _segmentStartedAt = now;
    _accumulated = Duration.zero;
    setState(() {
      _isActive = true;
      _isPaused = false;
      _elapsed = Duration.zero;
    });
    _startTicker();
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final segmentStartedAt = _segmentStartedAt;
      if (!mounted || segmentStartedAt == null || _isPaused) return;
      final elapsed =
          _accumulated + DateTime.now().difference(segmentStartedAt);
      if (_pomodoroEnabled && elapsed.inMinutes >= _focusMinutes) {
        _pauseTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ciclo concluído. Faça uma pausa.')),
        );
        return;
      }
      setState(() => _elapsed = elapsed);
    });
  }

  void _pauseTimer() {
    final segmentStartedAt = _segmentStartedAt;
    if (segmentStartedAt != null && !_isPaused) {
      _accumulated += DateTime.now().difference(segmentStartedAt);
    }
    _timer?.cancel();
    setState(() {
      _elapsed = _accumulated;
      _isPaused = true;
      _segmentStartedAt = null;
    });
  }

  void _resumeTimer() {
    setState(() {
      _segmentStartedAt = DateTime.now();
      _isPaused = false;
    });
    _startTicker();
  }

  Future<void> _stopTimer() async {
    _timer?.cancel();
    final startedAt = _startedAt;
    final disciplineId = _selectedDisciplineId;
    final endedAt = DateTime.now();
    if (startedAt == null || disciplineId == null) return;
    if (!_isPaused && _segmentStartedAt != null) {
      _accumulated += endedAt.difference(_segmentStartedAt!);
    }
    final duration = _accumulated;
    if (duration.inSeconds > 0) {
      final notes = _notesController.text.trim();
      await widget.database.studySessionsDao.insertStudySession(
        StudySessionsCompanion.insert(
          disciplineId: disciplineId,
          startedAt: startedAt,
          endedAt: endedAt,
          durationSeconds: duration.inSeconds,
          notes: Value(notes.isEmpty ? null : notes),
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      _isActive = false;
      _isPaused = false;
      _startedAt = null;
      _segmentStartedAt = null;
      _accumulated = Duration.zero;
      _elapsed = Duration.zero;
      _notesController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          duration.inSeconds > 0
              ? 'Sessão salva com sucesso.'
              : 'Sessão muito curta e não foi salva.',
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cronômetro')),
      body: StreamBuilder<List<Discipline>>(
        stream: widget.database.disciplinesDao.watchAllDisciplines(),
        builder: (context, snapshot) {
          final disciplines = snapshot.data ?? const <Discipline>[];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (disciplines.isEmpty) {
            return const Center(
              child: Text(
                'Cadastre uma disciplina antes de iniciar uma sessão.',
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              DropdownButtonFormField<int>(
                initialValue: _selectedDisciplineId,
                decoration: const InputDecoration(
                  labelText: 'Disciplina',
                  border: OutlineInputBorder(),
                ),
                items: disciplines
                    .map(
                      (discipline) => DropdownMenuItem(
                        value: discipline.id,
                        child: Text(discipline.name),
                      ),
                    )
                    .toList(),
                onChanged: _isActive
                    ? null
                    : (value) => setState(() => _selectedDisciplineId = value),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                enabled: !_isActive,
                decoration: const InputDecoration(
                  labelText: 'O que você vai estudar?',
                  border: OutlineInputBorder(),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Modo Pomodoro'),
                value: _pomodoroEnabled,
                onChanged: _isActive
                    ? null
                    : (value) => setState(() => _pomodoroEnabled = value),
              ),
              if (_pomodoroEnabled)
                DropdownButtonFormField<int>(
                  initialValue: _focusMinutes,
                  decoration: const InputDecoration(labelText: 'Tempo de foco'),
                  items: const [
                    DropdownMenuItem(value: 25, child: Text('25 minutos')),
                    DropdownMenuItem(value: 50, child: Text('50 minutos')),
                  ],
                  onChanged: _isActive
                      ? null
                      : (value) => setState(() => _focusMinutes = value ?? 25),
                ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  _formatDuration(_elapsed),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!_isActive)
                FilledButton.icon(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar'),
                )
              else ...[
                FilledButton.tonalIcon(
                  onPressed: _isPaused ? _resumeTimer : _pauseTimer,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? 'Retomar' : 'Pausar'),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _stopTimer,
                  icon: const Icon(Icons.stop),
                  label: const Text('Encerrar e salvar'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
