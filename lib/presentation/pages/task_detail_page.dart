import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:task_app/domain/entities/task_entity.dart';
import 'package:task_app/presentation/state_management/provider/task_provider.dart';

class TaskDetailPage extends HookWidget {
  final TaskEntity? task;

  TaskDetailPage({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final todoController = useTextEditingController();
    final completed = useState(false);

    useEffect(() {
      if (task != null) {
        todoController.text = task!.todo;
        completed.value = task!.completed;
      }
      return null;
    }, [task]);

    final todoAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    final todoAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.1, 0),
    )
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(todoAnimationController);

    void shakeTextField() {
      todoAnimationController
          .forward()
          .then((_) => todoAnimationController.reverse());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SlideTransition(
                position: todoAnimation,
                child: TextFormField(
                  controller: todoController,
                  decoration: const InputDecoration(labelText: 'Todo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your todo';
                    }
                    return null;
                  },
                ),
              ),
              CheckboxListTile(
                value: completed.value,
                title: const Text('Completed'),
                onChanged: (value) {
                  completed.value = value ?? false;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (task == null) {
                      // Add new task
                      Provider.of<TaskProvider>(context, listen: false).addTask(
                        context,
                        TaskEntity(
                          id: DateTime.now().millisecondsSinceEpoch,
                          todo: todoController.text.trim(),
                          completed: completed.value,
                        ),
                      );
                    } else {
                      // Update existing task
                      Provider.of<TaskProvider>(context, listen: false)
                          .updateTask(
                        TaskEntity(
                          id: task!.id,
                          todo: todoController.text.trim(),
                          completed: completed.value,
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  } else {
                    if (todoController.text.isEmpty) {
                      shakeTextField();
                    }
                  }
                },
                child: Text(task == null ? 'Add Task' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
