import 'package:flutter/material.dart';
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
  }

  @override
  void initState() {
    this._loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final before = Provider.of<TaskProvider>(context).tasksBeforeToday();
    final today = Provider.of<TaskProvider>(context).tasksToday();
    final after = Provider.of<TaskProvider>(context).taskAfterToday();

    return SingleChildScrollView(
      physics: ScrollPhysics(),
      padding: const EdgeInsets.only(left: 21, right: 17, top: 10),
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
                          print(before.elementAt(newIndex).position.toString() + ' ' + before.elementAt(newIndex).title);
                          print(before.elementAt(newIndex - 1).position.toString() + ' ' + before.elementAt(newIndex - 1).title);
                          newPosition = (before.elementAt(newIndex).position + before.elementAt(newIndex - 1).position) / 2;
                        } else {
                          print(before.elementAt(newIndex).position.toString() + ' ' + before.elementAt(newIndex).title);
                          newPosition = before.elementAt(newIndex).position / 2;
                        }
                      } else {
                        if (newIndex != before.length - 1) {
                          print(before.elementAt(newIndex).position.toString() + ' ' + before.elementAt(newIndex).title);
                          print(before.elementAt(newIndex + 1).position.toString() + ' ' + before.elementAt(newIndex + 1).title);
                          newPosition = (before.elementAt(newIndex).position + before.elementAt(newIndex + 1).position) / 2;
                        } else {
                          print(before.elementAt(newIndex).position.toString() + ' ' + before.elementAt(newIndex).title);
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
                          print(today.elementAt(newIndex).position.toString() + ' ' + today.elementAt(newIndex).title);
                          print(today.elementAt(newIndex - 1).position.toString() + ' ' + today.elementAt(newIndex - 1).title);
                          newPosition = (today.elementAt(newIndex).position + today.elementAt(newIndex - 1).position) / 2;
                        } else {
                          print(today.elementAt(newIndex).position.toString() + ' ' + today.elementAt(newIndex).title);
                          newPosition = today.elementAt(newIndex).position / 2;
                        }
                      } else {
                        if (newIndex != today.length - 1) {
                          print(today.elementAt(newIndex).position.toString() + ' ' + today.elementAt(newIndex).title);
                          print(today.elementAt(newIndex + 1).position.toString() + ' ' + today.elementAt(newIndex + 1).title);
                          newPosition = (today.elementAt(newIndex).position + today.elementAt(newIndex + 1).position) / 2;
                        } else {
                          print(today.elementAt(newIndex).position.toString() + ' ' + today.elementAt(newIndex).title);
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
                          print(after.elementAt(newIndex).position.toString() + ' ' + after.elementAt(newIndex).title);
                          print(after.elementAt(newIndex - 1).position.toString() + ' ' + after.elementAt(newIndex - 1).title);
                          newPosition = (after.elementAt(newIndex).position + after.elementAt(newIndex - 1).position) / 2;
                        } else {
                          print(after.elementAt(newIndex).position.toString() + ' ' + after.elementAt(newIndex).title);
                          newPosition = after.elementAt(newIndex).position / 2;
                        }
                      } else {
                        if (newIndex != after.length - 1) {
                          print(after.elementAt(newIndex).position.toString() + ' ' + after.elementAt(newIndex).title);
                          print(after.elementAt(newIndex + 1).position.toString() + ' ' + after.elementAt(newIndex + 1).title);
                          newPosition = (after.elementAt(newIndex).position + after.elementAt(newIndex + 1).position) / 2;
                        } else {
                          print(after.elementAt(newIndex).position.toString() + ' ' + after.elementAt(newIndex).title);
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
    );
  }
}
