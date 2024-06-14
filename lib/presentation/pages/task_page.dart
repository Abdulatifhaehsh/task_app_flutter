import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/presentation/pages/login_page.dart';
import 'package:task_app/presentation/pages/task_detail_page.dart';
import 'package:task_app/presentation/state_management/provider/auth_provider.dart';
import 'package:task_app/presentation/state_management/provider/task_provider.dart';
import 'package:task_app/presentation/widgets/spin_kit_fading_four.dart';
import 'package:task_app/presentation/widgets/task_list.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks when the page is initialized
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    Provider.of<TaskProvider>(context, listen: false).mainScrollListener();
  }

  void handleUpdate(TaskEntity task) {
    // Update task logic
    Provider.of<TaskProvider>(context, listen: false).updateTask(task);
  }

  void handleDelete(TaskEntity task) {
    // Delete task logic
    Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id);
  }

  void handleLogout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).refetchTasks();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (taskProvider.error != null) {
            return Center(child: Text(taskProvider.error!));
          } else {
            return SingleChildScrollView(
              controller: Provider.of<TaskProvider>(context, listen: false)
                  .mainScrollController,
              child: Column(
                children: [
                  TaskList(
                    tasks: taskProvider.tasks,
                    onUpdate: handleUpdate,
                    onDelete: handleDelete,
                  ),
                  (Provider.of<TaskProvider>(context, listen: false)
                          .moreDataForAllProducts)
                      ? SpinKitFadingFour(
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        )
                      : Container()
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
