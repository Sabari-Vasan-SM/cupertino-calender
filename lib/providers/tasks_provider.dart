import 'package:flutter/foundation.dart';

import '../models/task_entry.dart';

class TasksProvider extends ChangeNotifier {
  final Map<DateTime, List<String>> _tasks = {};

  TasksProvider();

  Map<DateTime, List<String>> get tasks => _tasks;

  List<String> tasksForDate(DateTime date) {
    final key = _dateOnly(date);
    return List.unmodifiable(_tasks[key] ?? []);
  }

  bool hasTasks(DateTime date) {
    final key = _dateOnly(date);
    return _tasks[key]?.isNotEmpty ?? false;
  }

  int taskCount(DateTime date) {
    final key = _dateOnly(date);
    return _tasks[key]?.length ?? 0;
  }

  void addTask(DateTime date, String title) {
    final key = _dateOnly(date);
    final list = _tasks.putIfAbsent(key, () => []);
    list.add(title);
    notifyListeners();
  }

  List<TaskEntry> upcomingTasks(DateTime fromDate) {
    final start = _dateOnly(fromDate);
    final entries = <TaskEntry>[];
    for (final entry in _tasks.entries) {
      if (entry.key.isBefore(start)) {
        continue;
      }
      for (final title in entry.value) {
        entries.add(TaskEntry(date: entry.key, title: title));
      }
    }
    entries.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) {
        return dateCompare;
      }
      return a.title.compareTo(b.title);
    });
    return entries;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
