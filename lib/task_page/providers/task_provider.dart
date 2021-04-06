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
    @required this.taskList,
  });

  List<Task> get tasks {
    return [...this.taskList];
  }

  Future<void> addTask(Task task) async {
    String url = this._serverUrl + 'task/add';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'taskName': task.title,
            'taskDescription': task.description,
            'userEmail': this.userMail,
            'startDate': task.startDate.toIso8601String(),
            'endDate': task.endDate.toIso8601String(),
            'ifDone': task.done,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      task.id = int.parse(response.body);

      this.taskList.add(task);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateTask(String id, Task task) async {}

  Future<void> fetchTasks() async {
    String url = this._serverUrl + 'task/getAll/${this.userMail}';

    final List<Task> loadedTasks = [];

    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body);

      for (var element in responseBody) {
        Task task = Task(
          id: element['id_task'],
          title: element['task_name'],
          description: element['description'],
          done: element['ifDone'],
          endDate: DateTime.parse(element['endDate']),
          startDate: DateTime.parse(element['startDate']),
          tags: ['tag1'],
        );
        loadedTasks.add(task);
      }

      this.taskList = loadedTasks;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteTask(int id) async {
    String url = this._serverUrl + 'task/delete/$id';

    var tmpProduct = this.taskList.firstWhere((element) => element.id == id);

    try {
      http.delete(url);
      this.taskList.removeWhere((element) => element.id == id);

      tmpProduct = null;

      notifyListeners();
    } catch (error) {
      print(error);
      this.taskList.add(tmpProduct);
      throw error;
    }
  }

  Future<void> toggleTaskStatus(int id) async {
    String url = this._serverUrl + 'task/done/$id';

    var tmpProduct = this.taskList.firstWhere((element) => element.id == id);

    try {
      http.put(url);

      this.taskList[this.taskList.indexWhere((element) => element.id == id)].done = !this.taskList[this.taskList.indexWhere((element) => element.id == id)].done;

      notifyListeners();
    } catch (error) {
      print(error);

      this.taskList[id] = tmpProduct;
      throw error;
    }
  }
}
