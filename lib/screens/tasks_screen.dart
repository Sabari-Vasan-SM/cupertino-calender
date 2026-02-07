import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksProvider = context.watch<TasksProvider>();
    final upcoming = tasksProvider.upcomingTasks(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: upcoming.isEmpty
          ? const Center(
              child: Text('No upcoming tasks'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: upcoming.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = upcoming[index];
                final dateLabel = DateFormat.yMMMd().format(task.date);
                return Card(
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(dateLabel),
                    leading: Icon(
                      Icons.event,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddTaskSheet(BuildContext context) async {
    final tasksProvider = context.read<TasksProvider>();
    final titleController = TextEditingController();
    DateTime selectedDate = DateUtils.dateOnly(DateTime.now());

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateFormat.yMMMd().format(selectedDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateUtils.dateOnly(DateTime.now()),
                            lastDate: DateTime(2050, 12, 31),
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedDate = DateUtils.dateOnly(picked);
                            });
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final title = titleController.text.trim();
                        if (title.isEmpty) {
                          return;
                        }
                        tasksProvider.addTask(selectedDate, title);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add Task'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
