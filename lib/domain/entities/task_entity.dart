import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int id;
  final String todo;
  final bool completed;
  final int? userId;

  const TaskEntity(
      {required this.id,
      required this.todo,
      required this.completed,
      this.userId});

  TaskEntity copyWith(
      {int? id,
      String? todo,
      String? description,
      bool? completed,
      int? userId}) {
    return TaskEntity(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, todo, completed, userId];
}
