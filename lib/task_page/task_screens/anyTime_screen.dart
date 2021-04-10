import 'package:flutter/material.dart';
import 'package:productive_app/task_page/providers/tag_provider.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_widget.dart';

class AnytimeScreen extends StatefulWidget {
  @override
  _AnytimeScreenState createState() => _AnytimeScreenState();
}

class _AnytimeScreenState extends State<AnytimeScreen> {
  Future<void> _loadData() async {
    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    await Provider.of<TaskProvider>(context, listen: false).getPriorities();
    await Provider.of<TagProvider>(context, listen: false).getTags();
  }

  @override
  void initState() {
    this._loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).anytimeTasks;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
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
      ),
    );
  }
}
