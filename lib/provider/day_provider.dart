import 'package:flutter/material.dart';
import 'package:planer/models/goal/goal.dart';

class DayProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  Map<String, List<Goal>> _days = {};
  Map<String, List<Goal>> get days => _days;

  DateTime selectedDay = DateTime.now();

  String extractDay(DateTime day) => "${day.day}.${day.month}.${day.year}";
}
