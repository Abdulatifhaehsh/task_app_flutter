import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_app/domain/entities/task_entity.dart';

class TaskList extends StatelessWidget {
  final List<TaskEntity> tasks;
  final Function(TaskEntity) onUpdate;
  final Function(TaskEntity) onDelete;

  const TaskList(
      {super.key,
      required this.tasks,
      required this.onUpdate,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tasks.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Slidable(
          key: ValueKey(task.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            // extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) => onDelete(task),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: Text(task.todo),
            trailing: Checkbox(
              value: task.completed,
              onChanged: (value) {
                onUpdate(task.copyWith(completed: value));
              },
            ),
          ),
        );
      },
    );
  }
}
