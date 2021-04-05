import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> archivedList = [];

  List<Task> taskList = [];

  final String userMail;
  final String authToken;

  String _serverUrl = 'http://192.168.1.120:8080/api/v1/';

  TaskProvider({
    @required this.userMail,
    @required this.authToken,
    //@required this.taskList,
  });

  List<Task> get tasks {
    return [...this.taskList];
  }

  Future<void> addTask(Task task) async {
    String url = this._serverUrl + 'task/add';

    try {
      await http.post(
        url,
        body: json.encode(
          {
            'taskName': task.title,
            'taskDescription': task.description,
            'userEmail': this.userMail,
            'startDate': task.startDate.toIso8601String(),
            'endDate': task.endDate.toIso8601String(),
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      this.taskList.add(task);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateTask(String id, Task task) async {}

  Future<void> fetchTasks() async {}

  Future<void> deleteTask(int index) async {
    this.taskList.removeAt(index);
  }
}
