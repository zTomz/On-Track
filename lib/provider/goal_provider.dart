import 'package:flutter/material.dart';
import 'package:planer/models/goal/goal.dart';

class GoalProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, Goal> _goals = {};

  List<Goal> get goals => _goals.values.toList();

  void put(Goal goal) {
    _goals[goal.uuid] = goal;

    notifyListeners();
  }

  void removeGoal(Goal goal) {
    _goals.removeWhere((key, value) => key == goal.uuid);

    notifyListeners();
  }
}
