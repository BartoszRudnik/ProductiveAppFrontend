import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/task_screens/task_details_screen.dart';

class InboxScreen extends StatefulWidget {
  static const routeName = '/task-screen';

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  var tasks = [
    {
      'title': 'Example taks 1',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example task 2',
      'startDate': '2021-03-20',
      'endDate': '2021-05-29',
      'tag': 'tag2',
      'done': false,
    },
    {
      'title': 'Example taks 3',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 4',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 5',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 6',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 7',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 8',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 9',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 10',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
    {
      'title': 'Example taks 11',
      'startDate': '2021-01-11',
      'endDate': '2021-03-14',
      'tag': 'tag1',
      'done': false,
    },
  ];

  void _changeTaskStatus(int index) {
    setState(() {
      tasks[index]['done'] = !tasks[index]['done'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(TaskDetailScreen.routeName);
                },
                child: ListTile(
                  minLeadingWidth: 7,
                  leading: RawMaterialButton(
                    focusElevation: 0,
                    child: tasks[index]['done']
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 14,
                          )
                        : null,
                    onPressed: () => _changeTaskStatus(index),
                    constraints: BoxConstraints(minWidth: 20, minHeight: 18),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    fillColor: tasks[index]['done'] ? Colors.grey : Theme.of(context).accentColor,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  title: Text(
                    tasks[index]['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'RobotoCondensed',
                      decoration: tasks[index]['done'] ? TextDecoration.lineThrough : null,
                      color: tasks[index]['done'] ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                  ),
                  subtitle: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.arrow_upward_sharp),
                          SizedBox(width: 6),
                          Icon(Icons.calendar_today),
                          SizedBox(width: 6),
                          Text(
                            DateFormat('MMM d').format(DateTime.parse(tasks[index]['startDate'])) + ' - ',
                          ),
                          Text(
                            DateFormat('MMM d').format(DateTime.parse(tasks[index]['endDate'])),
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
                                tasks[index]['tag'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
