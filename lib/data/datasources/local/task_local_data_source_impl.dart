import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/data/datasources/local/task_local_data_source.dart';
import 'package:task_app/data/models/task_model.dart';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<TaskModel> tasks = (jsonDecode(tasksJson) as List)
          .map((taskJson) => TaskModel.fromJson(taskJson))
          .toList();
      return tasks;
    } else {
      return [];
    }
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks, int page) async {
    final prefs = await SharedPreferences.getInstance();
    List<TaskModel> allTasks = [];

    if (page > 0) {
      // If not the first page, retrieve the existing tasks
      final String? existingTasksJson = prefs.getString('tasks');
      if (existingTasksJson != null) {
        final List<dynamic> existingTasksList = jsonDecode(existingTasksJson);
        allTasks = existingTasksList
            .map((taskJson) => TaskModel.fromJson(taskJson))
            .toList();
      }
    }

    // Add new tasks to the list
    allTasks.addAll(tasks);

    // Save the updated list to SharedPreferences
    final String tasksJson =
        jsonEncode(allTasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }
}
