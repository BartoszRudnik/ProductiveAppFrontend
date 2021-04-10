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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: before.length,
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    key: ValueKey(before[index].id),
                    value: before[index],
                    child: TaskWidget(
                      task: before[index],
                      taskKey: ValueKey(before[index].id),
                    ),
                  ),
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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: today.length,
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    key: ValueKey(today[index].id),
                    value: today[index],
                    child: TaskWidget(
                      task: today[index],
                      taskKey: ValueKey(today[index].id),
                    ),
                  ),
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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: after.length,
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    key: ValueKey(after[index].id),
                    value: after[index],
                    child: TaskWidget(
                      task: after[index],
                      taskKey: ValueKey(after[index].id),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
