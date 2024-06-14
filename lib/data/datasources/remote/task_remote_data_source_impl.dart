import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/api_endpoints.dart';
import 'package:task_app/core/errors/exceptions.dart';
import 'package:task_app/data/datasources/remote/task_remote_data_source.dart';
import 'package:task_app/data/models/task_model.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;

  TaskRemoteDataSourceImpl({required this.client});
  @override
  Future<List<TaskModel>> fetchTasks(int page) async {
    final response = await client.get(
      Uri.parse('${ApiEndpoints.tasks}?limit=12&skip=${page * 12}'),
    );

    if (response.statusCode == 200) {
      final List<TaskModel> tasks = (jsonDecode(response.body)['todos'] as List)
          .map((taskJson) => TaskModel.fromJson(taskJson))
          .toList();
      return tasks;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    final response = await client.post(
      Uri.parse('${ApiEndpoints.tasks}/add'),
      body: jsonEncode(task.toJson()),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 201) {
      throw ServerException();
    }

    return TaskModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<bool> updateTask(TaskModel task) async {
    final response = await client.put(
      Uri.parse('${ApiEndpoints.tasks}/${task.id}'),
      body: jsonEncode({
        'completed': task.completed,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
    return true;
  }

  @override
  Future<bool> deleteTask(int taskId) async {
    final response = await client.delete(
      Uri.parse('${ApiEndpoints.tasks}/$taskId'),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return true;
  }
}
