import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../provider/settings_provider.dart';
import '../provider/task_provider.dart';
import '../utils/manage_filters.dart';
import '../widget/empty_list.dart';
import '../widget/task_widget.dart';

class InboxScreen extends StatefulWidget {
  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks = Provider.of<TaskProvider>(context).inboxTasks;
    final userSettings = Provider.of<SettingsProvider>(context).userSettings;

    tasks = ManageFilters.filter(tasks, userSettings, context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () => Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
              child: tasks.length == 0
                  ? EmptyList(message: 'Your inbox is empty')
                  : ReorderableListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                          Provider.of<TaskProvider>(context, listen: false).setInboxTasks(tasks);
                          Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
