import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_widget.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = '/task-screen';

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loadedTasks = Provider.of<TaskProvider>(context);
    final tasks = loadedTasks.tasks;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              key: ValueKey(tasks[index].id),
              value: tasks[index],
              child: TaskWidget(
                task: tasks[index],
                taskKey: ValueKey(tasks[index].id),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
