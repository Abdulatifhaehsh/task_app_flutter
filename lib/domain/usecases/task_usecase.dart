import 'package:dartz/dartz.dart';
import 'package:task_app/core/errors/failures.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/domain/repositories/task_repository.dart';

class FetchTasksUseCase {
  final TaskRepository taskRepository;

  FetchTasksUseCase(this.taskRepository);

  Future<Either<Failure, List<TaskEntity>>> call(int page) async {
    return taskRepository.fetchTasks(page);
  }
}

class AddTaskUseCase {
  final TaskRepository taskRepository;

  AddTaskUseCase(this.taskRepository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) {
    return taskRepository.addTask(task);
  }
}

class UpdateTaskUseCase {
  final TaskRepository taskRepository;

  UpdateTaskUseCase(this.taskRepository);

  Future<Either<Failure, bool>> call(TaskEntity task) {
    return taskRepository.updateTask(task);
  }
}

class DeleteTaskUseCase {
  final TaskRepository taskRepository;

  DeleteTaskUseCase(this.taskRepository);

  Future<Either<Failure, bool>> call(int taskId) {
    return taskRepository.deleteTask(taskId);
  }
}
