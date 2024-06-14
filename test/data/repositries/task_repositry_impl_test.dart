import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/core/errors/exceptions.dart';
import 'package:task_app/data/models/task_model.dart';
import 'package:task_app/data/repositories/task_repository_impl.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/core/errors/failures.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late MockTaskRemoteDataSource mockTaskRemoteDataSource;
  late MockTaskLocalDataSource mockTaskLocalDataSource;
  late TaskRepositoryImpl taskRepositoryImpl;

  setUp(() {
    mockTaskRemoteDataSource = MockTaskRemoteDataSource();
    mockTaskLocalDataSource = MockTaskLocalDataSource();
    taskRepositoryImpl = TaskRepositoryImpl(
        remoteDataSource: mockTaskRemoteDataSource,
        localDataSource: mockTaskLocalDataSource);
  });

  const testTaskEntities = [
    TaskEntity(
        id: 11,
        todo: "Text a friend I haven't talked to in a long time",
        completed: false,
        userId: 39),
    TaskEntity(
      id: 12,
      todo: "do tasks",
      completed: false,
      userId: 39,
    ),
  ];

  const testTaskModels = [
    TaskModel(
        id: 11,
        todo: "Text a friend I haven't talked to in a long time",
        completed: false,
        userId: 39),
    TaskModel(
      id: 12,
      todo: "do tasks",
      completed: false,
      userId: 39,
    ),
  ];

  group('fetch tasks from repository', () {
    test('should return tasks when a call to data source is successful',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.fetchTasks(0))
          .thenAnswer((_) async => testTaskModels);
      when(mockTaskLocalDataSource.saveTasks(testTaskModels, 0))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await taskRepositoryImpl.fetchTasks(0);

      // Assert
      result.fold((left) => fail('test failed'), (right) {
        expect(right, equals(testTaskEntities));
      });
    });

    test(
        'should return tasks from local data source when remote call throws a ServerException',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.fetchTasks(0)).thenThrow(ServerException());
      when(mockTaskLocalDataSource.getTasks())
          .thenAnswer((_) async => testTaskModels);

      // Act
      final result = await taskRepositoryImpl.fetchTasks(0);

      // Assert
      result.fold(
        (failure) => fail('test failed'),
        (tasks) {
          expect(tasks, equals(testTaskEntities));
        },
      );
    });
  });

  group('add task from repository', () {
    test('should add and return task when a call to data source is successful',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.addTask(testTaskModels[0]))
          .thenAnswer((_) async => testTaskModels[0]);
      when(mockTaskLocalDataSource.getTasks())
          .thenAnswer((_) async => testTaskModels);
      when(mockTaskLocalDataSource.saveTasks(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await taskRepositoryImpl.addTask(testTaskEntities[0]);
      // Assert
      expect(result, equals(Right(testTaskEntities[0])));
    });

    test('should return failure when adding task to remote data source fails',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.addTask(testTaskModels[0]))
          .thenThrow(ServerException());

      // Act
      final result = await taskRepositoryImpl.addTask(testTaskEntities[0]);

      // Assert
      expect(
          result,
          equals(const Left(
              ServerFailure("There is a problem. Please try again"))));
    });
  });

  group('update task from repository', () {
    test(
        'should update and return true when a call to data source is successful',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.updateTask(testTaskModels[0]))
          .thenAnswer((_) async => true);
      when(mockTaskLocalDataSource.getTasks())
          .thenAnswer((_) async => testTaskModels);
      when(mockTaskLocalDataSource.saveTasks(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await taskRepositoryImpl.updateTask(testTaskEntities[0]);
      // Assert
      expect(result, equals(const Right(true)));
    });

    test('should return failure when updating task to remote data source fails',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.updateTask(testTaskModels[0]))
          .thenThrow(ServerException());

      // Act
      final result = await taskRepositoryImpl.updateTask(testTaskEntities[0]);

      // Assert
      expect(
          result,
          equals(const Left(
              ServerFailure("There is a problem. Please try again"))));
    });
  });

  group('update task from repository', () {
    test(
        'should update and return true when a call to data source is successful',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.updateTask(testTaskModels[0]))
          .thenAnswer((_) async => true);
      when(mockTaskLocalDataSource.getTasks())
          .thenAnswer((_) async => testTaskModels);
      when(mockTaskLocalDataSource.saveTasks(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await taskRepositoryImpl.updateTask(testTaskEntities[0]);
      // Assert
      expect(result, equals(const Right(true)));
    });

    test('should return failure when updating task to remote data source fails',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.updateTask(testTaskModels[0]))
          .thenThrow(ServerException());

      // Act
      final result = await taskRepositoryImpl.updateTask(testTaskEntities[0]);

      // Assert
      expect(
          result,
          equals(const Left(
              ServerFailure("There is a problem. Please try again"))));
    });
  });

  group('delete task from repository', () {
    test(
        'should delete and return true when a call to data source is successful',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.deleteTask(testTaskModels[0].id))
          .thenAnswer((_) async => true);
      when(mockTaskLocalDataSource.getTasks())
          .thenAnswer((_) async => testTaskModels);
      when(mockTaskLocalDataSource.saveTasks(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      final result =
          await taskRepositoryImpl.deleteTask(testTaskEntities[0].id);
      // Assert
      expect(result, equals(const Right(true)));
    });

    test('should return failure when deleting task to remote data source fails',
        () async {
      // Arrange
      when(mockTaskRemoteDataSource.deleteTask(testTaskModels[0].id))
          .thenThrow(ServerException());

      // Act
      final result =
          await taskRepositoryImpl.deleteTask(testTaskEntities[0].id);

      // Assert
      expect(
          result,
          equals(const Left(
              ServerFailure("There is a problem. Please try again"))));
    });
  });
}
