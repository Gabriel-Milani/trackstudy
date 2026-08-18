import 'package:flutter/material.dart';
import 'package:trackstudy/models/discipline.dart';

class DisciplinesPage extends StatefulWidget {
  const DisciplinesPage({super.key});

  @override
  State<DisciplinesPage> createState() => _DisciplinesPageState();
}

class _DisciplinesPageState extends State<DisciplinesPage> {
  List<Discipline> disciplines = [];

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
              onPressed: () {
                final name = nameController.text.trim();
                final goal = int.tryParse(goalController.text);

                if (name.isNotEmpty && goal != null && goal > 0) {
                  setState(() {
                    disciplines.add(
                      Discipline(name: name, weeklyGoalMinutes: goal),
                    );
                  });

                  Navigator.pop(context);
                }
              },

              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDisciplineDialog(int index) {
    final nameController = TextEditingController(text: disciplines[index].name);
    final goalController = TextEditingController(text: disciplines[index].weeklyGoalMinutes.toString());

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
              onPressed: () {
                final name = nameController.text.trim();
                final goal = int.tryParse(goalController.text);

                if (name.isNotEmpty && goal != null && goal > 0) {
                  setState(() {
                    disciplines[index] = Discipline(name: name, weeklyGoalMinutes: goal);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
  //lista das disciplinas cadastradas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disciplinas')),
      body: disciplines.isEmpty
          ? const Center(child: Text('Nenhuma disciplina cadastrada.'))
          : ListView.builder(
              itemCount: disciplines.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(disciplines[index].name),
                  subtitle: Text(
                    'Meta semanal: ${disciplines[index].weeklyGoalMinutes} min',
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Editar
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditDisciplineDialog(index);
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
                                    onPressed: () {
                                      Navigator.pop(context);

                                      setState(() {
                                        disciplines.removeAt(index);
                                      });
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
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDisciplineDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
