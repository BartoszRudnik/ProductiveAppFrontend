import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/widgets/is_done_button.dart';
import 'package:productive_app/task_page/widgets/task_tags.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../task_screens/task_details_screen.dart';

class TaskWidget extends StatefulWidget {
  final task;
  final key;

  TaskWidget({
    @required this.task,
    @required this.key,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  void changeTaskStatus() {
    Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(this.widget.task);
  }

  @override
  Widget build(BuildContext context) {
    bool isArchived = (this.widget.task.localization == 'COMPLETED' || this.widget.task.localization == 'TRASH');

    return Container(
      width: 319,
      padding: EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(TaskDetailScreen.routeName, arguments: this.widget.task);
        },
        child: Dismissible(
          key: this.widget.key,
          background: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Icon(
                  isArchived ? Icons.restore_from_trash_outlined : Icons.navigate_next_outlined,
                  color: Theme.of(context).accentColor,
                  size: 50,
                ),
                Text(
                  isArchived ? 'Restore task' : 'Move task',
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          secondaryBackground: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerRight,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  isArchived ? 'Delete' : 'Archive',
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Icon(
                  Icons.archive_outlined,
                  color: Theme.of(context).accentColor,
                  size: 40,
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) {
            if (direction == DismissDirection.endToStart) {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Center(
                    child: Text(
                      isArchived ? 'Delete' : 'Archive',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isArchived ? 'Are you sure you want to delete this task?' : 'Are you sure you want to archive this task?',
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              side: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              if (!isArchived) {
                                String newLocation = 'INBOX';

                                if (this.widget.task.done) {
                                  newLocation = 'COMPLETED';
                                } else {
                                  newLocation = 'TRASH';
                                }
                                Provider.of<TaskProvider>(context, listen: false).updateTask(this.widget.task, newLocation);
                              } else {
                                Provider.of<TaskProvider>(context, listen: false).deleteTask(this.widget.task.id);
                              }

                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              side: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            if (direction == DismissDirection.startToEnd) {
              String newLocation;

              if (this.widget.task.delegatedEmail == null) {
                if (this.widget.task.startDate != null) {
                  newLocation = 'SCHEDULED';
                } else {
                  newLocation = 'ANYTIME';
                }
              } else {
                newLocation = 'DELEGATED';
              }

              Provider.of<TaskProvider>(context, listen: false).updateTask(this.widget.task, newLocation);
            }
          },
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  if (!isArchived)
                    IsDoneButton(
                      isDone: this.widget.task.done,
                      changeIsDoneStatus: this.changeTaskStatus,
                    ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    this.widget.task.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'RobotoCondensed',
                      decoration: this.widget.task.done ? TextDecoration.lineThrough : null,
                      color: this.widget.task.done ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 7),
                  if (this.widget.task.isDelegated != null && this.widget.task.isDelegated) Icon(Icons.supervisor_account_outlined),
                  if (this.widget.task.delegatedEmail != null && this.widget.task.localization == 'DELEGATED' && this.widget.task.taskStatus != null)
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 0.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          this.widget.task.taskStatus,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 9,
              ),
              Column(
                children: <Widget>[
                  if (this.widget.task.priority != 'NORMAL' || this.widget.task.startDate != null || this.widget.task.endDate != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: [
                              if (this.widget.task.priority == 'LOW') Icon(Icons.arrow_downward_outlined),
                              if (this.widget.task.priority == 'HIGH') Icon(Icons.arrow_upward_outlined),
                              if (this.widget.task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                              if (this.widget.task.priority == 'HIGHER') Icon(Icons.arrow_upward_outlined),
                              if (this.widget.task.priority == 'CRITICAL') Icon(Icons.warning_amber_sharp),
                              SizedBox(width: 6),
                              if (this.widget.task.startDate != null || this.widget.task.endDate != null) Icon(Icons.calendar_today),
                              SizedBox(width: 6),
                              this.widget.task.startDate != null
                                  ? Text(
                                      DateFormat('MMM d').format(this.widget.task.startDate) + ' - ',
                                    )
                                  : Text(''),
                              this.widget.task.endDate != null
                                  ? Text(
                                      DateFormat('MMM d').format(this.widget.task.endDate),
                                    )
                                  : Text(''),
                            ],
                          ),
                        ),
                        if (this.widget.task.endDate != null)
                          Container(
                            child: Row(
                              children: [
                                if (this.widget.task.endDate.difference(DateTime.now()).inDays == 0) Icon(Icons.access_time_outlined),
                                if (this.widget.task.endDate.difference(DateTime.now()).inDays == 0)
                                  Text(
                                    DateFormat('Hm').format(this.widget.task.endDate),
                                  ),
                                if (this.widget.task.endDate.difference(DateTime.now()).inDays < 0) Icon(Icons.fireplace_outlined),
                                if (this.widget.task.endDate.difference(DateTime.now()).inDays < 0) Text(DateTime.now().difference(this.widget.task.endDate).inDays.toString() + 'd overude'),
                                if (this.widget.task.endDate.difference(DateTime.now()).inDays > 0) Icon(Icons.hourglass_bottom_outlined),
                                if (this.widget.task.endDate.difference(DateTime.now()).inDays > 0) Text(this.widget.task.endDate.difference(DateTime.now()).inDays.toString() + 'd left'),
                              ],
                            ),
                          )
                      ],
                    ),
                  if (this.widget.task.priority != 'NORMAL' || this.widget.task.startDate != null || this.widget.task.endDate != null || this.widget.task.isDelegated != null)
                    SizedBox(
                      height: 4,
                    ),
                  TaskTags(tags: this.widget.task.tags),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
