import 'package:uuid/uuid.dart';

class Goal {
  final String task;
  final String description;
  final List<Object> values;
  final GoalValueType valueType;
  final List<int> weekdays;
  Map<int, bool> finishedDays;
  final DateTime from;
  final String uuid;

  Goal({
    required this.task,
    required this.description,
    required this.values,
    required this.valueType,
    required this.weekdays,
    required this.finishedDays,
    required this.from,
    required this.uuid,
  });

  Goal.create(String task, String description, GoalValueType valueType,
      List<int> weekdays)
      : this(
          task: task,
          description: description,
          values: [],
          valueType: valueType,
          weekdays: weekdays,
          finishedDays: Map.fromIterable(weekdays, value: (_) => false),
          from: DateTime.now(),
          uuid: const Uuid().v4(),
        );

  @override
  String toString() {
    return 'Goal(task: $task, description: $description, values: $values, valueType: $valueType, weekdays: $weekdays, finishedDays: $finishedDays, from: $from, uuid: $uuid)';
  }
}

enum GoalValueType {
  text,
  number,
  bool,
}
