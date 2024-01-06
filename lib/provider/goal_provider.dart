import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:planer/models/goal/goal.dart';
import 'package:planer/models/storage.dart';

class GoalProvider extends ChangeNotifier {
  GoalProvider() {
    _days = Storage.loadDays();
    _allGoals = Storage.loadGoals();

    generateFakeDaysData(
      50,
      startFrom: DateTime.now().subtract(
        const Duration(days: 1),
      ),
    );

    if (!_days.containsKey(extractDay(DateTime.now()))) {
      addDay(DateTime.now(), notify: false);
    }
  }

  // ignore: prefer_final_fields
  Map<String, Map<String, Goal>> _days = {};
  // ignore: prefer_final_fields
  Map<String, Goal> _allGoals = {};
  // ignore: prefer_final_fields
  List<int> _expandedIndexes = [];
  // ignore: prefer_final_fields
  DateTime _selectedMonth = DateTime.now();

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

  List<int> get expandedIndexes => _expandedIndexes;

  DateTime get selectedMonth => _selectedMonth;
  set selectedMonth(DateTime newSelectedMonth) {
    // Assuming _selectedMonth is the field that holds the selected month.
    if (_selectedMonth != newSelectedMonth) {
      _selectedMonth = newSelectedMonth;
      // Notify listeners if there is a change to the selected month.
      notifyListeners();
    }
  }

  /// Extract the given day to "Day.Month.Year"
  String extractDay(DateTime day) => "${day.day}.${day.month}.${day.year}";

  /// Checks if a day exists
  bool dayExists(DateTime day) {
    return _days.containsKey(extractDay(day));
  }

  /// Generates fake data for a set number of days.
  /// The [numberOfDays] parameter determines how many days of data will be generated.
  /// The [startFrom] parameter allows setting a starting date. Defaults to today.
  void generateFakeDaysData(int numberOfDays, {DateTime? startFrom}) {
    DateTime startDate = startFrom ?? DateTime.now();

    for (int i = 0; i < numberOfDays; i++) {
      DateTime fakeDay = startDate.subtract(Duration(days: i));

      addDay(fakeDay, notify: false, saveToStorage: false);
    }
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

  /// Changes the selected month by the given months.
  /// If the given months are smaller 0, they got subtracted
  /// else added
  void changeSelectedMonth(int months) {
    for (int i = 0; i < months.abs(); i++) {
      if (months < 0) {
        if (selectedMonth.month == 1) {
          selectedMonth = DateTime(selectedMonth.year - 1, 12);
        } else {
          selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
        }
      } else {
        if (selectedMonth.month == 12) {
          selectedMonth = DateTime(selectedMonth.year + 1, 1);
        } else {
          selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
        }
      }
    }

    notifyListeners();
  }

  String extractMonth(DateTime month) {
    return "${month.month}.${month.year}";
  }

  /// Gets line chart data for a given month.
  ///
  /// Filters days to only those in the given month, gets goals from those days,
  /// converts goal values to data points with x as day of month and y as goal value.
  /// Groups data points by goal UUID into lines.
  ///
  /// Returns map of list of data points for that goal line.
  Map<String, List<FlSpot>> getLineChartDataForMonth(DateTime month) {
    Map<String, Map<String, Goal>> daysToUse = {};
    Map<String, List<FlSpot>> data = {};

    for (String day in _days.keys) {
      if (day.contains(extractMonth(month))) {
        if (_days[day] != null) {
          daysToUse[day] = _days[day]!;
        }
      }
    }

    for (String day in daysToUse.keys) {
      for (Goal goal in daysToUse[day]!.values) {
        if (goal.valueType != GoalValueType.number) {
          continue;
        }

        if (data[goal.uuid] == null) {
          data[goal.uuid] = [];
        }

        data[goal.uuid]!.add(
          FlSpot(
            double.tryParse(day.split(".")[0].toString()) ?? 0,
            double.tryParse(goal.value.toString()) ?? 0,
          ),
        );
      }
    }

    return data;
  }

  /// Gets boolean data for goals in a given month.
  ///
  /// Filters days to only those in the month, gets boolean goals from those days.
  /// Groups data by goal task into lists of booleans for that task.
  ///
  /// Returns a map of lists of booleans for each goal task.
  Map<String, List<bool>> getBoolDataForMonth(DateTime month) {
    Map<String, Map<String, Goal>> daysToUse = {};

    /// A List of goals to use
    List<Goal> goalsToUse = [];
    Map<String, List<bool>> data = {};

    // Get all needed days
    for (String day in _days.keys) {
      if (day.contains(extractMonth(month))) {
        if (_days[day] != null) {
          daysToUse[day] = _days[day]!;
        }
      }
    }

    // Get all needed goals
    for (String day in daysToUse.keys) {
      for (Goal goal in daysToUse[day]!.values) {
        if (goal.valueType == GoalValueType.bool) {
          bool goalAlreadyAdded = false;

          for (Goal addedGoal in goalsToUse) {
            if (addedGoal.uuid == goal.uuid) {
              goalAlreadyAdded = true;
              break;
            }
          }

          if (!goalAlreadyAdded) {
            goalsToUse.add(goal);
          }
        }
      }
    }

    print("Goals to use: $goalsToUse");
    print("Goals to use length: ${goalsToUse.length}");

    for (Goal goal in goalsToUse) {
      // If data for this goal does not exist, create it
      if (!data.containsKey(goal.task)) {
        data[goal.task] = [];
      }

      for (String day in daysToUse.keys) {
        if (daysToUse[day]!.containsKey(goal.uuid)) {
          data[goal.task]!.add(
            daysToUse[day]![goal.uuid]!.value as bool? ?? false,
          );
        } else {
          data[goal.task]!.add(false);
        }
      }
    }

    return data;
  }

  /// Method for toggeling the expansion of tiles
  void toggleExpansion(int index) {
    // Toggle the index
    if (expandedIndexes.contains(index)) {
      _expandedIndexes.remove(index);
    } else {
      _expandedIndexes.add(index);
    }

    notifyListeners();
  }

  /// Resets the list of expanded tile indexes to clear all expanded tiles.
  void resetExpandedTiles() {
    _expandedIndexes.clear();

    notifyListeners();
  }

  /// Reset all data in the provider
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

  Future<void> addDay(DateTime day,
      {bool notify = true, bool saveToStorage = true}) async {
    final goalsOfDay = _allGoals.values
        .where((element) => element.weekdays.contains(day.weekday))
        .toList();

    Map<String, Goal> goals = {};
    for (Goal goal in goalsOfDay) {
      goals[goal.uuid] = goal;
    }

    _days[extractDay(day)] = goals;

    if (saveToStorage) {
      await Storage.saveDays(_days);
    }

    if (notify) {
      notifyListeners();
    }
  }
}
