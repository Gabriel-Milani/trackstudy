import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/dashboard_service.dart';
import 'package:trackstudy/services/priority_service.dart';
import 'package:trackstudy/services/statistics_service.dart';
import 'package:trackstudy/theme/app_colors.dart';
import 'package:trackstudy/theme/app_text_styles.dart';
import 'package:trackstudy/widgets/dashboard_widgets.dart';

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
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.lightTextPrimary;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      appBar: const AppHeaderBar(
        icon: Icons.bar_chart_rounded,
        title: 'Relatórios',
        subtitle: 'Veja sua evolução por disciplina.',
      ),
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
              const SizedBox(height: 20),
              Text(
                'Consistência',
                style: AppTextStyles.sectionTitle(textColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Últimas 12 semanas',
                style: AppTextStyles.cardSubtitle(secondaryColor),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 0.6,
                  ),
                ),
                child: FutureBuilder<Map<DateTime, int>>(
                  future: DashboardService(
                    widget.database,
                  ).getDailyMinutesForLastDays(84),
                  builder: (context, heatmapSnapshot) {
                    if (!heatmapSnapshot.hasData) {
                      return const SizedBox(
                        height: 90,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return ConsistencyHeatmap(
                      dailyMinutes: heatmapSnapshot.data!,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
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
                    comparativeProgress: maxSeconds == 0
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
    required this.comparativeProgress,
    required this.durationLabel,
    required this.showWeeklyGoal,
  });

  final DisciplineStatistics statistics;

  /// Proporção em relação à disciplina com mais tempo estudado no período
  /// (usada só quando não há uma meta fixa pra comparar, ex: mês/todo período).
  final double comparativeProgress;
  final String durationLabel;
  final bool showWeeklyGoal;

  @override
  Widget build(BuildContext context) {
    final goal = statistics.discipline.weeklyGoalMinutes;
    final goalProgress = goal == 0 ? 0.0 : statistics.totalMinutes / goal;
    // Quando dá pra comparar com uma meta semanal de verdade, a barra usa
    // esse valor (é o que o texto abaixo também mostra); senão, cai pra
    // comparação relativa entre disciplinas.
    final barValue = showWeeklyGoal ? goalProgress : comparativeProgress;

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
            AnimatedProgressBar(
              value: barValue,
              valueColor: Theme.of(context).colorScheme.primary,
            ),
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
