import 'package:flutter/material.dart';
import 'package:ontrack/models/goal/goal.dart';
import 'package:ontrack/models/storage/boxes.dart';

class Storage {
  /// Saves for each day the goals as a list of goals
  static Future<void> saveDays(Map<String, Map<String, Goal>> days) async {
    await Boxes.daysBox.clear();

    for (String day in days.keys) {
      await Boxes.daysBox.put(
        day,
        days[day]!.values.toList(),
      );
    }
  }

  /// Loads all days from `daysBox` and returns it
  static Map<String, Map<String, Goal>> loadDays() {
    Map<String, Map<String, Goal>> days = {};

    for (String value in Boxes.daysBox.keys) {
      Map<String, Goal> goals = {};

      if (!Boxes.daysBox.containsKey(value)) continue;

      for (Goal goal in Boxes.daysBox.get(value) ?? []) {
        goals[goal.uuid] = goal;
      }

      days[value] = goals;
    }

    return days;
  }

  /// Save all goals to storage
  static Future<void> saveGoals(Map<String, Goal> goals) async {
    await Boxes.allGoalsBox.clear();

    for (Goal goal in goals.values) {
      await Boxes.allGoalsBox.put(
        goal.uuid,
        goal,
      );
    }
  }

  /// Loads all goals from storage
  static Map<String, Goal> loadGoals() {
    Map<String, Goal> goals = {};

    for (Goal goal in Boxes.allGoalsBox.values) {
      goals[goal.uuid] = goal;
    }

    return goals;
  }

  static Future<void> saveThemeMode(ThemeMode themeMode) async {
    await Boxes.settingsBox.put("themeMode", themeMode.index);
  }

  static ThemeMode loadThemeMode() =>
      ThemeMode.values[Boxes.settingsBox.get("themeMode") ?? 0];
}
