import 'package:flutter/material.dart';
import 'package:productive_app/task_page/providers/tag_provider.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_widget.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = '/task-screen';

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  Future<void> loadData() async {
    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    await Provider.of<TaskProvider>(context, listen: false).getPriorities();
    await Provider.of<TagProvider>(context, listen: false).getTags();
  }

  @override
  void initState() {
    this.loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;

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
