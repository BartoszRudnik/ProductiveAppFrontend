import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> taskList = [
    Task(
      id: '1',
      title: 'Example taks 1 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '2',
      title: 'Example taks 2 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '3',
      title: 'Example taks 3 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '4',
      title: 'Example taks 4 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '5',
      title: 'Example taks 5 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '6',
      title: 'Example taks 6 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '7',
      title: 'Example taks 7 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '8',
      title: 'Example taks 8 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '9',
      title: 'Example taks 9 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
    Task(
      id: '10',
      title: 'Example taks 10 long task title test',
      startDate: '2021-01-11',
      endDate: '2021-03-14',
      tags: [
        'tag1',
        'tag2',
      ],
      done: false,
    ),
  ];

  final String userMail;
  final String authToken;

  TaskProvider({
    @required this.userMail,
    @required this.authToken,
    //@required this.taskList,
  });

  List<Task> get tasks {
    return [...this.taskList];
  }

  Future<void> addTask(Task task) async {}

  Future<void> updateTask(String id, Task task) async {}

  Future<void> fetchTasks() async {}

  Future<void> deleteTask(String id) async {}
}
