import 'package:flutter/material.dart';
import 'package:trackstudy/database/app_database.dart';

class DisciplinesPage extends StatefulWidget {
  const DisciplinesPage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<DisciplinesPage> createState() => _DisciplinesPageState();
}

class _DisciplinesPageState extends State<DisciplinesPage> {
  AppDatabase get database => widget.database;

  //lista das disciplinas cadastradas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disciplinas')),
      body: StreamBuilder<List<Discipline>>(
        stream: database.disciplinesDao.watchAllDisciplines(),
        builder: (context, snapshot) {
          final disciplines = snapshot.data ?? [];

          if (disciplines.isEmpty) {
            return const Center(child: Text('Nenhuma disciplina cadastrada.'));
          }

          return ListView.builder(
            itemCount: disciplines.length,
            itemBuilder: (context, index) {
              final discipline = disciplines[index];

              return ListTile(
                title: Text(discipline.name),
                subtitle: Text(
                  'Meta semanal: ${discipline.weeklyGoalMinutes} min',
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Editar
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditDisciplineDialog(discipline);
                      },
                    ),

                    // Excluir
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirmar exclusão'),
                              content: Text(
                                'Deseja realmente excluir ${disciplines[index].name}?',
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                FilledButton(
                                  onPressed: () async {
                                    await database.disciplinesDao
                                        .deleteDiscipline(discipline);

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Excluir'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDisciplineDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Função para exibir o diálogo de adicionar disciplina
  void _showAddDisciplineDialog() {
    final nameController = TextEditingController();
    final goalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final goal = int.tryParse(goalController.text);

                if (name.isNotEmpty && goal != null && goal > 0) {
                  await database.disciplinesDao.insertDiscipline(
                    DisciplinesCompanion.insert(
                      name: name,
                      weeklyGoalMinutes: goal,
                    ),
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDisciplineDialog(Discipline discipline) {
    final nameController = TextEditingController(text: discipline.name);
    final goalController = TextEditingController(
      text: discipline.weeklyGoalMinutes.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final goal = int.tryParse(goalController.text);

                if (name.isNotEmpty && goal != null && goal > 0) {
                  await database.disciplinesDao.updateDiscipline(
                    Discipline(
                      id: discipline.id,
                      name: name,
                      weeklyGoalMinutes: goal,
                    ),
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}
