import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';
import 'package:trackstudy/services/priority_service.dart';
import 'package:trackstudy/services/active_timer_store.dart';
import 'package:trackstudy/theme/app_colors.dart';
import 'package:trackstudy/theme/discipline_category.dart';
import 'package:trackstudy/widgets/dashboard_widgets.dart';

class DisciplinesPage extends StatefulWidget {
  const DisciplinesPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<DisciplinesPage> createState() => _DisciplinesPageState();
}

class _DisciplinesPageState extends State<DisciplinesPage> {
  AppDatabase get database => widget.database;

  @override
  Widget build(BuildContext context) {
    final weekStart = PriorityService.startOfWeek(DateTime.now());
    final weekEnd = weekStart.add(const Duration(days: 7));

    return Scaffold(
      appBar: const AppHeaderBar(
        icon: Icons.menu_book_rounded,
        title: 'Disciplinas',
        subtitle: 'Acompanhe suas metas e progrida com consistência.',
      ),
      body: StreamBuilder<List<Discipline>>(
        stream: database.disciplinesDao.watchAllDisciplines(),
        builder: (context, snapshot) {
          final disciplines = snapshot.data ?? [];

          if (disciplines.isEmpty) {
            return const Center(child: Text('Nenhuma disciplina cadastrada.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: disciplines.length,
            itemBuilder: (context, index) {
              final discipline = disciplines[index];
              final category = DisciplineCategory.fromKey(discipline.category);
              final bg =
                  AppColors.disciplineBg[category.colorIndex %
                      AppColors.disciplineBg.length];
              final fg =
                  AppColors.disciplineFg[category.colorIndex %
                      AppColors.disciplineFg.length];

              return Card(
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
                                    discipline.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                SoftIconButton(
                                  icon: Icons.edit_rounded,
                                  tooltip: 'Editar',
                                  background: AppColors.disciplineBg[0],
                                  iconColor: AppColors.disciplineFg[0],
                                  onTap: () =>
                                      _showEditDisciplineDialog(discipline),
                                ),
                                const SizedBox(width: 6),
                                SoftIconButton(
                                  icon: Icons.delete_outline_rounded,
                                  tooltip: 'Excluir',
                                  background: const Color(0xFFFEE2E2),
                                  iconColor: AppColors.alert,
                                  onTap: () async {
                                    final active = await ActiveTimerStore().load();
                                    if (!context.mounted) return;
                                    if (active?.disciplineId == discipline.id) {
                                      await showDialog<void>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Sessão ativa nesta disciplina'),
                                          content: Text(
                                            'Há uma sessão de ${discipline.name} em andamento. Encerre ou descarte a sessão no cronômetro antes de excluir a disciplina.',
                                          ),
                                          actions: [
                                            FilledButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Entendi'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar exclusão'),
                                        content: Text(
                                          'Excluir ${discipline.name} também removerá todas as sessões e atividades vinculadas a ela. Esta ação não pode ser desfeita.',
                                        ),
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
                                      await database.disciplinesDao.deleteDiscipline(discipline);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Text(
                              '${category.label} • Meta semanal: ${discipline.weeklyGoalMinutes} min',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            FutureBuilder<int>(
                              future: database.studySessionsDao
                                  .getTotalSecondsByDisciplineBetween(
                                    discipline.id,
                                    weekStart,
                                    weekEnd,
                                  ),
                              builder: (context, secondsSnapshot) {
                                final studiedMinutes =
                                    (secondsSnapshot.data ?? 0) ~/ 60;
                                final goal = discipline.weeklyGoalMinutes;
                                final progress = goal == 0
                                    ? 0.0
                                    : studiedMinutes / goal;
                                final percent = (progress * 100)
                                    .clamp(0, 999)
                                    .round();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedProgressBar(
                                      value: progress,
                                      valueColor: fg,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$percent% de $goal min concluído',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDisciplineDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDisciplineDialog() async {
    final nameController = TextEditingController();
    final goalController = TextEditingController();
    var selectedCategory = DisciplineCategory.outras;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nova disciplina'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da disciplina',
                      hintText: 'Ex: Cálculo',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DisciplineCategory>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Área/Categoria',
                    ),
                    items: DisciplineCategory.values
                        .map(
                          (category) => DropdownMenuItem(
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
                        )
                        .toList(),
                    onChanged: (value) => setDialogState(
                      () =>
                          selectedCategory = value ?? DisciplineCategory.outras,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Meta semanal em minutos',
                      hintText: 'Ex: 300',
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final goal = int.tryParse(goalController.text);
                    if (name.isEmpty || goal == null || goal <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe um nome e uma meta semanal maior que zero.'),
                        ),
                      );
                      return;
                    }
                    await database.disciplinesDao.insertDiscipline(
                      DisciplinesCompanion.insert(
                        name: name,
                        weeklyGoalMinutes: goal,
                        category: Value(selectedCategory.key),
                      ),
                    );
                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext, true);
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    // A tela de disciplinas é aberta a partir da página inicial. Após um
    // cadastro bem-sucedido, volte para ela para que o resumo seja atualizado.
    if (saved == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showEditDisciplineDialog(Discipline discipline) {
    final nameController = TextEditingController(text: discipline.name);
    final goalController = TextEditingController(
      text: discipline.weeklyGoalMinutes.toString(),
    );
    var selectedCategory = DisciplineCategory.fromKey(discipline.category);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Editar disciplina'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome da disciplina',
                      hintText: 'Ex: Cálculo',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DisciplineCategory>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Área/Categoria',
                    ),
                    items: DisciplineCategory.values
                        .map(
                          (category) => DropdownMenuItem(
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
                        )
                        .toList(),
                    onChanged: (value) => setDialogState(
                      () =>
                          selectedCategory = value ?? DisciplineCategory.outras,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: goalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Meta semanal em minutos',
                      hintText: 'Ex: 300',
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final goal = int.tryParse(goalController.text);
                    if (name.isEmpty || goal == null || goal <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe um nome e uma meta semanal maior que zero.'),
                        ),
                      );
                      return;
                    }
                    await database.disciplinesDao.updateDiscipline(
                      Discipline(
                        id: discipline.id,
                        name: name,
                        weeklyGoalMinutes: goal,
                        category: selectedCategory.key,
                      ),
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
