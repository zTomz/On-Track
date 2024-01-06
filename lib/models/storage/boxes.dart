import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:planer/models/goal/goal.dart';

@immutable
class Boxes {
  static final daysBox = Hive.box<List>("daysBox");
  static final allGoalsBox = Hive.box<Goal>("allGoalsBox");
  static final settingsBox = Hive.box("settingsBox");

  const Boxes();
}
