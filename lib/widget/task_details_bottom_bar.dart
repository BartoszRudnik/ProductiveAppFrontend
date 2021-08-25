import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../model/task.dart';

class TaskDetailsBottomBar extends StatefulWidget {
  final Function deleteTask;
  final Function saveTask;
  Task taskToEdit;

  TaskDetailsBottomBar({
    @required this.deleteTask,
    @required this.saveTask,
    @required this.taskToEdit,
  });

  @override
  _TaskDetailsBottomBarState createState() => _TaskDetailsBottomBarState();
}

class _TaskDetailsBottomBarState extends State<TaskDetailsBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextButton.icon(
              onPressed: () => this.widget.deleteTask(),
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).primaryColor,
              ),
              icon: Icon(Icons.delete),
              label: Flexible(
                child: AutoSizeText(
                  AppLocalizations.of(context).archive,
                  minFontSize: 10,
                  maxFontSize: 16,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  this.widget.taskToEdit.done = !this.widget.taskToEdit.done;
                });
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).primaryColor,
              ),
              icon: Icon(this.widget.taskToEdit.done ? Icons.cancel : Icons.done),
              label: Flexible(
                child: AutoSizeText(
                  this.widget.taskToEdit.done ? AppLocalizations.of(context).unmarkAsDone : AppLocalizations.of(context).markAsDone,
                  minFontSize: 10,
                  maxFontSize: 16,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: TextButton.icon(
              onPressed: () => this.widget.saveTask(),
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).primaryColor,
              ),
              icon: Icon(Icons.save),
              label: Flexible(
                child: AutoSizeText(
                  AppLocalizations.of(context).save,
                  minFontSize: 10,
                  maxFontSize: 16,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
