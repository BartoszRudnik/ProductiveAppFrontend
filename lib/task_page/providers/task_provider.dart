import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../../shared/notifications.dart';
import '../models/tag.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _trashTasks = [];
  List<Task> _completedTasks = [];
  List<Task> _inboxTasks = [];
  List<Task> _anytimeTasks = [];
  List<Task> _scheduledTasks = [];
  List<Task> _delegatedTasks = [];
  List<Task> taskList = [];
  Task singleTask;

  List<String> taskPriorities = [];

  final _localizations = ['INBOX', 'SCHEDULED', 'ANYTIME', 'COMPLETED', 'TRASH', 'DELEGATED'];

  Map<String, int> prioritiesValue = {
    'LOW': 1,
    'NORMAL': 2,
    'HIGH': 3,
    'HIGHER': 4,
    'CRITICAL': 5,
  };

  final String userMail;
  final String authToken;

  String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  TaskProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.taskList,
    @required this.taskPriorities,
    @required this.singleTask,
  }) {
    this.divideTasks();
  }

  void setInboxTasks(List<Task> newList) {
    this._inboxTasks = newList;
  }

  void setAnytimeTasks(List<Task> newList) {
    this._anytimeTasks = newList;
  }

  void setScheduledTasks(List<Task> newList) {
    this._scheduledTasks = newList;
  }

  void setDelegatedTasks(List<Task> newList) {
    this._delegatedTasks = newList;
  }

  String getTitle(int taskId) {
    return this.taskList.firstWhere((element) => element.id == taskId).title;
  }

  String getDescription(int taskId) {
    return this.taskList.firstWhere((element) => element.id == taskId).description;
  }

  Task get getSingleTask {
    return this.singleTask;
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

  List<Task> get completedTasks {
    return [...this._completedTasks];
  }

  List<Task> get trashTasks {
    return [...this._trashTasks];
  }

  List<Task> get delegatedTasks {
    return [...this._delegatedTasks];
  }

  List<String> get priorities {
    return [...this.taskPriorities];
  }

  List<String> get localizations {
    return [...this._localizations];
  }

  Future<void> addTaskWithGeolocation(Task task, double latitude, double longitude) async {
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
            'delegatedEmail': task.delegatedEmail,
            'isCanceled': task.isCanceled,
            'localizationId': task.notificationLocalizationId,
            'localizationRadius': task.notificationLocalizationRadius,
            'notificationOnEnter': task.notificationOnEnter,
            'notificationOnExit': task.notificationOnExit,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      task.id = int.parse(response.body);
      task.position = int.parse(response.body) + 1000.0;

      if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.endDate = null;
      }

      if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.startDate = null;
      }

      if (task.notificationLocalizationId != null) {
        Notifications.addGeofence(
          task.id,
          latitude,
          longitude,
          task.notificationLocalizationRadius,
          task.notificationOnEnter,
          task.notificationOnExit,
          task.title,
          task.description,
        );
      }

      this.addToLocalication(task);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
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
            'delegatedEmail': task.delegatedEmail,
            'isCanceled': task.isCanceled,
            'localizationId': task.notificationLocalizationId,
            'localizationRadius': task.notificationLocalizationRadius,
            'notificationOnEnter': task.notificationOnEnter,
            'notificationOnExit': task.notificationOnExit,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      task.id = int.parse(response.body);
      task.position = int.parse(response.body) + 1000.0;

      if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.endDate = null;
      }

      if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.startDate = null;
      }

      this.addToLocalication(task);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateTaskPosition(Task task, double newPosition) async {
    print(newPosition);
    String url = this._serverUrl + 'task/updatePosition/${task.id}';

    try {
      await http.put(
        url,
        body: json.encode(
          {
            'position': newPosition,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      task.position = newPosition;

      if (task.localization == 'INBOX') {
        this.sortByPosition(this._inboxTasks);
      } else if (task.localization == 'ANYTIME') {
        this.sortByPosition(this._anytimeTasks);
      } else if (task.localization == 'SCHEDULED') {
        this.sortByPosition(this._scheduledTasks);
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateTask(Task task, String newLocation) async {
    String url = this._serverUrl + 'task/update/${task.id}';

    if (task.localization != newLocation) {
      if (newLocation == 'ANYTIME' && this._anytimeTasks.length > 0) {
        task.position = this._anytimeTasks[this._anytimeTasks.length - 1].position + 1000.0;
      } else if (newLocation == 'SCHEDULED' && this._scheduledTasks.length > 0) {
        task.position = this._scheduledTasks[this._scheduledTasks.length - 1].position + 1000.0;
      }
    }

    if (newLocation == 'TRASH' || newLocation == 'COMPLETED') {
      Notifications.removeGeofence(task.id);
    }

    if (task.startDate == null) {
      task.startDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

    if (task.endDate == null) {
      task.endDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

    try {
      final response = await http.put(
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
            'position': task.position,
            'delegatedEmail': task.delegatedEmail,
            'isCanceled': task.isCanceled,
            'localizationId': task.notificationLocalizationId,
            'localizationRadius': task.notificationLocalizationRadius,
            'notificationOnEnter': task.notificationOnEnter,
            'notificationOnExit': task.notificationOnExit,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.endDate = null;
      }

      if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.startDate = null;
      }

      this.deleteFromLocalization(task);

      task.localization = newLocation;

      this.addToLocalication(task);

      if (task.localization == 'INBOX') {
        this.sortByPosition(this._inboxTasks);
      } else if (task.localization == 'ANYTIME') {
        this.sortByPosition(this._anytimeTasks);
      } else if (task.localization == 'SCHEDULED') {
        this.sortByPosition(this._scheduledTasks);
      } else if (task.localization == 'DELEGATED') {
        this.sortByPosition(this._delegatedTasks);
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateTaskWithGeolocation(Task task, String newLocation, double longitude, double latitude) async {
    String url = this._serverUrl + 'task/update/${task.id}';

    if (task.localization != newLocation) {
      if (newLocation == 'ANYTIME' && this._anytimeTasks.length > 0) {
        task.position = this._anytimeTasks[this._anytimeTasks.length - 1].position + 1000.0;
      } else if (newLocation == 'SCHEDULED' && this._scheduledTasks.length > 0) {
        task.position = this._scheduledTasks[this._scheduledTasks.length - 1].position + 1000.0;
      }
    }

    if (newLocation == 'TRASH' || newLocation == 'COMPLETED') {
      Notifications.removeGeofence(task.id);
    }

    if (task.startDate == null) {
      task.startDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

    if (task.endDate == null) {
      task.endDate = DateTime.fromMicrosecondsSinceEpoch(0);
    }

    try {
      final response = await http.put(
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
            'position': task.position,
            'delegatedEmail': task.delegatedEmail,
            'isCanceled': task.isCanceled,
            'localizationId': task.notificationLocalizationId,
            'localizationRadius': task.notificationLocalizationRadius,
            'notificationOnEnter': task.notificationOnEnter,
            'notificationOnExit': task.notificationOnExit,
          },
        ),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      );

      if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.endDate = null;
      }

      if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
        task.startDate = null;
      }

      this.deleteFromLocalization(task);

      task.localization = newLocation;

      this.addToLocalication(task);

      if (task.localization == 'INBOX') {
        this.sortByPosition(this._inboxTasks);
      } else if (task.localization == 'ANYTIME') {
        this.sortByPosition(this._anytimeTasks);
      } else if (task.localization == 'SCHEDULED') {
        this.sortByPosition(this._scheduledTasks);
      } else if (task.localization == 'DELEGATED') {
        this.sortByPosition(this._delegatedTasks);
      }

      if (newLocation != 'TRASH' && newLocation != 'COMPLETED') {
        this.notificationChange(
          task.id,
          task.notificationLocalizationId,
          task.notificationLocalizationRadius,
          task.notificationOnExit,
          task.notificationOnEnter,
          latitude,
          longitude,
          task.title,
          task.description,
        );
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchSingleTask(int taskId) async {
    notifyListeners();
    String url = this._serverUrl + 'task/getSingleTask/${this.userMail}/$taskId';
    String supervisorEmail;
    Task mockTask = Task(
      id: -1,
      title: 'Mock task',
      description: 'Mock task desc',
      done: false,
      priority: 'HIGH',
      endDate: DateTime.parse('2021-01-01'),
      startDate: DateTime.parse('2021-01-01'),
      supervisorEmail: 'mock@mock.com',
    );
    try {
      final response = await http.get(url);
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      supervisorEmail = responseBody['ownerEmail'];

      Task task = Task(
        id: responseBody['taskId'],
        title: responseBody['taskName'],
        description: responseBody['description'],
        priority: responseBody['priority'],
        endDate: DateTime.parse(responseBody['endDate']),
        startDate: DateTime.parse(responseBody['startDate']),
        supervisorEmail: supervisorEmail,
      );
      singleTask = task;
      notifyListeners();
    } catch (error) {
      singleTask = mockTask;
      notifyListeners();
      print(error);
      throw error;
    }
  }

  Future<void> addGeofenceFromOtherDevice(Task task) async {
    String url = this._serverUrl + 'localization/getCoordinates/${task.notificationLocalizationId}';

    double latitude;
    double longitude;

    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body);

      latitude = responseBody['latitude'];
      longitude = responseBody['longitude'];

      Notifications.addGeofence(
        task.id,
        latitude,
        longitude,
        task.notificationLocalizationRadius,
        task.notificationOnEnter,
        task.notificationOnExit,
        task.title,
        task.description,
      );
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
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      for (var element in responseBody) {
        List<Tag> taskTags = [];
        String taskStatus;
        String supervisorEmail;

        for (var tagElement in element['tags']) {
          taskTags.add(Tag(
            id: tagElement['id'],
            name: tagElement['name'],
          ));
        }

        supervisorEmail = element['supervisorEmail'];

        if (element['tasks']['taskStatus'] != null) {
          taskStatus = element['tasks']['taskStatus'];
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
            position: element['tasks']['position'],
            delegatedEmail: element['tasks']['delegatedEmail'],
            isDelegated: element['tasks']['isDelegated'],
            taskStatus: taskStatus,
            isCanceled: element['tasks']['isCanceled'],
            supervisorEmail: supervisorEmail,
            childId: element['childId'],
            parentId: element['parentId']);

        if (element['tasks']['notificationLocalization'] != null) {
          task.notificationLocalizationId = element['tasks']['notificationLocalization']['localizationId'];
          task.notificationLocalizationRadius = element['tasks']['localizationRadius'];
          task.notificationOnEnter = element['tasks']['notificationOnEnter'];
          task.notificationOnExit = element['tasks']['notificationOnExit'];
        } else {
          task.notificationLocalizationId = null;
        }

        final notificationExists = await Notifications.checkIfGeofenceExists(task.id);

        if (task.localization != 'COMPLETED' && task.localization != 'TRASH' && !task.done && task.notificationLocalizationId != null && !notificationExists) {
          this.addGeofenceFromOtherDevice(task);
        }

        if (task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.endDate = null;
        }

        if (task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.startDate = null;
        }

        loadedTasks.add(task);
      }

      this.taskList = loadedTasks;
      this.divideTasks();

      this.sortByPosition(this._anytimeTasks);
      this.sortByPosition(this._scheduledTasks);
      this.sortByPosition(this._inboxTasks);
      this.sortByPosition(this._delegatedTasks);

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
      await http.delete(url);

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
      final response = await http.post(url);

      if (response != null && task.localization == 'DELEGATED') {
        final newStatus = response.body;
        this.updateTaskStatus(task.id, newStatus);
      }

      this.localizationTaskStatus(task);

      notifyListeners();
    } catch (error) {
      print(error);

      this.taskList[task.id - 1] = task;
      throw error;
    }
  }

  Future<void> toggleTaskStatusWithGeolocation(Task task, double latitude, double longitude) async {
    String url = this._serverUrl + 'task/done/${task.id}';

    try {
      final response = await http.post(url);

      if (response != null && task.localization == 'DELEGATED') {
        final newStatus = response.body;
        this.updateTaskStatus(task.id, newStatus);
      }

      this.localizationTaskStatus(task);

      if (task.done) {
        Notifications.removeGeofence(task.id);
      } else {
        Notifications.addGeofence(
          task.id,
          latitude,
          longitude,
          task.notificationLocalizationRadius,
          task.notificationOnEnter,
          task.notificationOnExit,
          task.title,
          task.description,
        );
      }

      notifyListeners();
    } catch (error) {
      print(error);

      this.taskList[task.id - 1] = task;
      throw error;
    }
  }

  Future<void> getPriorities() async {
    this.taskPriorities = [];
    String url = this._serverUrl + 'task/priorities';

    try {
      final response = await http.get(url);

      final responseBody = json.decode(response.body);

      for (var element in responseBody) {
        this.taskPriorities.add(element.toString());
      }

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updateTaskStatus(int id, String newStatus) {
    this._delegatedTasks.firstWhere((element) => element.id == id).taskStatus = newStatus;
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
    } else if (task.localization == 'DELEGATED') {
      Task tmp = this._delegatedTasks.firstWhere((element) => element.id == task.id);
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
    } else if (task.localization == 'COMPLETED') {
      this._completedTasks.add(task);
    } else if (task.localization == 'TRASH') {
      this._trashTasks.add(task);
    } else if (task.localization == 'DELEGATED') {
      this._delegatedTasks.add(task);
    }
  }

  void deleteFromLocalization(Task task) {
    if (task.localization == 'INBOX') {
      this._inboxTasks.remove(task);
    } else if (task.localization == 'ANYTIME') {
      this._anytimeTasks.remove(task);
    } else if (task.localization == 'SCHEDULED') {
      this._scheduledTasks.remove(task);
    } else if (task.localization == 'COMPLETED') {
      this._completedTasks.remove(task);
    } else if (task.localization == 'TRASH') {
      this._trashTasks.remove(task);
    } else if (task.localization == 'DELEGATED') {
      this._delegatedTasks.remove(task);
    }
  }

  void divideTasks() {
    this._inboxTasks = [];
    this._anytimeTasks = [];
    this._scheduledTasks = [];
    this._completedTasks = [];
    this._trashTasks = [];
    this._delegatedTasks = [];

    this.taskList.forEach((task) {
      if (task.localization == 'INBOX') {
        this._inboxTasks.add(task);
      } else if (task.localization == 'ANYTIME') {
        this._anytimeTasks.add(task);
      } else if (task.localization == 'SCHEDULED') {
        this._scheduledTasks.add(task);
      } else if (task.localization == 'COMPLETED') {
        this._completedTasks.add(task);
      } else if (task.localization == 'TRASH') {
        this._trashTasks.add(task);
      } else if (task.localization == 'DELEGATED') {
        this._delegatedTasks.add(task);
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
    this._completedTasks.forEach((task) {
      task.tags.removeWhere((tag) => tag.name == tagName);
    });
    this._trashTasks.forEach((task) {
      task.tags.removeWhere((tag) => tag.name == tagName);
    });
    this._delegatedTasks.forEach((task) {
      task.tags.removeWhere((tag) => tag.name == tagName);
    });

    notifyListeners();
  }

  void editTag(String oldName, String newName) {
    this._inboxTasks.forEach((task) {
      task.tags.forEach((tag) {
        if (tag.name == oldName) {
          tag.name = newName;
        }
      });
    });

    this._anytimeTasks.forEach((task) {
      task.tags.forEach((tag) {
        if (tag.name == oldName) {
          tag.name = newName;
        }
      });
    });

    this._scheduledTasks.forEach((task) {
      task.tags.forEach((tag) {
        if (tag.name == oldName) {
          tag.name = newName;
        }
      });
    });

    notifyListeners();
  }

  void sortByPosition(List<Task> listToSort) {
    listToSort.sort((a, b) {
      return a.position.compareTo(b.position);
    });
  }

  List<Task> tasksBeforeToday() {
    return this
        ._scheduledTasks
        .where((element) => (element.startDate != null &&
            (element.startDate.difference(DateTime.now()).inDays < 0 || (element.startDate.difference(DateTime.now()).inDays == 0 && (element.startDate.day < DateTime.now().day || element.startDate.month < DateTime.now().month)))))
        .toList();
  }

  List<Task> tasksToday() {
    return this._scheduledTasks.where((element) => (element.startDate != null && element.startDate.difference(DateTime.now()).inDays == 0 && element.startDate.day == DateTime.now().day)).toList();
  }

  List<Task> taskAfterToday() {
    return this
        ._scheduledTasks
        .where((element) => (element.startDate != null &&
            (element.startDate.difference(DateTime.now()).inDays > 0 || (element.startDate.difference(DateTime.now()).inDays == 0 && (element.startDate.day > DateTime.now().day || element.startDate.month > DateTime.now().month)))))
        .toList();
  }

  List<Task> onlyWithLocalization(List<Task> listToFilter) {
    return [...listToFilter.where((element) => element.notificationLocalizationId != null)];
  }

  List<Task> onlyUnfinishedTasks(List<Task> listToFilter) {
    return [...listToFilter.where((element) => !element.done)];
  }

  List<Task> onlyDelegatedTasks(List<Task> listToFilter) {
    return [...listToFilter.where((element) => (element.isDelegated != null && element.isDelegated))];
  }

  List<Task> filterCollaboratorEmail(List<Task> listToFilter, List<String> filterEmails) {
    return [...listToFilter.where((element) => ((element.delegatedEmail != null && filterEmails.contains(element.delegatedEmail)) || (element.supervisorEmail != null && filterEmails.contains(element.supervisorEmail))))];
  }

  List<Task> filterPriority(List<Task> listToFilter, List<String> filterPriorities) {
    return [...listToFilter.where((element) => ((element.priority != null && filterPriorities.contains(element.priority))))];
  }

  List<Task> filterLocations(List<Task> listToFilter, List<int> filterLocations) {
    return [...listToFilter.where((element) => (element.notificationLocalizationId != null && filterLocations.contains(element.notificationLocalizationId)))];
  }

  List<Task> filterTags(List<Task> listToFilter, List<String> filterTags) {
    List<Task> result = [];

    listToFilter.forEach((task) {
      if (task.tags != null) {
        bool valid = true;

        for (int i = 0; i < filterTags.length; i++) {
          int index = task.tags.indexWhere((element) => element.name == filterTags[i]);

          if (index == -1) {
            valid = false;
            break;
          }
        }

        if (valid) {
          result.add(task);
        }
      }
    });

    return result;
  }

  void sortByPriorityAscending(List<Task> listToSort) {
    listToSort.sort((a, b) => prioritiesValue[a.priority].compareTo(prioritiesValue[b.priority]));
  }

  void sortByPriorityDescending(List<Task> listToSort) {
    listToSort.sort((a, b) => prioritiesValue[b.priority].compareTo(prioritiesValue[a.priority]));
  }

  void sortByEndDateAscending(List<Task> listToSort) {
    listToSort.sort((a, b) => a.endDate != null && b.endDate != null
        ? a.endDate.compareTo(b.endDate)
        : a.endDate == null
            ? 1
            : -1);
  }

  void sortByEndDateDescending(List<Task> listToSort) {
    listToSort.sort((a, b) => a.endDate != null && b.endDate != null
        ? b.endDate.compareTo(a.endDate)
        : a.endDate == null
            ? -1
            : 1);
  }

  void sortByStartDateAscending(List<Task> listToSort) {
    listToSort.sort((a, b) => a.startDate != null && b.startDate != null
        ? a.startDate.compareTo(b.startDate)
        : a.startDate == null
            ? 1
            : -1);
  }

  void sortByStartDateDescending(List<Task> listToSort) {
    listToSort.sort((a, b) => a.startDate != null && b.startDate != null
        ? b.startDate.compareTo(a.startDate)
        : a.startDate == null
            ? -1
            : 1);
  }

  void notificationChange(
    int taskId,
    int notificationId,
    double notificationRadius,
    bool onExit,
    bool onEnter,
    double latitude,
    double longitude,
    String title,
    String description,
  ) {
    Notifications.removeGeofence(taskId);
    if (taskId != null && latitude != null && longitude != null && notificationRadius != null) {
      Notifications.addGeofence(taskId, latitude, longitude, notificationRadius, onEnter, onExit, title, description);
    }
  }

  int countInboxDelegated() {
    List<Task> tmpList = [];

    tmpList = [...this._inboxTasks.where((task) => (task.isDelegated != null && task.isDelegated == true))];

    if (tmpList != null) {
      return tmpList.length;
    } else {
      return 0;
    }
  }
}
