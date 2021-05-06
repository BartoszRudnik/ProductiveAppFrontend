import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:productive_app/task_page/providers/settings_provider.dart';
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
    await Provider.of<DelegateProvider>(context, listen: false).getCollaborators();
    await Provider.of<SettingsProvider>(context, listen: false).getFilterSettings();
  }

  @override
  void initState() {
    this._loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = Provider.of<TaskProvider>(context).anytimeTasks;
    final userSettings = Provider.of<SettingsProvider>(context).userSettings;

    if (userSettings.showOnlyUnfinished != null && userSettings.showOnlyUnfinished) {
      tasks = Provider.of<TaskProvider>(context, listen: false).onlyUnfinishedTasks(tasks);
    }
    if (userSettings.showOnlyDelegated != null && userSettings.showOnlyDelegated) {
      tasks = Provider.of<TaskProvider>(context, listen: false).onlyDelegatedTasks(tasks);
    }
    if (userSettings.collaborators != null && userSettings.collaborators.length >= 1) {
      tasks = Provider.of<TaskProvider>(context, listen: false).filterCollaboratorEmail(tasks, userSettings.collaborators);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () => Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
              child: tasks.length == 0
                  ? SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text('Your anytime list is empty'),
                        ),
                      ),
                    )
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
