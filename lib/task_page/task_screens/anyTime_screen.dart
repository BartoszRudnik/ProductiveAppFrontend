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
            child: ReorderableListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                key: ValueKey(tasks[index]),
                value: tasks[index],
                child: TaskWidget(
                  task: tasks[index],
                  key: ValueKey(tasks[index]),
                ),
              ),
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex > tasks.length) newIndex = tasks.length;
                if (oldIndex < newIndex) newIndex -= 1;

                setState(() {
                  final item = tasks.elementAt(oldIndex);
                  double newPosition = item.position;

                  if (newIndex < oldIndex) {
                    if (newIndex != 0) {
                      newPosition = (tasks.elementAt(newIndex).position + tasks.elementAt(newIndex - 1).position) / 2;
                    } else {
                      newPosition = tasks.elementAt(newIndex).position / 2;
                    }
                  } else {
                    if (newIndex != tasks.length - 1) {
                      newPosition = (tasks.elementAt(newIndex).position + tasks.elementAt(newIndex + 1).position) / 2;
                    } else {
                      newPosition = tasks.elementAt(newIndex).position * 2;
                    }
                  }

                  final task = tasks.removeAt(oldIndex);
                  tasks.insert(newIndex, task);
                  Provider.of<TaskProvider>(context, listen: false).setAnytimeTasks(tasks);

                  Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
