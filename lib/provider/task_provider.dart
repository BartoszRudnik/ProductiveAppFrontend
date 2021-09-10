import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/task_database.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/utils/internet_connection.dart';

import '../model/tag.dart';
import '../model/task.dart';
import '../utils/notifications.dart';

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

  List<Task> get tasksWithLocation {
    List<Task> withLocation = [];

    withLocation.addAll(this.inboxTasks.where((element) => element.notificationLocalizationId != null));
    withLocation.addAll(this.anytimeTasks.where((element) => element.notificationLocalizationId != null));
    withLocation.addAll(this.scheduledTasks.where((element) => element.notificationLocalizationId != null));

    return withLocation;
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

  void clearLocationFromTasks(int locationId) {
    this._inboxTasks.forEach((element) {
      if (element.notificationLocalizationId != null && element.notificationLocalizationId == locationId) {
        element.notificationLocalizationId = null;
      }
    });
    this._anytimeTasks.forEach((element) {
      if (element.notificationLocalizationId != null && element.notificationLocalizationId == locationId) {
        element.notificationLocalizationId = null;
      }
    });
    this._scheduledTasks.forEach((element) {
      if (element.notificationLocalizationId != null && element.notificationLocalizationId == locationId) {
        element.notificationLocalizationId = null;
      }
    });
    this._delegatedTasks.forEach((element) {
      if (element.notificationLocalizationId != null && element.notificationLocalizationId == locationId) {
        element.notificationLocalizationId = null;
      }
    });
    notifyListeners();
  }

  Future<int> addTaskWithGeolocation(Task task, double latitude, double longitude) async {
    String url = this._serverUrl + 'task/add';

    task = await TaskDatabase.create(task, this.userMail);

    task.position = task.id + 1000.0;
    await TaskDatabase.update(task, this.userMail);

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

    this.taskList.add(task);
    this.addToLocalization(task);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        final response = await http.post(
          url,
          body: json.encode(
            {
              'uuid': task.uuid,
              'taskName': task.title,
              'taskDescription': task.description,
              'userEmail': this.userMail,
              'startDate': task.startDate != null ? task.startDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
              'endDate': task.endDate != null ? task.endDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
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

        notifyListeners();

        return task.id;
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      return task.id;
    }
  }

  Future<int> addTask(Task task) async {
    String url = this._serverUrl + 'task/add';

    task = await TaskDatabase.create(task, this.userMail);

    task.position = task.id + 1000.0;
    await TaskDatabase.update(task, this.userMail);

    this.taskList.add(task);
    this.addToLocalization(task);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        final response = await http.post(
          url,
          body: json.encode(
            {
              'uuid': task.uuid,
              'taskName': task.title,
              'taskDescription': task.description,
              'userEmail': this.userMail,
              'startDate': task.startDate != null ? task.startDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
              'endDate': task.endDate != null ? task.endDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
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

        notifyListeners();

        return task.id;
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      return task.id;
    }
  }

  Future<void> updateTaskPosition(Task task, double newPosition) async {
    String url = this._serverUrl + 'task/updatePosition/${task.id}';

    task.position = newPosition;

    if (task.localization == 'INBOX') {
      this.sortByPosition(this._inboxTasks);
    } else if (task.localization == 'ANYTIME') {
      this.sortByPosition(this._anytimeTasks);
    } else if (task.localization == 'SCHEDULED') {
      this.sortByPosition(this._scheduledTasks);
    }

    await TaskDatabase.update(task, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
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
      } catch (error) {
        print(error);
        throw (error);
      }
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

    this.deleteFromLocalization(task);

    task.localization = newLocation;

    this.addToLocalization(task);

    if (task.localization == 'INBOX') {
      this.sortByPosition(this._inboxTasks);
    } else if (task.localization == 'ANYTIME') {
      this.sortByPosition(this._anytimeTasks);
    } else if (task.localization == 'SCHEDULED') {
      this.sortByPosition(this._scheduledTasks);
    } else if (task.localization == 'DELEGATED') {
      this.sortByPosition(this._delegatedTasks);
    }

    await TaskDatabase.update(task, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.put(
          url,
          body: json.encode(
            {
              'uuid': task.uuid,
              'taskName': task.title,
              'taskDescription': task.description,
              'userEmail': this.userMail,
              'startDate': task.startDate != null ? task.startDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
              'endDate': task.endDate != null ? task.endDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
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
      } catch (error) {
        print(error);
        throw (error);
      }
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

    this.deleteFromLocalization(task);

    task.localization = newLocation;

    this.addToLocalization(task);

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

    await TaskDatabase.update(task, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.put(
          url,
          body: json.encode(
            {
              'uuid': task.uuid,
              'taskName': task.title,
              'taskDescription': task.description,
              'userEmail': this.userMail,
              'startDate': task.startDate != null ? task.startDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
              'endDate': task.endDate != null ? task.endDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
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
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> fetchSingleTaskFull(int taskId) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/getSingleTaskFull/${this.userMail}/$taskId';

      try {
        final response = await http.get(url);
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        List<Tag> taskTags = [];
        String taskStatus;
        String supervisorEmail;

        for (var tagElement in responseBody['tags']) {
          taskTags.add(Tag(
            uuid: tagElement['uuid'],
            id: tagElement['id'],
            name: tagElement['name'],
          ));
        }

        if (responseBody['supervisorEmail'] != null) {
          supervisorEmail = responseBody['supervisorEmail'];
        }

        if (responseBody['tasks']['taskStatus'] != null) {
          taskStatus = responseBody['tasks']['taskStatus'];
        }

        Task task = Task(
            uuid: responseBody['tasks']['uuid'],
            id: responseBody['tasks']['id'],
            title: responseBody['tasks']['taskName'],
            description: responseBody['tasks']['description'],
            done: responseBody['tasks']['ifDone'],
            priority: responseBody['tasks']['priority'],
            endDate: responseBody['tasks']['endDate'] == null ? null : DateTime.tryParse(responseBody['tasks']['endDate']),
            startDate: responseBody['tasks']['startDate'] == null ? null : DateTime.tryParse(responseBody['tasks']['startDate']),
            tags: taskTags,
            localization: responseBody['tasks']['taskList'],
            position: responseBody['tasks']['position'],
            delegatedEmail: responseBody['tasks']['delegatedEmail'],
            isDelegated: responseBody['tasks']['isDelegated'],
            taskStatus: taskStatus,
            isCanceled: responseBody['tasks']['isCanceled'],
            supervisorEmail: supervisorEmail,
            childId: responseBody['childId'],
            parentId: responseBody['parentId']);

        if (responseBody['tasks']['notificationLocalization'] != null) {
          task.notificationLocalizationId = responseBody['tasks']['notificationLocalization']['id'];
          task.notificationLocalizationRadius = responseBody['tasks']['localizationRadius'];
          task.notificationOnEnter = responseBody['tasks']['notificationOnEnter'];
          task.notificationOnExit = responseBody['tasks']['notificationOnExit'];
        } else {
          task.notificationLocalizationId = null;
        }

        if (task.endDate != null && task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.endDate = null;
        }

        if (task.startDate != null && task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.startDate = null;
        }

        this.taskList.add(task);

        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> fetchSingleTask(int taskId) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/getSingleTask/${this.userMail}/$taskId';
      String supervisorEmail;
      Task mockTask = Task(
        uuid: '',
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
          uuid: responseBody['uuid'],
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
  }

  Future<void> addGeofenceFromOtherDevice(Task task) async {
    if (await InternetConnection.internetConnection()) {
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
  }

  Future<void> fetchTasks(BuildContext context) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/getAll/${this.userMail}';

      final List<Task> loadedTasks = [];

      try {
        final response = await http.get(url);
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        await TaskDatabase.deleteAll(this.userMail);

        for (final element in responseBody) {
          List<Tag> taskTags = [];
          String taskStatus;
          String supervisorEmail;

          if (element['tags'] != null) {
            for (var tagElement in element['tags']) {
              taskTags.add(Tag(
                uuid: tagElement['uuid'],
                id: tagElement['id'],
                name: tagElement['name'],
              ));
            }
          }

          if (element['tasks']['supervisorEmail'] != null) {
            supervisorEmail = element['supervisorEmail'];
          }

          if (element['tasks']['taskStatus'] != null) {
            taskStatus = element['tasks']['taskStatus'];
          }

          Task task = Task(
              uuid: element['tasks']['uuid'],
              id: element['tasks']['id'],
              title: element['tasks']['taskName'],
              description: element['tasks']['description'],
              done: element['tasks']['ifDone'],
              priority: element['tasks']['priority'],
              endDate: element['tasks']['endDate'] != null ? DateTime.tryParse(element['tasks']['endDate']) : null,
              startDate: element['tasks']['endDate'] != null ? DateTime.tryParse(element['tasks']['startDate']) : null,
              tags: taskTags,
              localization: element['tasks']['taskList'],
              position: element['tasks']['position'],
              delegatedEmail: element['tasks']['delegatedEmail'],
              isDelegated: element['tasks']['isDelegated'],
              taskStatus: taskStatus,
              isCanceled: element['tasks']['isCanceled'],
              supervisorEmail: supervisorEmail,
              childId: element['childId'],
              parentId: element['parentId']);

          if (element['tasks']['notificationLocalization'] != null) {
            task.notificationLocalizationId = element['tasks']['notificationLocalization']['id'];
            task.notificationLocalizationRadius = element['tasks']['localizationRadius'];
            task.notificationOnEnter = element['tasks']['notificationOnEnter'];
            task.notificationOnExit = element['tasks']['notificationOnExit'];
          } else {
            task.notificationLocalizationId = null;
          }

          final notificationExists = await Notifications.checkIfGeofenceExists(task.id);

          if (task.localization != 'COMPLETED' &&
              task.localization != 'TRASH' &&
              !task.done &&
              task.notificationLocalizationId != null &&
              !notificationExists) {
            this.addGeofenceFromOtherDevice(task);
          }

          if (task.endDate != null && task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
            task.endDate = null;
          }

          if (task.startDate != null && task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
            task.startDate = null;
          }

          loadedTasks.add(task);
          await TaskDatabase.create(task, this.userMail);
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
    } else {
      try {
        this.taskList = await TaskDatabase.readAll(context, this.userMail);
        this.divideTasks();

        this.sortByPosition(this._anytimeTasks);
        this.sortByPosition(this._scheduledTasks);
        this.sortByPosition(this._inboxTasks);
        this.sortByPosition(this._delegatedTasks);

        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> deleteAllTasks(String listName) async {
    if (listName == 'Completed') {
      this._completedTasks = [];
    } else if (listName == 'Trash') {
      this._trashTasks = [];
    }

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      final url = this._serverUrl + 'task/deleteAllFromList';

      List<int> toDelete = [];

      if (listName == 'Completed') {
        this._completedTasks.forEach((element) {
          toDelete.add(element.id);
        });
      } else if (listName == 'Trash') {
        this._trashTasks.forEach((element) {
          toDelete.add(element.id);
        });
      }

      try {
        await http.post(
          url,
          body: json.encode(
            {
              'tasks': toDelete,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      await TaskDatabase.deleteAllFromList(listName.toUpperCase());
    }
  }

  Future<void> deleteTask(int id) async {
    final url = this._serverUrl + 'task/delete/$id';

    Task tmpProduct = this.taskList.firstWhere((element) => element.id == id);

    await TaskDatabase.delete(id);

    this.deleteFromLocalization(tmpProduct);
    this.taskList.removeWhere((element) => element.id == id);

    tmpProduct = null;

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        await http.delete(url);
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  //Todo
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

    await TaskDatabase.update(task, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        final response = await http.post(url);

        if (response != null && task.localization == 'DELEGATED') {
          final newStatus = response.body;
          this.updateTaskStatus(task.id, newStatus);

          notifyListeners();
        }
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  Future<void> getPriorities() async {
    this.taskPriorities = ['LOW', 'NORMAL', 'HIGH', 'HIGHER', 'CRITICAL'];

    notifyListeners();
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

  void addToLocalization(Task task) {
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
      task.tags.removeWhere((tag) {
        if (tag.name == tagName) {
          TaskDatabase.update(task, this.userMail);

          return true;
        }
        return false;
      });
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
      task.tags.forEach((tag) async {
        if (tag.name == oldName) {
          tag.name = newName;
          await TaskDatabase.update(task, this.userMail);
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

  Future<void> deleteReceivedFromCollaborator(String collaboratorEmail, List<Location> locations) async {
    final receivedTasks = this.taskList.where((task) => task.supervisorEmail == collaboratorEmail);

    receivedTasks.forEach((task) {
      String newLocation = "TRASH";

      if (task.notificationLocalizationId == null) {
        this.updateTask(task, newLocation);
      } else {
        final longitude = locations.firstWhere((location) => location.id == task.notificationLocalizationId).longitude;
        final latitude = locations.firstWhere((location) => location.id == task.notificationLocalizationId).latitude;

        this.updateTaskWithGeolocation(task, newLocation, longitude, latitude);
      }
    });
  }

  Future<void> deleteCollaboratorFromTasks(String collaboratorEmail, List<Location> locations) async {
    final delegatedTasks = this.delegatedTasks.where((element) => element.delegatedEmail == collaboratorEmail);

    delegatedTasks.forEach(
      (element) {
        element.delegatedEmail = null;
        element.supervisorEmail = null;
        element.childId = null;
        element.parentId = null;

        String newLocation;

        if (element.startDate != null) {
          newLocation = 'SCHEDULED';
        } else {
          newLocation = 'ANYTIME';
        }

        if (element.notificationLocalizationId == null) {
          this.updateTask(element, newLocation);
        } else {
          final longitude = locations.firstWhere((location) => location.id == element.notificationLocalizationId).longitude;
          final latitude = locations.firstWhere((location) => location.id == element.notificationLocalizationId).latitude;

          this.updateTaskWithGeolocation(element, newLocation, longitude, latitude);
        }
      },
    );
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
            (element.startDate.difference(DateTime.now()).inDays < 0 ||
                (element.startDate.difference(DateTime.now()).inDays == 0 &&
                    ((element.startDate.month < DateTime.now().month) ||
                        (element.startDate.day < DateTime.now().day && element.startDate.month <= DateTime.now().month))))))
        .toList();
  }

  List<Task> tasksToday() {
    return this
        ._scheduledTasks
        .where((element) =>
            (element.startDate != null && element.startDate.difference(DateTime.now()).inDays == 0 && element.startDate.day == DateTime.now().day))
        .toList();
  }

  List<Task> taskAfterToday() {
    return this
        ._scheduledTasks
        .where((element) => (element.startDate != null &&
            (element.startDate.difference(DateTime.now()).inDays > 0 ||
                (element.startDate.difference(DateTime.now()).inDays == 0 &&
                    ((element.startDate.month > DateTime.now().month) ||
                        (element.startDate.day > DateTime.now().day && element.startDate.month >= DateTime.now().month))))))
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
    return [
      ...listToFilter.where((element) => ((element.delegatedEmail != null && filterEmails.contains(element.delegatedEmail)) ||
          (element.supervisorEmail != null && filterEmails.contains(element.supervisorEmail))))
    ];
  }

  List<Task> filterPriority(List<Task> listToFilter, List<String> filterPriorities) {
    return [...listToFilter.where((element) => ((element.priority != null && filterPriorities.contains(element.priority))))];
  }

  List<Task> filterLocations(List<Task> listToFilter, List<int> filterLocations) {
    return [
      ...listToFilter.where((element) => (element.notificationLocalizationId != null && filterLocations.contains(element.notificationLocalizationId)))
    ];
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
