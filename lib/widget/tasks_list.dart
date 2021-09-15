import 'package:flutter/material.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/widget/task_widget.dart';

class TasksList extends StatelessWidget {
  final List<Task> tasks;

  TasksList({
    @required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) => TaskWidget(
        task: tasks[index],
        key: ValueKey(tasks[index]),
      ),
    );
  }
}
