import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_entry.dart';

class TasksProvider extends ChangeNotifier {
  static const String _storageKey = 'tasks_by_date';

  final Map<DateTime, List<String>> _tasks = {};

  TasksProvider() {
    _loadFromPrefs();
  }

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
    _saveToPrefs();
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

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) {
        return;
      }
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _tasks
        ..clear()
        ..addAll(
          decoded.map((key, value) {
            final date = DateTime.parse(key);
            final titles = (value as List<dynamic>)
                .map((item) => item.toString())
                .toList();
            return MapEntry(_dateOnly(date), titles);
          }),
        );
      notifyListeners();
    } catch (_) {
      // Ignore corrupt data and keep an empty state.
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = <String, List<String>>{};
    for (final entry in _tasks.entries) {
      payload[entry.key.toIso8601String()] = List.of(entry.value);
    }
    await prefs.setString(_storageKey, jsonEncode(payload));
  }
}
