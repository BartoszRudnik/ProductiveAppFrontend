import 'package:flutter/material.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:productive_app/task_page/providers/settings_provider.dart';
import 'package:productive_app/task_page/utils/manage_filters.dart';
import 'package:provider/provider.dart';

import '../providers/tag_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_widget.dart';

class ScheduledScreen extends StatefulWidget {
  @override
  _ScheduledScreenState createState() => _ScheduledScreenState();
}

class _ScheduledScreenState extends State<ScheduledScreen> {
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
    List<Task> before = Provider.of<TaskProvider>(context).tasksBeforeToday();
    List<Task> today = Provider.of<TaskProvider>(context).tasksToday();
    List<Task> after = Provider.of<TaskProvider>(context).taskAfterToday();

    final userSettings = Provider.of<SettingsProvider>(context).userSettings;

    before = ManageFilters.filter(before, userSettings, context);
    today = ManageFilters.filter(today, userSettings, context);
    after = ManageFilters.filter(after, userSettings, context);

    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      onRefresh: () => Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
      child: before.length == 0 && today.length == 0 && after.length == 0
          ? SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('Your scheduled list is empty'),
                ),
              ),
            )
          : SingleChildScrollView(
              physics: ScrollPhysics(),
              padding: const EdgeInsets.only(left: 21, right: 17, top: 10),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (before.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Before Today',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                          ReorderableListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: before.length,
                            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                              key: ValueKey(before[index]),
                              value: before[index],
                              child: TaskWidget(
                                task: before[index],
                                key: ValueKey(before[index]),
                              ),
                            ),
                            onReorder: (int oldIndex, int newIndex) {
                              if (newIndex > before.length) newIndex = before.length;
                              if (oldIndex < newIndex) newIndex -= 1;

                              setState(() {
                                final item = before.elementAt(oldIndex);
                                double newPosition = item.position;

                                if (newIndex < oldIndex) {
                                  if (newIndex != 0) {
                                    newPosition = (before.elementAt(newIndex).position + before.elementAt(newIndex - 1).position) / 2;
                                  } else {
                                    newPosition = before.elementAt(newIndex).position / 2;
                                  }
                                } else {
                                  if (newIndex != before.length - 1) {
                                    newPosition = (before.elementAt(newIndex).position + before.elementAt(newIndex + 1).position) / 2;
                                  } else {
                                    newPosition = before.elementAt(newIndex).position * 2;
                                  }
                                }

                                final task = before.removeAt(oldIndex);
                                before.insert(newIndex, task);
                                before.addAll(after);
                                before.addAll(today);
                                Provider.of<TaskProvider>(context, listen: false).setScheduledTasks(before);

                                Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                              });
                            },
                          ),
                        ],
                      ),
                    if (today.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                          ReorderableListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: today.length,
                            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                              key: ValueKey(today[index]),
                              value: today[index],
                              child: TaskWidget(
                                task: today[index],
                                key: ValueKey(today[index]),
                              ),
                            ),
                            onReorder: (int oldIndex, int newIndex) {
                              if (newIndex > today.length) newIndex = today.length;
                              if (oldIndex < newIndex) newIndex -= 1;

                              setState(() {
                                final item = today.elementAt(oldIndex);
                                double newPosition = item.position;

                                if (newIndex < oldIndex) {
                                  if (newIndex != 0) {
                                    newPosition = (today.elementAt(newIndex).position + today.elementAt(newIndex - 1).position) / 2;
                                  } else {
                                    newPosition = today.elementAt(newIndex).position / 2;
                                  }
                                } else {
                                  if (newIndex != today.length - 1) {
                                    newPosition = (today.elementAt(newIndex).position + today.elementAt(newIndex + 1).position) / 2;
                                  } else {
                                    newPosition = today.elementAt(newIndex).position * 2;
                                  }
                                }

                                final task = today.removeAt(oldIndex);
                                today.insert(newIndex, task);
                                today.addAll(before);
                                today.addAll(after);
                                Provider.of<TaskProvider>(context, listen: false).setScheduledTasks(today);

                                Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                              });
                            },
                          ),
                        ],
                      ),
                    if (after.length > 0)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'After Today',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Theme.of(context).primaryColor,
                          ),
                          ReorderableListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: after.length,
                            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                              key: ValueKey(after[index]),
                              value: after[index],
                              child: TaskWidget(
                                task: after[index],
                                key: ValueKey(after[index]),
                              ),
                            ),
                            onReorder: (int oldIndex, int newIndex) {
                              if (newIndex > after.length) newIndex = after.length;
                              if (oldIndex < newIndex) newIndex -= 1;

                              setState(() {
                                final item = after.elementAt(oldIndex);
                                double newPosition = item.position;

                                if (newIndex < oldIndex) {
                                  if (newIndex != 0) {
                                    newPosition = (after.elementAt(newIndex).position + after.elementAt(newIndex - 1).position) / 2;
                                  } else {
                                    newPosition = after.elementAt(newIndex).position / 2;
                                  }
                                } else {
                                  if (newIndex != after.length - 1) {
                                    newPosition = (after.elementAt(newIndex).position + after.elementAt(newIndex + 1).position) / 2;
                                  } else {
                                    newPosition = after.elementAt(newIndex).position * 2;
                                  }
                                }

                                final task = after.removeAt(oldIndex);
                                after.insert(newIndex, task);
                                after.addAll(before);
                                after.addAll(today);
                                Provider.of<TaskProvider>(context, listen: false).setScheduledTasks(after);

                                Provider.of<TaskProvider>(context, listen: false).updateTaskPosition(item, newPosition);
                              });
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
