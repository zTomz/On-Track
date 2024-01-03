import 'package:uuid/uuid.dart';

class Goal {
  final String task;
  final String description;
  final Object? value;
  final GoalValueType valueType;
  final List<int> weekdays;
  final DateTime from;
  final String uuid;

  Goal({
    required this.task,
    required this.description,
    required this.value,
    required this.valueType,
    required this.weekdays,
    required this.from,
    required this.uuid,
  });

  Goal.create(String task, String description, GoalValueType valueType,
      List<int> weekdays)
      : this(
          task: task,
          description: description,
          value: null,
          valueType: valueType,
          weekdays: weekdays,
          from: DateTime.now(),
          uuid: const Uuid().v4(),
        );

  Goal copyWith({
      String? task,
      String? description,
      Object? value,
      GoalValueType? valueType,
      List<int>? weekdays,
      DateTime? from,
      String? uuid,
    }) {
      return Goal(
        task: task ?? this.task,
        description: description ?? this.description,
        value: value ?? this.value,
        valueType: valueType ?? this.valueType,
        weekdays: weekdays ?? this.weekdays,
        from: from ?? this.from,
        uuid: uuid ?? this.uuid,
      );
    }

  @override
  String toString() {
    return 'Goal(task: $task, description: $description, value: $value, valueType: $valueType, weekdays: $weekdays, from: $from, uuid: $uuid)';
  }
}

enum GoalValueType {
  text,
  number,
  bool,
}
