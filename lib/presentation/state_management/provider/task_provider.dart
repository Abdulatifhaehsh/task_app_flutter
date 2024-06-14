import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/domain/usecases/task_usecase.dart';
import 'package:task_app/presentation/state_management/provider/auth_provider.dart';

class TaskProvider with ChangeNotifier {
  final FetchTasksUseCase fetchTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  final List<TaskEntity> _tasks = [];
  bool _isLoading = true;
  int _page = 0;
  String? _error;
  ScrollController mainScrollController = ScrollController();
  bool _moreDataForAllProducts = false;

  List<TaskEntity> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get moreDataForAllProducts => _moreDataForAllProducts;
  String? get error => _error;

  TaskProvider({
    required this.fetchTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  });

  Future<void> fetchTasks() async {
    _error = null;
    final result = await fetchTasksUseCase(_page);
    result.fold((left) {
      _error = left.message;
    }, (right) {
      _tasks.addAll(right);
      _page++;
    });
    _isLoading = false;
    _moreDataForAllProducts = false;
    notifyListeners();
  }

  Future<void> refetchTasks() async {
    _isLoading = true;
    _error = null;
    _page = 0;
    _tasks.clear();
    notifyListeners();

    final result = await fetchTasksUseCase(_page);
    result.fold((left) {
      _error = left.message;
    }, (right) {
      _tasks.addAll(right);
      _page++;
    });
    _isLoading = false;
    _moreDataForAllProducts = false;
    notifyListeners();
  }

  mainScrollListener() {
    mainScrollController.addListener(() {
      if (mainScrollController.position.pixels ==
          mainScrollController.position.maxScrollExtent) {
        _moreDataForAllProducts = true;
        notifyListeners();
        fetchTasks();
      }
    });
  }

  Future<void> addTask(BuildContext context, TaskEntity task) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;
    final result = await addTaskUseCase(task.copyWith(userId: userId));
    result.fold((left) {
      _error = left.message;
    }, (right) {
      _tasks.insert(0, right);
    });
    notifyListeners();
  }

  Future<void> updateTask(TaskEntity task) async {
    await updateTaskUseCase(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    await deleteTaskUseCase(taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
