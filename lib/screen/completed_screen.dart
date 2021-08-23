import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task_provider.dart';
import '../widget/appBar/delete_appBar.dart';
import '../widget/task_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompletedScreen extends StatelessWidget {
  static const routeName = '/completed-screen';

  @override
  Widget build(BuildContext context) {
    final completedTasks = Provider.of<TaskProvider>(context).completedTasks;

    return Scaffold(
      appBar: DeleteAppBar(title: AppLocalizations.of(context).completed),
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
