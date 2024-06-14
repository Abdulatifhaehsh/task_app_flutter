import 'package:task_app/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> fetchTasks(int page);
  Future<TaskModel> addTask(TaskModel task);
  Future<bool> updateTask(TaskModel task);
  Future<bool> deleteTask(int taskId);
}
