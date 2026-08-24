import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/priority_service.dart';
import 'package:trackstudy/services/statistics_service.dart';

enum StatisticsPeriod { currentWeek, currentMonth, allTime, custom }

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  StatisticsPeriod _period = StatisticsPeriod.currentWeek;
  DateTimeRange? _customRange;

  String _periodLabel(StatisticsPeriod period) => switch (period) {
    StatisticsPeriod.currentWeek => 'Semana atual',
    StatisticsPeriod.currentMonth => 'Mês atual',
    StatisticsPeriod.allTime => 'Todo o período',
    StatisticsPeriod.custom => 'Período personalizado',
  };

  ({DateTime? start, DateTime? end}) _selectedInterval() {
    final now = DateTime.now();
    return switch (_period) {
      StatisticsPeriod.currentWeek => (
        start: PriorityService.startOfWeek(now),
        end: PriorityService.startOfWeek(now).add(const Duration(days: 7)),
      ),
      StatisticsPeriod.currentMonth => (
        start: StatisticsService.startOfMonth(now),
        end: DateTime(now.year, now.month + 1),
      ),
      StatisticsPeriod.allTime => (start: null, end: null),
      StatisticsPeriod.custom => (
        start: _customRange == null
            ? null
            : StatisticsService.startOfDay(_customRange!.start),
        end: _customRange == null
            ? null
            : StatisticsService.exclusiveEndOfDay(_customRange!.end),
      ),
    };
  }

  Future<void> _changePeriod(StatisticsPeriod? period) async {
    if (period == null) return;
    if (period == StatisticsPeriod.custom) {
      final now = DateTime.now();
      final range = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: now,
        initialDateRange: _customRange,
      );
      if (range == null || !mounted) return;
      setState(() {
        _period = period;
        _customRange = range;
      });
      return;
    }
    setState(() => _period = period);
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return hours > 0 ? '${hours}h ${minutes}min' : '$minutes min';
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final interval = _selectedInterval();
    final service = StatisticsService(widget.database);
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: FutureBuilder<List<DisciplineStatistics>>(
        future: service.getStatistics(start: interval.start, end: interval.end),
        builder: (context, snapshot) {
          final statistics = snapshot.data ?? const <DisciplineStatistics>[];
          final totalSeconds = statistics.fold<int>(
            0,
            (total, item) => total + item.totalSeconds,
          );
          final maxSeconds = statistics.fold<int>(
            0,
            (maximum, item) =>
                item.totalSeconds > maximum ? item.totalSeconds : maximum,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<StatisticsPeriod>(
                initialValue: _period,
                decoration: const InputDecoration(
                  labelText: 'Período',
                  border: OutlineInputBorder(),
                ),
                items: StatisticsPeriod.values
                    .map(
                      (period) => DropdownMenuItem(
                        value: period,
                        child: Text(_periodLabel(period)),
                      ),
                    )
                    .toList(),
                onChanged: _changePeriod,
              ),
              if (_customRange != null && _period == StatisticsPeriod.custom)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${_formatDate(_customRange!.start)} a '
                    '${_formatDate(_customRange!.end)}',
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Tempo total estudado'),
                  subtitle: Text(_periodLabel(_period)),
                  trailing: Text(
                    _formatDuration(totalSeconds),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Tempo por disciplina',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (snapshot.hasError)
                const Text('Não foi possível calcular as estatísticas.')
              else if (statistics.isEmpty)
                const Text('Nenhuma disciplina cadastrada.')
              else
                ...statistics.map(
                  (item) => _StatisticsBar(
                    statistics: item,
                    progress: maxSeconds == 0
                        ? 0
                        : item.totalSeconds / maxSeconds,
                    durationLabel: _formatDuration(item.totalSeconds),
                    showWeeklyGoal: _period == StatisticsPeriod.currentWeek,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatisticsBar extends StatelessWidget {
  const _StatisticsBar({
    required this.statistics,
    required this.progress,
    required this.durationLabel,
    required this.showWeeklyGoal,
  });

  final DisciplineStatistics statistics;
  final double progress;
  final String durationLabel;
  final bool showWeeklyGoal;

  @override
  Widget build(BuildContext context) {
    final goal = statistics.discipline.weeklyGoalMinutes;
    final goalProgress = goal == 0 ? 0.0 : statistics.totalMinutes / goal;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(statistics.discipline.name)),
                Text(durationLabel),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress.clamp(0, 1)),
            if (showWeeklyGoal) ...[
              const SizedBox(height: 8),
              Text(
                '${(goalProgress * 100).clamp(0, 999).round()}% da meta '
                'semanal de $goal min',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
