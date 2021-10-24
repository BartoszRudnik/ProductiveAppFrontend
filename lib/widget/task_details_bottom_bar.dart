import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/task.dart';

class TaskDetailsBottomBar extends StatelessWidget {
  final Function deleteTask;
  final Function saveTask;
  final Function setDone;
  final Task taskToEdit;

  TaskDetailsBottomBar({
    @required this.deleteTask,
    @required this.saveTask,
    @required this.taskToEdit,
    @required this.setDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextButton.icon(
              onPressed: () => this.deleteTask(),
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).primaryColor,
              ),
              icon: Icon(Icons.delete),
              label: Row(
                children: [
                  Flexible(
                    child: AutoSizeText(
                      AppLocalizations.of(context).archive,
                      minFontSize: 10,
                      maxFontSize: 16,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: TextButton.icon(
              onPressed: () {
                this.setDone();
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).primaryColor,
              ),
              icon: Icon(this.taskToEdit != null && this.taskToEdit.done ? Icons.cancel : Icons.done),
              label: Row(
                children: [
                  Flexible(
                    child: AutoSizeText(
                      this.taskToEdit != null && this.taskToEdit.done ? AppLocalizations.of(context).unmarkAsDone : AppLocalizations.of(context).markAsDone,
                      minFontSize: 10,
                      maxFontSize: 16,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: TextButton.icon(
              onPressed: () => this.saveTask(),
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).primaryColor,
              ),
              icon: Icon(Icons.save),
              label: Row(
                children: [
                  Flexible(
                    child: AutoSizeText(
                      AppLocalizations.of(context).save,
                      minFontSize: 10,
                      maxFontSize: 16,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
