import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import 'task_widget.dart';

class ReorderableTaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function onReorder;

  ReorderableTaskList({
    @required this.tasks,
    @required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.tasks.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        key: ValueKey(this.tasks[index]),
        value: this.tasks[index],
        child: TaskWidget(
          task: this.tasks[index],
          key: ValueKey(this.tasks[index]),
        ),
      ),
      onReorder: (int oldIndex, int newIndex) {
        this.onReorder(newIndex, oldIndex, this.tasks, context);
      },
    );
  }
}
