import 'package:flutter/material.dart';
import 'package:productive_app/model/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              label: Text(AppLocalizations.of(context).archive),
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
              label: Text(
                this.widget.taskToEdit.done ? AppLocalizations.of(context).unmarkAsDone : AppLocalizations.of(context).markAsDone,
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
              label: Text(AppLocalizations.of(context).save),
            ),
          ),
        ],
      ),
    );
  }
}
