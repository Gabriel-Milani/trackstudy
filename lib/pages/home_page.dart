import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/database/daos/activities_dao.dart';
import 'package:trackstudy/database/daos/study_sessions_dao.dart';
import 'package:trackstudy/pages/disciplines_page.dart';
import 'package:trackstudy/pages/activities_page.dart';
import 'package:trackstudy/pages/history_page.dart';
import 'package:trackstudy/pages/statistics_page.dart';
import 'package:trackstudy/pages/settings_page.dart';
import 'package:trackstudy/pages/timer_page.dart';
import 'package:trackstudy/services/dashboard_service.dart';
import 'package:trackstudy/services/active_timer_store.dart';
import 'package:trackstudy/services/priority_service.dart';
import 'package:trackstudy/services/weekly_summary_service.dart';
import 'package:trackstudy/theme/app_colors.dart';
import 'package:trackstudy/theme/app_text_styles.dart';
import 'package:trackstudy/theme/discipline_category.dart';
import 'package:trackstudy/theme/page_transitions.dart';
import 'package:trackstudy/theme/theme_controller.dart';
import 'package:trackstudy/widgets/dashboard_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DisciplineCategory? _filterCategory;
  late Future<_HomeData> _homeFuture;

  @override
  void initState() {
    super.initState();
    _homeFuture = _loadData();
  }

  void _refresh() {
    setState(() {
      _homeFuture = _loadData();
    });
  }

  Future<_HomeData> _loadData() async {
    final priorities = await PriorityService(
      widget.database,
    ).calculatePriorities();
    final summary = await WeeklySummaryService(widget.database).calculate();
    final dashboard = await DashboardService(widget.database).calculate();
    final sessions = await widget.database.studySessionsDao
        .watchSessionsWithDiscipline()
        .first;
    final activities = await widget.database.activitiesDao
        .watchActivities()
        .first;
    final upcoming = activities
        .where((a) => !a.activity.isCompleted)
        .take(3)
        .toList();
    final activeTimer = await ActiveTimerStore().load();
    return _HomeData(
      priorities: priorities,
      summary: summary,
      dashboard: dashboard,
      recentSessions: sessions.take(3).toList(),
      upcomingActivities: upcoming,
      activeTimer: activeTimer,
    );
  }

  Future<void> _open(Widget page) async {
    await Navigator.of(context).push(fadeSlideRoute<void>(page));
    if (mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ??
        AppColors.lightTextPrimary;
    final secondaryColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final themeController = ThemeController.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Image.asset(
            isDark
                ? 'assets/images/trackstudy_lockup_transparent.png'
                : 'assets/images/trackstudy_lockup_light.png',
            height: 36,
          ),
        ),
        actions: [
          IconButton(
            tooltip: isDark
                ? 'Usar tema claro'
                : 'Usar tema escuro (acessibilidade)',
            onPressed: themeController.toggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Configurações',
            onPressed: () => _open(SettingsPage(database: widget.database)),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: FutureBuilder<_HomeData>(
        future: _homeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Não foi possível carregar o painel.'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }
          final data = snapshot.data;
          final priorities = data?.priorities ?? const <DisciplinePriority>[];
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

          final top = priorities.first;
          final summary = data!.summary;
          final dashboard = data.dashboard;
          final filteredPriorities = _filterCategory == null
              ? priorities
              : priorities
                    .where(
                      (p) =>
                          DisciplineCategory.fromKey(p.discipline.category) ==
                          _filterCategory,
                    )
                    .toList();

          String? activeDisciplineName;
          final activeTimer = data.activeTimer;
          if (activeTimer != null) {
            for (final priority in priorities) {
              if (priority.discipline.id == activeTimer.disciplineId) {
                activeDisciplineName = priority.discipline.name;
                break;
              }
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (activeTimer != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.radio_button_checked_rounded),
                    title: const Text('Sessão em andamento'),
                    subtitle: Text(
                      activeDisciplineName ?? 'Disciplina em estudo',
                    ),
                    trailing: FilledButton.tonal(
                      onPressed: () =>
                          _open(TimerPage(database: widget.database)),
                      child: const Text('Abrir'),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Text(
                'Prioridade do momento',
                style: AppTextStyles.sectionTitle(textColor),
              ),
              const SizedBox(height: 8),
              GradientHeroCard(
                disciplineName: top.discipline.name,
                remainingMinutes: top.remainingMinutes,
                goalMinutes: top.discipline.weeklyGoalMinutes,
                progress: top.discipline.weeklyGoalMinutes == 0
                    ? 0
                    : top.studiedMinutes / top.discipline.weeklyGoalMinutes,
                onStudyPressed: () => _open(
                  TimerPage(
                    database: widget.database,
                    initialDisciplineId: top.discipline.id,
                  ),
                ),
              ),
              if (top.reasons(DateTime.now()).isNotEmpty) ...[
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Por que essa prioridade?',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 6),
                        for (final reason in top.reasons(DateTime.now()))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text('• $reason'),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                'Resumo da semana',
                style: AppTextStyles.sectionTitle(textColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: StatPill(
                      icon: Icons.access_time_rounded,
                      label: 'Total (todas)',
                      value: summary.currentMinutes,
                      suffix: 'm',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatPill(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Consistência',
                      value: dashboard.streakDays,
                      suffix: 'd',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatPill(
                      icon: Icons.check_circle_rounded,
                      label: 'Sessões',
                      value: dashboard.sessionsThisWeek,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: StatPill(
                      icon: Icons.trending_up_rounded,
                      label: 'Média diária',
                      value: dashboard.averageDailyMinutes.round(),
                      suffix: 'm',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatPill(
                      icon: Icons.workspace_premium_rounded,
                      label: 'Maior sessão',
                      value: dashboard.longestSessionMinutes,
                      suffix: 'm',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evolução dos estudos',
                      style: AppTextStyles.cardSubtitle(secondaryColor),
                    ),
                    const SizedBox(height: 8),
                    WeeklyEvolutionChart(dailyMinutes: dashboard.dailyMinutes),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Próximas atividades',
                style: AppTextStyles.sectionTitle(textColor),
              ),
              const SizedBox(height: 8),
              UpcomingActivitiesCard(activities: data.upcomingActivities),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progresso por disciplina',
                    style: AppTextStyles.sectionTitle(textColor),
                  ),
                  PopupMenuButton<DisciplineCategory?>(
                    tooltip: 'Filtrar por área',
                    icon: Icon(
                      _filterCategory == null
                          ? Icons.filter_alt_outlined
                          : Icons.filter_alt,
                      color: _filterCategory == null
                          ? secondaryColor
                          : AppColors.primaryLight,
                    ),
                    onSelected: (value) =>
                        setState(() => _filterCategory = value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: null,
                        child: Text('Todas as áreas'),
                      ),
                      ...DisciplineCategory.values.map(
                        (category) => PopupMenuItem(
                          value: category,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(category.icon, size: 18),
                              const SizedBox(width: 8),
                              Text(category.label),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (filteredPriorities.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Nenhuma disciplina nessa área.'),
                )
              else
                ...filteredPriorities.map(
                  (priority) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DisciplineProgressCard(
                      name: priority.discipline.name,
                      studiedMinutes: priority.studiedMinutes,
                      goalMinutes: priority.discipline.weeklyGoalMinutes,
                      category: DisciplineCategory.fromKey(
                        priority.discipline.category,
                      ),
                      onTap: () =>
                          _open(DisciplinesPage(database: widget.database)),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Ações rápidas',
                style: AppTextStyles.sectionTitle(textColor),
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.0,
                children: [
                  QuickActionButton(
                    icon: Icons.play_circle_rounded,
                    label: 'Iniciar sessão',
                    onTap: () => _open(TimerPage(database: widget.database)),
                  ),
                  QuickActionButton(
                    icon: Icons.bar_chart_rounded,
                    label: 'Ver histórico',
                    onTap: () => _open(HistoryPage(database: widget.database)),
                  ),
                  QuickActionButton(
                    icon: Icons.checklist_rounded,
                    label: 'Atividades e prazos',
                    onTap: () =>
                        _open(ActivitiesPage(database: widget.database)),
                  ),
                  QuickActionButton(
                    icon: Icons.flag_rounded,
                    label: 'Definir metas',
                    onTap: () =>
                        _open(DisciplinesPage(database: widget.database)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Últimas sessões',
                    style: AppTextStyles.sectionTitle(textColor),
                  ),
                  TextButton(
                    onPressed: () =>
                        _open(HistoryPage(database: widget.database)),
                    child: const Text('Ver todas'),
                  ),
                ],
              ),
              ...data.recentSessions.map(
                (s) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history_rounded),
                  title: Text(s.discipline.name),
                  subtitle: Text(
                    s.session.notes?.isNotEmpty == true ? s.session.notes! : '',
                  ),
                  trailing: Text('${s.session.durationSeconds ~/ 60}m'),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        height: 60,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          if (index == 1) {
            _open(DisciplinesPage(database: widget.database));
          } else if (index == 2) {
            _open(ActivitiesPage(database: widget.database));
          } else if (index == 3) {
            _open(TimerPage(database: widget.database));
          } else if (index == 4) {
            _open(HistoryPage(database: widget.database));
          } else if (index == 5) {
            _open(StatisticsPage(database: widget.database));
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Disciplinas',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Atividades',
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
  const _HomeData({
    required this.priorities,
    required this.summary,
    required this.dashboard,
    required this.recentSessions,
    required this.upcomingActivities,
    required this.activeTimer,
  });

  final List<DisciplinePriority> priorities;
  final WeeklySummary summary;
  final DashboardSummary dashboard;
  final List<StudySessionWithDiscipline> recentSessions;
  final List<ActivityWithDiscipline> upcomingActivities;
  final ActiveTimerState? activeTimer;
}
