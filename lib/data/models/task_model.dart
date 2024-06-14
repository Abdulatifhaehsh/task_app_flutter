import 'package:task_app/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel(
      {required super.id,
      required super.todo,
      required super.completed,
      super.userId});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json['id'],
        todo: json['todo'] ?? '',
        completed: json['completed'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }

  factory TaskModel.fromEntity(TaskEntity task) {
    return TaskModel(
        id: task.id,
        todo: task.todo,
        completed: task.completed,
        userId: task.userId);
  }

  TaskEntity toEntity() =>
      TaskEntity(id: id, todo: todo, completed: completed, userId: userId);
}
