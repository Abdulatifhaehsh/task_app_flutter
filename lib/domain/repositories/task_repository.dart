import 'package:dartz/dartz.dart';
import 'package:task_app/core/errors/failures.dart';
import 'package:task_app/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> fetchTasks(int page);

  Future<Either<Failure, TaskEntity>> addTask(TaskEntity task);

  Future<Either<Failure, bool>> updateTask(TaskEntity task);

  Future<Either<Failure, bool>> deleteTask(int taskId);

  Future<List<TaskEntity>> getTasksFromLocal();

  Future<void> saveTasksToLocal(List<TaskEntity> tasks);
}
