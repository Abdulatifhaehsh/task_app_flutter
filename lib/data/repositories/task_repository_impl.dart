import 'package:dartz/dartz.dart';
import 'package:task_app/core/errors/exceptions.dart';
import 'package:task_app/core/errors/failures.dart';
import 'package:task_app/data/datasources/local/task_local_data_source.dart';
import 'package:task_app/data/datasources/remote/task_remote_data_source.dart';
import 'package:task_app/data/models/task_model.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, TaskEntity>> addTask(TaskEntity task) async {
    try {
      TaskModel taskModel = TaskModel.fromEntity(task);
      final TaskModel taskResponse = await remoteDataSource.addTask(taskModel);
      final localTasks = List<TaskModel>.from(await localDataSource.getTasks());
      localTasks.add(taskResponse);
      await localDataSource.saveTasks(localTasks, 0);
      return Right(taskResponse.toEntity());
    } on ServerException {
      return const Left(ServerFailure('There is a problem. Please try again'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final result = await remoteDataSource.updateTask(taskModel);
      // Optionally, update the local cache
      final localTasks = List<TaskModel>.from(await localDataSource.getTasks());
      final index = localTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        localTasks[index] = taskModel;
        await localDataSource.saveTasks(localTasks, 0);
      }
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('There is a problem. Please try again'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(int taskId) async {
    try {
      final result = await remoteDataSource.deleteTask(taskId);
      // Optionally, update the local cache
      final localTasks = List<TaskModel>.from(await localDataSource.getTasks());
      localTasks.removeWhere((task) => task.id == taskId);
      await localDataSource.saveTasks(localTasks, 0);

      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('There is a problem. Please try again'));
    }
  }

  @override
  Future<List<TaskEntity>> getTasksFromLocal() {
    return localDataSource.getTasks();
  }

  @override
  Future<void> saveTasksToLocal(List<TaskEntity> tasks) {
    return localDataSource.saveTasks(
        tasks.map((task) => TaskModel.fromEntity(task)).toList(), 0);
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> fetchTasks(int page) async {
    try {
      final remoteTasks = await remoteDataSource.fetchTasks(page);
      await localDataSource.saveTasks(remoteTasks, page);
      return Right(
          remoteTasks.map((taskModel) => taskModel.toEntity()).toList());
    } on ServerException {
      final localTasks = (await localDataSource.getTasks())
          .map((taskModel) => taskModel.toEntity())
          .toList();
      if (localTasks.isNotEmpty) {
        return Right(localTasks);
      }
      return const Left(ServerFailure('There is a problem. Please try again'));
    }
  }
}
