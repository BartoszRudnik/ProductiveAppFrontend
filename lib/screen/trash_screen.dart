import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/task_provider.dart';
import '../widget/appBar/delete_appBar.dart';
import '../widget/task_widget.dart';

class TrashScreen extends StatelessWidget {
  static const routeName = '/trash-screen';

  @override
  Widget build(BuildContext context) {
    final trashTasks = Provider.of<TaskProvider>(context).filteredTrashTasks;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop();
        Provider.of<TaskProvider>(context, listen: false).clearTrashName();
      },
      child: Scaffold(
        appBar: DeleteAppBar(title: AppLocalizations.of(context).trash),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: trashTasks.length,
                  itemBuilder: (ctx, index) => TaskWidget(
                    task: trashTasks[index],
                    key: UniqueKey(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
