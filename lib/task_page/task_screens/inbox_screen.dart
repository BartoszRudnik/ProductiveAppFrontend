import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/providers/task_provider.dart';
import 'package:productive_app/task_page/task_screens/task_details_screen.dart';
import 'package:provider/provider.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = '/task-screen';

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    final loadedTasks = Provider.of<TaskProvider>(context);
    final tasks = loadedTasks.tasks;

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => Container(
                height: 94,
                width: 319,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 7,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(TaskDetailScreen.routeName);
                  },
                  child: Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.5,
                    actions: [
                      IconSlideAction(
                        caption: 'Move to Anytime',
                        color: Theme.of(context).accentColor,
                        onTap: () {},
                        iconWidget: Icon(
                          Icons.access_time_sharp,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconSlideAction(
                        caption: 'Move to Scheduled',
                        color: Theme.of(context).accentColor,
                        onTap: () {},
                        iconWidget: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Mark as done',
                        color: Theme.of(context).accentColor,
                        onTap: () {
                          setState(() {
                            tasks[index].changeTaskStatus();
                          });
                        },
                        iconWidget: Icon(
                          Icons.done,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconSlideAction(
                        caption: 'Archive',
                        color: Theme.of(context).accentColor,
                        onTap: () {},
                        iconWidget: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RawMaterialButton(
                              focusElevation: 0,
                              child: tasks[index].done
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                              onPressed: () {
                                setState(() {
                                  tasks[index].changeTaskStatus();
                                });
                              },
                              constraints: BoxConstraints(minWidth: 20, minHeight: 18),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              fillColor: tasks[index].done ? Colors.grey : Theme.of(context).accentColor,
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              tasks[index].title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'RobotoCondensed',
                                decoration: tasks[index].done ? TextDecoration.lineThrough : null,
                                color: tasks[index].done ? Colors.grey : Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.arrow_upward_sharp),
                                SizedBox(width: 6),
                                Icon(Icons.calendar_today),
                                SizedBox(width: 6),
                                Text(
                                  DateFormat('MMM d').format(DateTime.parse(tasks[index].startDate)) + ' - ',
                                ),
                                Text(
                                  DateFormat('MMM d').format(DateTime.parse(tasks[index].endDate)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 48.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 0.2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      tasks[index].tags[0],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: tasks.length,
            ),
          ),
        ],
      ),
    );
  }
}
