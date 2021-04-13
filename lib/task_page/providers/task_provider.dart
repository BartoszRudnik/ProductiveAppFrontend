import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/task_page/models/tag.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> archivedTasks = [];
  List<Task> _inboxTasks = [];
  List<Task> _anytimeTasks = [];
  List<Task> _scheduledTasks = [];
  List<Task> taskList = [];
  List<String> _priorities = [];

  final _localizations = ['INBOX', 'SCHEDULED', 'ANYTIME'];

  final String userMail;
  final String authToken;

  String _serverUrl = 'http://192.168.1.120:8080/api/v1/';

  TaskProvider({@required this.userMail, @required this.authToken, @required this.taskList}) {
    this.divideTasks();
  }

  List<Task> get tasks {
    return [...this.taskList];
  }

  List<Task> get inboxTasks {
    return [...this._inboxTasks];
  }

  List<Task> get anytimeTasks {
    return [...this._anytimeTasks];
  }

  List<Task> get scheduledTasks {
    return [...this._scheduledTasks];
  }

  List<String> get priorities {
    return [...this._priorities];
  }

  List<String> get localizations {
    return [...this._localizations];
  }

  Future<void> addTask(Task task) async {
    String url = this._serverUrl + 'task/add';

    if (task.startDate == null) {
      task.startDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

    if (task.endDate == null) {
      task.endDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

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
            'priority': task.priority,
            'tags': task.tags.map((tag) => tag.toJson()).toList(),
            'localization': task.localization,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      task.id = int.parse(response.body);

      if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1 || task.endDate.difference(task.startDate).inDays <= 0) {
        task.startDate = null;
      }

      if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.endDate = null;
      }

      this.addToLocalication(task);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateTask(Task task, String newLocation) async {
    String url = this._serverUrl + 'task/update/${task.id}';

    if (task.startDate == null) {
      task.startDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

    if (task.endDate == null) {
      task.endDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

    try {
      await http.put(
        url,
        body: json.encode(
          {
            'taskName': task.title,
            'taskDescription': task.description,
            'userEmail': this.userMail,
            'startDate': task.startDate.toIso8601String(),
            'endDate': task.endDate.toIso8601String(),
            'ifDone': task.done,
            'priority': task.priority,
            'tags': task.tags.map((tag) => tag.toJson()).toList(),
            'localization': newLocation,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1 || task.endDate.difference(task.startDate).inDays <= 0) {
        task.startDate = null;
      }

      if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.endDate = null;
      }

      this.deleteFromLocalization(task);

      task.localization = newLocation;
      this.addToLocalication(task);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchTasks() async {
    String url = this._serverUrl + 'task/getAll/${this.userMail}';

    final List<Task> loadedTasks = [];

    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body);

      for (var element in responseBody) {
        List<Tag> taskTags = [];

        for (var tagElement in element['tags']) {
          taskTags.add(Tag(
            id: tagElement['id'],
            name: tagElement['name'],
          ));
        }

        Task task = Task(
          id: element['tasks']['id_task'],
          title: element['tasks']['task_name'],
          description: element['tasks']['description'],
          done: element['tasks']['ifDone'],
          priority: element['tasks']['priority'],
          endDate: DateTime.parse(element['tasks']['endDate']),
          startDate: DateTime.parse(element['tasks']['startDate']),
          tags: taskTags,
          localization: element['tasks']['localization'],
        );
        if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays <= 1 || task.endDate.difference(task.startDate).inDays <= 0) {
          task.startDate = null;
        }
        if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays <= 1) {
          task.endDate = null;
        }
        loadedTasks.add(task);
      }

      this.taskList = loadedTasks;
      this.divideTasks();
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

      this.deleteFromLocalization(tmpProduct);
      this.taskList.removeWhere((element) => element.id == id);

      tmpProduct = null;

      notifyListeners();
    } catch (error) {
      print(error);
      this.taskList.add(tmpProduct);
      throw error;
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    String url = this._serverUrl + 'task/done/${task.id}';

    try {
      http.put(url);

      this.localizationTaskStatus(task);

      notifyListeners();
    } catch (error) {
      print(error);

      this.taskList[task.id] = task;
      throw error;
    }
  }

  Future<void> getPriorities() async {
    this._priorities = [];
    String url = this._serverUrl + 'task/priorities';

    try {
      final response = await http.get(url);

      final responseBody = json.decode(response.body);

      for (var element in responseBody) {
        this._priorities.add(element.toString());
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void localizationTaskStatus(Task task) {
    if (task.localization == 'INBOX') {
      Task tmp = this._inboxTasks.firstWhere((element) => element.id == task.id);
      tmp.done = !tmp.done;
    } else if (task.localization == 'ANYTIME') {
      Task tmp = this._anytimeTasks.firstWhere((element) => element.id == task.id);
      tmp.done = !tmp.done;
    } else if (task.localization == 'SCHEDULED') {
      Task tmp = this._scheduledTasks.firstWhere((element) => element.id == task.id);
      tmp.done = !tmp.done;
    }
  }

  void addToLocalication(Task task) {
    if (task.localization == 'INBOX') {
      this._inboxTasks.add(task);
    } else if (task.localization == 'ANYTIME') {
      this._anytimeTasks.add(task);
    } else if (task.localization == 'SCHEDULED') {
      this._scheduledTasks.add(task);
    }
  }

  void deleteFromLocalization(Task task) {
    if (task.localization == 'INBOX') {
      this._inboxTasks.remove(task);
    } else if (task.localization == 'ANYTIME') {
      this._anytimeTasks.remove(task);
    } else if (task.localization == 'SCHEDULED') {
      this._scheduledTasks.remove(task);
    }
  }

  void divideTasks() {
    this._inboxTasks = [];
    this._anytimeTasks = [];
    this._scheduledTasks = [];

    this.taskList.forEach((element) {
      if (element.localization == 'INBOX') {
        this._inboxTasks.add(element);
      } else if (element.localization == 'ANYTIME') {
        this._anytimeTasks.add(element);
      } else if (element.localization == 'SCHEDULED') {
        this._scheduledTasks.add(element);
      }
    });
  }

  void clearTagFromTasks(String tagName) {
    this._inboxTasks.forEach((task) {
      task.tags.removeWhere((tag) => tag.name == tagName);
    });
    this._anytimeTasks.forEach((task) {
      task.tags.removeWhere((tag) => tag.name == tagName);
    });
    this._scheduledTasks.forEach((task) {
      task.tags.removeWhere((tag) => tag.name == tagName);
    });

    notifyListeners();
  }

  List<Task> tasksBeforeToday() {
    return this._scheduledTasks.where((element) => (element.endDate != null && element.endDate.difference(DateTime.now()).inDays < 0)).toList();
  }

  List<Task> tasksToday() {
    return this._scheduledTasks.where((element) => (element.endDate != null && element.endDate.difference(DateTime.now()).inDays == 0)).toList();
  }

  List<Task> taskAfterToday() {
    return this._scheduledTasks.where((element) => (element.endDate != null && element.endDate.difference(DateTime.now()).inDays > 0)).toList();
  }
}
