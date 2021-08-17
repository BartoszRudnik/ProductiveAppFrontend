import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widget/appBar/delete_appBar.dart';
import '../widget/task_widget.dart';

class TrashScreen extends StatelessWidget {
  static const routeName = '/trash-screen';

  @override
  Widget build(BuildContext context) {
    final trashTasks = Provider.of<TaskProvider>(context).trashTasks;

    return Scaffold(
      appBar: DeleteAppBar(title: 'Trash'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trashTasks.length,
                itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                  key: ValueKey(trashTasks[index].id),
                  value: trashTasks[index],
                  child: TaskWidget(
                    task: trashTasks[index],
                    key: UniqueKey(),
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
