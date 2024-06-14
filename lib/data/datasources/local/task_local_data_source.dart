import 'package:task_app/data/models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTasks(List<TaskModel> tasks, int page);
}
