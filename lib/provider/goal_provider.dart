import 'package:flutter/material.dart';
import 'package:planer/models/goal/goal.dart';
import 'package:planer/models/storage.dart';

class GoalProvider extends ChangeNotifier {
  GoalProvider() {
    _days = Storage.loadDays();
    _allGoals = Storage.loadGoals();

    if (!_days.containsKey(extractDay(DateTime.now()))) {
      addDay(DateTime.now(), notify: false);
    }
  }

  // ignore: prefer_final_fields
  Map<String, Map<String, Goal>> _days = {};
  // ignore: prefer_final_fields
  Map<String, Goal> _allGoals = {};

  DateTime _selectedDay = DateTime.now();
  DateTime get selectedDay => _selectedDay;
  set selectedDay(DateTime newSelectedDay) {
    // Assuming _selectedDay is the field that holds the selected day.
    if (_selectedDay != newSelectedDay) {
      _selectedDay = newSelectedDay;
      // Notify listeners if there is a change to the selected day.
      notifyListeners();
    }
  }

  List<Goal> get goalsOfDay =>
      _days[extractDay(selectedDay)]?.values.toList() ?? [];
  List<Goal> get allGoals => _allGoals.values.toList();

  /// Extract the given day to "Day.Month.Year"
  String extractDay(DateTime day) => "${day.day}.${day.month}.${day.year}";

  /// Checks if a day exists
  bool dayExists(DateTime day) {
    return _days.containsKey(extractDay(day));
  }

  /// Checks if the day before `selectedDay` exists and changes if
  /// it does
  void dayBack() {
    if (dayExists(
      selectedDay.subtract(
        const Duration(days: 1),
      ),
    )) {
      selectedDay = selectedDay.subtract(
        const Duration(days: 1),
      );
    }
  }

  /// Checks if the next day exists and changes if
  /// it does
  void dayForward() {
    if (dayExists(
      selectedDay.add(
        const Duration(days: 1),
      ),
    )) {
      selectedDay = selectedDay.add(
        const Duration(days: 1),
      );
    }
  }

  void reset() {
    _days = {};
    _allGoals = {};

    _selectedDay = DateTime.now();
    addDay(DateTime.now(), notify: false);

    notifyListeners();
  }

  /// Add a goal
  Future<void> putGoal(Goal goal, {bool notify = true}) async {
    _allGoals[goal.uuid] = goal;

    if (goal.weekdays.contains(DateTime.now().weekday)) {
      updateGoal(DateTime.now(), goal, notify: false);
    }

    await Storage.saveDays(_days);
    await Storage.saveGoals(_allGoals);

    if (notify) {
      notifyListeners();
    }
  }

  /// Updates a goal from a day
  Future<void> updateGoal(
    DateTime day,
    Goal goal, {
    bool notify = true,
  }) async {
    // If the day doesn't exist, nothing can be updatet
    if (!_days.containsKey(extractDay(day))) {
      return;
    }

    // Update the goal
    _days[extractDay(day)]![goal.uuid] = goal;

    // Save all days, goals havn't changed so we don't need to save them
    await Storage.saveDays(_days);

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> removeGoal(Goal goal) async {
    _allGoals.removeWhere((key, value) => key == goal.uuid);

    if (goal.weekdays.contains(DateTime.now().weekday) &&
        dayExists(DateTime.now())) {
      _days[extractDay(DateTime.now())]!
          .removeWhere((key, value) => key == goal.uuid);
    }

    await Storage.saveDays(_days);
    await Storage.saveGoals(_allGoals);

    notifyListeners();
  }

  Future<void> addDay(DateTime day, {bool notify = true}) async {
    final goalsOfDay = _allGoals.values
        .where((element) => element.weekdays.contains(day.weekday))
        .toList();

    Map<String, Goal> goals = {};
    for (Goal goal in goalsOfDay) {
      goals[goal.uuid] = goal;
    }

    _days[extractDay(day)] = goals;

    await Storage.saveDays(_days);

    if (notify) {
      notifyListeners();
    }
  }
}
