import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/tasks_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksProvider = context.watch<TasksProvider>();
    final upcoming = tasksProvider.upcomingTasks(DateTime.now());

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Tasks'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showAddTaskSheet(context),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: upcoming.isEmpty
            ? const Center(child: Text('No upcoming tasks'))
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  CupertinoListSection.insetGrouped(
                    children: upcoming.map((task) {
                      final dateLabel = DateFormat.yMMMd().format(task.date);
                      return CupertinoListTile(
                        title: Text(task.title),
                        subtitle: Text(dateLabel),
                        leading: const Icon(
                          CupertinoIcons.calendar,
                          color: CupertinoColors.systemBlue,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _showAddTaskSheet(BuildContext context) async {
    final tasksProvider = context.read<TasksProvider>();
    final titleController = TextEditingController();
    DateTime selectedDate = _dateOnly(DateTime.now());

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoPopupSurface(
          child: SafeArea(
            top: false,
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const Text(
                            'Add Task',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              final title = titleController.text.trim();
                              if (title.isEmpty) {
                                return;
                              }
                              tasksProvider.addTask(selectedDate, title);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CupertinoTextField(
                        controller: titleController,
                        placeholder: 'Title',
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: selectedDate,
                          minimumDate: _dateOnly(DateTime.now()),
                          maximumDate: DateTime(2050, 12, 31),
                          onDateTimeChanged: (value) {
                            setModalState(() {
                              selectedDate = _dateOnly(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    titleController.dispose();
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
