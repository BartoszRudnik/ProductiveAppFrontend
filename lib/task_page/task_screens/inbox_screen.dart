import 'package:flutter/material.dart';
import 'package:productive_app/task_page/providers/tag_provider.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_widget.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
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
    final tasks = Provider.of<TaskProvider>(context).inboxTasks;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      print(tasks.elementAt(newIndex).position.toString() + ' ' + tasks.elementAt(newIndex).title);
                      print(tasks.elementAt(newIndex - 1).position.toString() + ' ' + tasks.elementAt(newIndex - 1).title);
                      newPosition = (tasks.elementAt(newIndex).position + tasks.elementAt(newIndex - 1).position) / 2;
                    } else {
                      print(tasks.elementAt(newIndex).position.toString() + ' ' + tasks.elementAt(newIndex).title);
                      newPosition = tasks.elementAt(newIndex).position / 2;
                    }
                  } else {
                    if (newIndex != tasks.length - 1) {
                      print(tasks.elementAt(newIndex).position.toString() + ' ' + tasks.elementAt(newIndex).title);
                      print(tasks.elementAt(newIndex + 1).position.toString() + ' ' + tasks.elementAt(newIndex + 1).title);
                      newPosition = (tasks.elementAt(newIndex).position + tasks.elementAt(newIndex + 1).position) / 2;
                    } else {
                      print(tasks.elementAt(newIndex).position.toString() + ' ' + tasks.elementAt(newIndex).title);
                      newPosition = tasks.elementAt(newIndex).position * 2;
                    }
                  }

                  final task = tasks.removeAt(oldIndex);
                  tasks.insert(newIndex, task);
                  Provider.of<TaskProvider>(context, listen: false).setInboxTasks(tasks);

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
