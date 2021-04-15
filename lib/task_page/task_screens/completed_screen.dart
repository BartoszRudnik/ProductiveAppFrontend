import 'package:flutter/material.dart';
import 'package:productive_app/task_page/providers/task_provider.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';
import 'package:productive_app/task_page/widgets/task_widget.dart';
import 'package:provider/provider.dart';

class CompletedScreen extends StatelessWidget {
  static const routeName = '/completed-screen';

  @override
  Widget build(BuildContext context) {
    final completedTasks = Provider.of<TaskProvider>(context).completedTasks;

    return Scaffold(
      appBar: TaskAppBar(title: 'Completed'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: completedTasks.length,
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  key: ValueKey(completedTasks[index].id),
                  value: completedTasks[index],
                  child: TaskWidget(
                    task: completedTasks[index],
                    taskKey: ValueKey(completedTasks[index].id),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
