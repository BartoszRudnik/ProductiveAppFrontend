import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../provider/location_provider.dart';
import '../provider/settings_provider.dart';
import '../provider/tag_provider.dart';
import '../provider/task_provider.dart';
import '../utils/manage_filters.dart';
import '../widget/empty_list.dart';
import '../widget/task_widget.dart';

class DelegatedScreen extends StatefulWidget {
  @override
  _DelegatedScreenState createState() => _DelegatedScreenState();
}

class _DelegatedScreenState extends State<DelegatedScreen> {
  Future<void> _loadData() async {
    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    await Provider.of<TaskProvider>(context, listen: false).getPriorities();
    await Provider.of<TagProvider>(context, listen: false).getTags();
    await Provider.of<LocationProvider>(context, listen: false).getLocations();
    await Provider.of<SettingsProvider>(context, listen: false).getFilterSettings();
  }

  @override
  void initState() {
    this._loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = Provider.of<TaskProvider>(context).delegatedTasks;
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
                  ? EmptyList(message: 'Your delegated list is empty')
                  : ReorderableListView.builder(
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
          ),
        ],
      ),
    );
  }
}
