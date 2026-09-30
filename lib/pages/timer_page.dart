import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/active_timer_store.dart';
import 'package:trackstudy/services/notification_service.dart';
import 'package:trackstudy/widgets/dashboard_widgets.dart';

enum TimerMode { stopwatch, pomodoro }
enum PomodoroPhase { focus, shortBreak, longBreak }

class TimerPage extends StatefulWidget {
  const TimerPage({super.key, required this.database, this.initialDisciplineId});
  final AppDatabase database;
  final int? initialDisciplineId;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with WidgetsBindingObserver {
  static const _anomalyThreshold = Duration(hours: 4);
  final _notesController = TextEditingController();
  final _store = ActiveTimerStore();
  Timer? _ticker;
  Timer? _notesDebounce;

  DateTime? _startedAt;
  DateTime? _segmentStartedAt;
  Duration _studyAccumulated = Duration.zero;
  Duration _phaseAccumulated = Duration.zero;
  Duration _displayElapsed = Duration.zero;
  bool _isActive = false;
  bool _isPaused = false;
  bool _restoring = true;
  int? _selectedDisciplineId;
  TimerMode _mode = TimerMode.stopwatch;
  PomodoroPhase _phase = PomodoroPhase.focus;
  int _focusMinutes = 25;
  int _shortBreakMinutes = 5;
  int _longBreakMinutes = 15;
  int _cyclesBeforeLongBreak = 4;
  int _completedCycles = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedDisciplineId = widget.initialDisciplineId;
    _notesController.addListener(_scheduleNotesPersist);
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final saved = await _store.load();
    if (!mounted) return;
    if (saved == null) {
      setState(() => _restoring = false);
      return;
    }
    final disciplines = await widget.database.disciplinesDao.getAllDisciplines();
    if (!disciplines.any((d) => d.id == saved.disciplineId)) {
      await _store.clear();
      if (!mounted) return;
      setState(() => _restoring = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A sessão recuperada apontava para uma disciplina removida e foi descartada.')),
          );
        }
      });
      return;
    }

    final segmentGap = !saved.isPaused && saved.segmentStartedAt != null
        ? DateTime.now().difference(saved.segmentStartedAt!)
        : Duration.zero;
    setState(() {
      _selectedDisciplineId = saved.disciplineId;
      _startedAt = saved.startedAt;
      _segmentStartedAt = saved.isPaused ? null : saved.segmentStartedAt;
      _studyAccumulated = Duration(seconds: saved.studySeconds);
      _phaseAccumulated = Duration(seconds: saved.phaseSeconds);
      _isActive = true;
      _isPaused = saved.isPaused;
      _mode = saved.mode == 'pomodoro' ? TimerMode.pomodoro : TimerMode.stopwatch;
      _phase = _phaseFromString(saved.phase);
      _focusMinutes = saved.focusMinutes;
      _shortBreakMinutes = saved.shortBreakMinutes;
      _longBreakMinutes = saved.longBreakMinutes;
      _cyclesBeforeLongBreak = saved.cyclesBeforeLongBreak;
      _completedCycles = saved.completedCycles;
      _notesController.text = saved.notes;
      _restoring = false;
    });

    if (!saved.isPaused && segmentGap > _anomalyThreshold) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _resolveLongGap(segmentGap));
    } else if (!saved.isPaused) {
      _segmentStartedAt = saved.segmentStartedAt ?? DateTime.now();
      _startTicker();
    } else {
      _updateDisplay();
    }
  }

  PomodoroPhase _phaseFromString(String value) => switch (value) {
        'shortBreak' => PomodoroPhase.shortBreak,
        'longBreak' => PomodoroPhase.longBreak,
        _ => PomodoroPhase.focus,
      };

  String get _phaseKey => switch (_phase) {
        PomodoroPhase.focus => 'focus',
        PomodoroPhase.shortBreak => 'shortBreak',
        PomodoroPhase.longBreak => 'longBreak',
      };

  Future<void> _resolveLongGap(Duration gap) async {
    if (!mounted) return;
    final decision = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Sessão muito longa detectada'),
        content: Text(
          'O TrackStudy ficou fechado por ${_durationLabel(gap)} com uma sessão ativa. '
          'Escolha se esse intervalo deve contar como estudo.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, 'discard'), child: const Text('Descartar sessão')),
          TextButton(onPressed: () => Navigator.pop(context, 'ignore'), child: const Text('Não contar intervalo')),
          FilledButton(onPressed: () => Navigator.pop(context, 'count'), child: const Text('Contar intervalo')),
        ],
      ),
    );
    if (!mounted) return;
    if (decision == 'discard') {
      await _discardTimer();
      return;
    }
    if (decision == 'count') {
      _applyRunningDelta(gap);
    }
    setState(() {
      _segmentStartedAt = DateTime.now();
      _isPaused = false;
    });
    await _persistSession();
    _startTicker();
  }

  void _scheduleNotesPersist() {
    if (!_isActive) return;
    _notesDebounce?.cancel();
    _notesDebounce = Timer(const Duration(milliseconds: 500), _persistSession);
  }

  Future<void> _persistSession() async {
    if (!_isActive || _selectedDisciplineId == null || _startedAt == null) {
      await _store.clear();
      return;
    }
    await _store.save(ActiveTimerState(
      disciplineId: _selectedDisciplineId!,
      startedAt: _startedAt!,
      segmentStartedAt: _isPaused ? null : _segmentStartedAt,
      studySeconds: _studyAccumulated.inSeconds,
      phaseSeconds: _phaseAccumulated.inSeconds,
      isPaused: _isPaused,
      mode: _mode == TimerMode.pomodoro ? 'pomodoro' : 'stopwatch',
      phase: _phaseKey,
      focusMinutes: _focusMinutes,
      shortBreakMinutes: _shortBreakMinutes,
      longBreakMinutes: _longBreakMinutes,
      cyclesBeforeLongBreak: _cyclesBeforeLongBreak,
      completedCycles: _completedCycles,
      notes: _notesController.text.trim(),
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      _persistSession();
    }
  }

  Future<void> _startTimer() async {
    if (_selectedDisciplineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione uma disciplina.')));
      return;
    }
    final now = DateTime.now();
    setState(() {
      _startedAt = now;
      _segmentStartedAt = now;
      _studyAccumulated = Duration.zero;
      _phaseAccumulated = Duration.zero;
      _displayElapsed = Duration.zero;
      _isActive = true;
      _isPaused = false;
      _phase = PomodoroPhase.focus;
      _completedCycles = 0;
    });
    await _persistSession();
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _tick();
  }

  Future<void> _tick() async {
    if (!mounted || _isPaused || _segmentStartedAt == null) return;
    _updateDisplay();
    if (_mode == TimerMode.pomodoro && _currentPhaseElapsed >= _currentPhaseTarget) {
      await _completePomodoroPhase();
    }
  }

  Duration get _currentRunningDelta => _segmentStartedAt == null
      ? Duration.zero
      : DateTime.now().difference(_segmentStartedAt!);

  Duration get _currentPhaseElapsed => _phaseAccumulated + (_isPaused ? Duration.zero : _currentRunningDelta);

  Duration get _currentPhaseTarget => Duration(minutes: switch (_phase) {
        PomodoroPhase.focus => _focusMinutes,
        PomodoroPhase.shortBreak => _shortBreakMinutes,
        PomodoroPhase.longBreak => _longBreakMinutes,
      });

  void _updateDisplay() {
    if (!mounted) return;
    setState(() {
      _displayElapsed = _mode == TimerMode.stopwatch
          ? _studyAccumulated + (_isPaused ? Duration.zero : _currentRunningDelta)
          : _currentPhaseElapsed;
    });
  }

  void _applyRunningDelta(Duration delta) {
    _phaseAccumulated += delta;
    if (_mode == TimerMode.stopwatch || _phase == PomodoroPhase.focus) {
      _studyAccumulated += delta;
    }
  }

  Future<void> _pauseTimer() async {
    if (!_isPaused && _segmentStartedAt != null) {
      _applyRunningDelta(DateTime.now().difference(_segmentStartedAt!));
    }
    _ticker?.cancel();
    setState(() {
      _isPaused = true;
      _segmentStartedAt = null;
      _updateDisplayWithoutSetState();
    });
    await _persistSession();
  }

  void _updateDisplayWithoutSetState() {
    _displayElapsed = _mode == TimerMode.stopwatch ? _studyAccumulated : _phaseAccumulated;
  }

  Future<void> _resumeTimer() async {
    setState(() {
      _segmentStartedAt = DateTime.now();
      _isPaused = false;
    });
    await _persistSession();
    _startTicker();
  }

  Future<void> _completePomodoroPhase() async {
    final delta = _currentRunningDelta;
    _applyRunningDelta(delta);
    final disciplines = await widget.database.disciplinesDao.getAllDisciplines();
    var disciplineName = 'Estudos';
    for (final discipline in disciplines) {
      if (discipline.id == _selectedDisciplineId) {
        disciplineName = discipline.name;
        break;
      }
    }

    if (_phase == PomodoroPhase.focus) {
      _completedCycles++;
      await NotificationService.instance.showFocusComplete(discipline: disciplineName);
      final longBreak = _completedCycles % _cyclesBeforeLongBreak == 0;
      setState(() {
        _phase = longBreak ? PomodoroPhase.longBreak : PomodoroPhase.shortBreak;
        _phaseAccumulated = Duration.zero;
        _segmentStartedAt = DateTime.now();
      });
    } else {
      await NotificationService.instance.showBreakComplete();
      setState(() {
        _phase = PomodoroPhase.focus;
        _phaseAccumulated = Duration.zero;
        _segmentStartedAt = DateTime.now();
      });
    }
    await _persistSession();
    _updateDisplay();
  }

  Future<void> _discardTimer() async {
    _ticker?.cancel();
    await _store.clear();
    if (!mounted) return;
    setState(() {
      _isActive = false;
      _isPaused = false;
      _startedAt = null;
      _segmentStartedAt = null;
      _studyAccumulated = Duration.zero;
      _phaseAccumulated = Duration.zero;
      _displayElapsed = Duration.zero;
      _completedCycles = 0;
      _notesController.clear();
    });
  }

  Future<void> _confirmDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Descartar sessão?'),
        content: const Text('O tempo desta sessão não será salvo no histórico.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Descartar')),
        ],
      ),
    );
    if (discard == true) await _discardTimer();
  }

  Future<void> _stopTimer() async {
    _ticker?.cancel();
    final startedAt = _startedAt;
    final disciplineId = _selectedDisciplineId;
    if (startedAt == null || disciplineId == null) return;
    final disciplines = await widget.database.disciplinesDao.getAllDisciplines();
    if (!disciplines.any((d) => d.id == disciplineId)) {
      await _store.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A disciplina desta sessão não existe mais. A sessão foi descartada.')));
      await _discardTimer();
      return;
    }
    final endedAt = DateTime.now();
    if (!_isPaused && _segmentStartedAt != null) {
      _applyRunningDelta(endedAt.difference(_segmentStartedAt!));
    }
    final duration = _studyAccumulated;
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
    await _store.clear();
    if (!mounted) return;
    setState(() {
      _isActive = false;
      _isPaused = false;
      _startedAt = null;
      _segmentStartedAt = null;
      _studyAccumulated = Duration.zero;
      _phaseAccumulated = Duration.zero;
      _displayElapsed = Duration.zero;
      _completedCycles = 0;
      _notesController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(duration.inSeconds > 0 ? 'Sessão salva com sucesso.' : 'Sessão muito curta e não foi salva.')));
  }

  String _durationLabel(Duration value) {
    final h = value.inHours;
    final m = value.inMinutes.remainder(60);
    return h > 0 ? '${h}h ${m}min' : '${value.inMinutes} min';
  }

  String get _phaseLabel => switch (_phase) {
        PomodoroPhase.focus => 'Foco',
        PomodoroPhase.shortBreak => 'Pausa curta',
        PomodoroPhase.longBreak => 'Pausa longa',
      };

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _notesDebounce?.cancel();
    _persistSession();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_restoring) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: const AppHeaderBar(icon: Icons.timer_rounded, title: 'Cronômetro', subtitle: 'Mantenha o foco. Cada minuto conta.'),
      body: StreamBuilder<List<Discipline>>(
        stream: widget.database.disciplinesDao.watchAllDisciplines(),
        builder: (context, snapshot) {
          final disciplines = snapshot.data ?? const <Discipline>[];
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const Center(child: Text('Não foi possível carregar as disciplinas.'));
          if (disciplines.isEmpty) return const Center(child: Text('Cadastre uma disciplina antes de iniciar uma sessão.'));
          final validSelection = disciplines.any((d) => d.id == _selectedDisciplineId);
          if (!validSelection && !_isActive) _selectedDisciplineId = null;

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (_isActive)
                Card(
                  child: ListTile(
                    leading: Icon(_mode == TimerMode.pomodoro ? Icons.center_focus_strong : Icons.restore_rounded),
                    title: Text(_mode == TimerMode.pomodoro ? '$_phaseLabel • ciclo ${_completedCycles + 1}' : (_isPaused ? 'Sessão pausada' : 'Sessão ativa')),
                    subtitle: Text(_mode == TimerMode.pomodoro
                        ? 'Tempo estudado nesta sessão: ${_durationLabel(_studyAccumulated)}'
                        : 'O progresso é salvo automaticamente.'),
                  ),
                ),
              DropdownButtonFormField<int>(
                initialValue: validSelection ? _selectedDisciplineId : null,
                decoration: const InputDecoration(labelText: 'Disciplina', border: OutlineInputBorder()),
                items: disciplines.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name))).toList(),
                onChanged: _isActive ? null : (value) => setState(() => _selectedDisciplineId = value),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Anotações da sessão', border: OutlineInputBorder(), helperText: 'Pode editar durante o estudo; o texto é salvo automaticamente.'),
              ),
              const SizedBox(height: 12),
              SegmentedButton<TimerMode>(
                segments: const [
                  ButtonSegment(value: TimerMode.stopwatch, icon: Icon(Icons.timer_outlined), label: Text('Livre')),
                  ButtonSegment(value: TimerMode.pomodoro, icon: Icon(Icons.center_focus_strong), label: Text('Pomodoro')),
                ],
                selected: {_mode},
                onSelectionChanged: _isActive ? null : (value) => setState(() => _mode = value.first),
              ),
              if (_mode == TimerMode.pomodoro && !_isActive) ...[
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _numberField('Foco', _focusMinutes, (v) => _focusMinutes = v, const [15, 25, 30, 50])),
                  const SizedBox(width: 8),
                  Expanded(child: _numberField('Pausa', _shortBreakMinutes, (v) => _shortBreakMinutes = v, const [5, 10])),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: _numberField('Pausa longa', _longBreakMinutes, (v) => _longBreakMinutes = v, const [10, 15, 20, 30])),
                  const SizedBox(width: 8),
                  Expanded(child: _numberField('Ciclos', _cyclesBeforeLongBreak, (v) => _cyclesBeforeLongBreak = v, const [2, 3, 4, 5])),
                ]),
              ],
              const SizedBox(height: 24),
              if (_mode == TimerMode.pomodoro && _isActive) ...[
                Center(child: Text(_phaseLabel, style: Theme.of(context).textTheme.titleLarge)),
                const SizedBox(height: 4),
                Center(child: Text('Meta da fase: ${_durationLabel(_currentPhaseTarget)}')),
                const SizedBox(height: 8),
              ],
              TimerDisplay(elapsed: _displayElapsed, isLive: _isActive && !_isPaused),
              const SizedBox(height: 24),
              if (!_isActive)
                SizedBox(width: double.infinity, height: 56, child: FilledButton.icon(onPressed: _startTimer, icon: const Icon(Icons.play_arrow), label: const Text('Iniciar')))
              else ...[
                SizedBox(width: double.infinity, height: 56, child: FilledButton.tonalIcon(onPressed: _isPaused ? _resumeTimer : _pauseTimer, icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause), label: Text(_isPaused ? 'Retomar' : 'Pausar'))),
                const SizedBox(height: 10),
                SizedBox(width: double.infinity, height: 56, child: FilledButton.icon(onPressed: _stopTimer, icon: const Icon(Icons.stop), label: const Text('Encerrar e salvar'))),
                TextButton.icon(onPressed: _confirmDiscard, icon: const Icon(Icons.delete_outline), label: const Text('Descartar sessão')),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _numberField(String label, int current, ValueChanged<int> onChanged, List<int> values) {
    return DropdownButtonFormField<int>(
      initialValue: current,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: values.map((v) => DropdownMenuItem(value: v, child: Text('$v min'.replaceAll(' min', label == 'Ciclos' ? '' : ' min')))).toList(),
      onChanged: (value) { if (value != null) setState(() => onChanged(value)); },
    );
  }
}

