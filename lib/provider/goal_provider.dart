import 'package:flutter/material.dart';
import 'package:planer/models/goal/goal.dart';

class GoalProvider extends ChangeNotifier {
  GoalProvider({List<Goal>? goals}) {
    if (goals == null) {
      return;
    }

    for (Goal goal in goals) {
      _allGoals[goal.uuid] = goal;
    }

    if (!_days.containsKey(extractDay(DateTime.now()))) {
      addDay(DateTime.now(), notify: false);
    }
  }

  // ignore: prefer_final_fields
  Map<String, Map<String, Goal>> _days = {};
  // ignore: prefer_final_fields
  Map<String, Goal> _allGoals = {};
  DateTime selectedDay = DateTime.now();

  List<Goal> get goalsOfDay =>
      _days[extractDay(selectedDay)]?.values.toList() ?? [];
  List<Goal> get allGoals => _allGoals.values.toList();

  /// Extract the given day to "Day.Month.Year"
  String extractDay(DateTime day) => "${day.day}.${day.month}.${day.year}";

  /// Checks if a day exists
  bool dayExists(DateTime day) {
    return _days.containsKey(extractDay(day));
  }

  void printDays() {
    print(_days);
  }

  /// Add a goal
  void putGoal(Goal goal, {bool notify = true}) {
    _allGoals[goal.uuid] = goal;

    if (goal.weekdays.contains(DateTime.now().weekday)) {
      _days.removeWhere((key, value) => key == extractDay(DateTime.now()));
      addDay(DateTime.now());
    }

    if (notify) {
      notifyListeners();
    }
  }

  void removeGoal(Goal goal) {
    _allGoals.removeWhere((key, value) => key == goal.uuid);

    notifyListeners();
  }

  void addDay(DateTime day, {bool notify = true}) {
    final goalsOfDay = _allGoals.values
        .where((element) => element.weekdays.contains(day.weekday))
        .toList();

    Map<String, Goal> goals = {};
    for (Goal goal in goalsOfDay) {
      goals[goal.uuid] = goal;
    }

    _days[extractDay(day)] = goals;

    if (notify) {
      notifyListeners();
    }
  }
}
