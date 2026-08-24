import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/pages/disciplines_page.dart';
import 'package:trackstudy/pages/activities_page.dart';
import 'package:trackstudy/pages/history_page.dart';
import 'package:trackstudy/pages/statistics_page.dart';
import 'package:trackstudy/pages/timer_page.dart';
import 'package:trackstudy/services/priority_service.dart';
import 'package:trackstudy/services/weekly_summary_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _deadlineLabel(Activity activity) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      activity.dueAt.year,
      activity.dueAt.month,
      activity.dueAt.day,
    );
    final days = due.difference(today).inDays;
    if (days < 0) return 'atrasada';
    if (days == 0) return 'vence hoje';
    if (days == 1) return 'vence amanhã';
    return 'vence em $days dias';
  }

  Future<_HomeData> _loadData() async {
    final priorities = await PriorityService(
      widget.database,
    ).calculatePriorities();
    final summary = await WeeklySummaryService(widget.database).calculate();
    return _HomeData(priorities: priorities, summary: summary);
  }

  Future<void> _open(Widget page) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => page));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TrackStudy'),
        actions: [
          IconButton(
            tooltip: 'Atividades e prazos',
            onPressed: () => _open(ActivitiesPage(database: widget.database)),
            icon: const Icon(Icons.checklist),
          ),
        ],
      ),
      body: FutureBuilder<_HomeData>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final priorities =
              snapshot.data?.priorities ?? const <DisciplinePriority>[];
          if (priorities.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Cadastre uma disciplina para começar a acompanhar seus estudos.',
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Resumo semanal',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _WeeklySummaryCard(summary: snapshot.data!.summary),
              const SizedBox(height: 20),
              Text(
                'Prioridades da semana',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ...priorities.map(
                (priority) => Card(
                  child: ListTile(
                    title: Text(priority.discipline.name),
                    subtitle: Text(
                      '${priority.studiedMinutes} de '
                      '${priority.discipline.weeklyGoalMinutes} min estudados'
                      '${priority.nextActivity == null ? '' : '\nLembrete: ${priority.nextActivity!.title} (${_deadlineLabel(priority.nextActivity!)})'}',
                    ),
                    isThreeLine: priority.nextActivity != null,
                    trailing: Text(
                      '${priority.remainingMinutes} min restantes',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            _open(DisciplinesPage(database: widget.database));
          } else if (index == 2) {
            _open(TimerPage(database: widget.database));
          } else if (index == 3) {
            _open(HistoryPage(database: widget.database));
          } else if (index == 4) {
            _open(StatisticsPage(database: widget.database));
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Disciplinas',
          ),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Cronômetro'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Histórico'),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),
        ],
      ),
    );
  }
}

class _HomeData {
  const _HomeData({required this.priorities, required this.summary});

  final List<DisciplinePriority> priorities;
  final WeeklySummary summary;
}

class _WeeklySummaryCard extends StatelessWidget {
  const _WeeklySummaryCard({required this.summary});

  final WeeklySummary summary;

  @override
  Widget build(BuildContext context) {
    final difference = summary.differenceMinutes;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${summary.currentMinutes} de ${summary.totalGoalMinutes} min',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: summary.progress.clamp(0, 1)),
            const SizedBox(height: 8),
            Text(
              '${summary.goalsReached}/${summary.disciplineCount} metas atingidas • '
              '${difference >= 0 ? '+' : ''}$difference min versus semana anterior',
            ),
          ],
        ),
      ),
    );
  }
}
