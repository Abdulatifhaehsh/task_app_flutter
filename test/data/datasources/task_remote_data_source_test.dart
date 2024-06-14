import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_app/core/constants/api_endpoints.dart';
import 'package:task_app/core/errors/exceptions.dart';
import 'package:task_app/data/datasources/remote/task_remote_data_source_impl.dart';
import 'package:task_app/data/models/task_model.dart';

import '../../helper/read_json.dart';
import '../../helper/test_helper.mocks.dart';
import 'package:http/http.dart' as http;

void main() {
  late MockHttpClient mockHttpClient;
  late TaskRemoteDataSourceImpl taskRemoteDataSourceImpl;

  setUp(() {
    mockHttpClient = MockHttpClient();
    taskRemoteDataSourceImpl = TaskRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('fetch tasks from datasource', () {
    test('should return tasks when the response status code is 200', () async {
      // Arrange
      when(mockHttpClient.get(
        Uri.parse('${ApiEndpoints.tasks}?limit=12&skip=${0 * 12}'),
      )).thenAnswer((_) async => http.Response(
          readJson('helper/dummy_data/dummy_tasks_response.json'), 200));

      // Act
      final result = await taskRemoteDataSourceImpl.fetchTasks(0);

      // Assert
      expect(result, isA<List<TaskModel>>());
    });

    test(
      'should throw a server exception when the response code is 400 or other',
      () async {
        //arrange
        when(mockHttpClient.get(
          Uri.parse('${ApiEndpoints.tasks}?limit=12&skip=${0 * 12}'),
        )).thenAnswer((_) async => http.Response('Not found', 400));

        //act
        final result = taskRemoteDataSourceImpl.fetchTasks(0);

        //assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });

  const testTaskModel = TaskModel(
      id: 11,
      todo: "Text a friend I haven't talked to in a long time",
      completed: false,
      userId: 39);

  group('add task from datasource', () {
    test('should return task when the response status code is 201', () async {
      // Arrange
      when(mockHttpClient.post(
        Uri.parse('${ApiEndpoints.tasks}/add'),
        body: jsonEncode(testTaskModel.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      )).thenAnswer((_) async => http.Response(
          readJson('helper/dummy_data/dummy_task_response.json'), 201));

      // Act
      final result = await taskRemoteDataSourceImpl.addTask(testTaskModel);

      // Assert
      expect(result, isA<TaskModel>());
    });

    test(
      'should throw a server exception when the response code is 400 or other',
      () async {
        //arrange
        when(mockHttpClient.post(
          Uri.parse('${ApiEndpoints.tasks}/add'),
          body: jsonEncode(testTaskModel.toJson()),
          headers: {
            'Content-Type': 'application/json',
          },
        )).thenAnswer((_) async => http.Response('Not found', 400));

        //act
        final result = taskRemoteDataSourceImpl.addTask(testTaskModel);

        //assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });

  group('update task from datasource', () {
    test('should return true when the response status code is 200', () async {
      // Arrange
      when(mockHttpClient.put(
        Uri.parse('${ApiEndpoints.tasks}/${testTaskModel.id}'),
        body: jsonEncode({
          'completed': testTaskModel.completed,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      )).thenAnswer((_) async => http.Response('true', 200));

      // Act
      final result = await taskRemoteDataSourceImpl.updateTask(testTaskModel);

      // Assert
      expect(result, isA<bool>());
    });

    test(
      'should throw a server exception when the response code is 400 or other',
      () async {
        //arrange
        when(mockHttpClient.put(
          Uri.parse('${ApiEndpoints.tasks}/${testTaskModel.id}'),
          body: jsonEncode({
            'completed': testTaskModel.completed,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        )).thenAnswer((_) async => http.Response('Not found', 400));

        //act
        final result = taskRemoteDataSourceImpl.updateTask(testTaskModel);

        //assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });

  group('delete task from datasource', () {
    test('should return true when the response status code is 200', () async {
      // Arrange
      when(mockHttpClient.delete(
        Uri.parse('${ApiEndpoints.tasks}/${testTaskModel.id}'),
      )).thenAnswer((_) async => http.Response('true', 200));

      // Act
      final result =
          await taskRemoteDataSourceImpl.deleteTask(testTaskModel.id);

      // Assert
      expect(result, isA<bool>());
    });

    test(
      'should throw a server exception when the response code is 400 or other',
      () async {
        //arrange
        when(mockHttpClient.delete(
          Uri.parse('${ApiEndpoints.tasks}/${testTaskModel.id}'),
        )).thenAnswer((_) async => http.Response('Not found', 400));

        //act
        final result = taskRemoteDataSourceImpl.deleteTask(testTaskModel.id);

        //assert
        expect(result, throwsA(isA<ServerException>()));
      },
    );
  });
}
