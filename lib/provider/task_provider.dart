import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:productive_app/db/task_database.dart';
import 'package:productive_app/model/location.dart';
import 'package:productive_app/provider/location_provider.dart';
import 'package:productive_app/utils/internet_connection.dart';
import 'package:provider/provider.dart';

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

  final _localizations = ['COLLECT', 'PLAN&DO', 'COMPLETED'];

  Map<String, int> prioritiesValue = {
    'LOW': 1,
    'NORMAL': 2,
    'HIGH': 3,
    'HIGHER': 4,
    'CRITICAL': 5,
  };

  final String userMail;
  final String authToken;
  final String _serverUrl = GlobalConfiguration().getValue("serverUrl");

  String trashName = '';
  String completedName = '';

  TaskProvider({
    @required this.userMail,
    @required this.authToken,
    @required this.taskList,
    @required this.taskPriorities,
    @required this.singleTask,
  }) {
    this.divideTasks();
  }

  void setTrashName(String value) {
    this.trashName = value;
    notifyListeners();
  }

  void setCompletedName(String value) {
    this.completedName = value;
    notifyListeners();
  }

  void clearTrashName() {
    this.trashName = '';
    notifyListeners();
  }

  void clearCompletedName() {
    this.completedName = '';
    notifyListeners();
  }

  List<Task> get filteredCompletedTasks {
    if (this.completedName.length >= 1) {
      return this.completedTasks.where((element) => element.title.contains(this.completedName)).toList();
    } else {
      return this.completedTasks.toList();
    }
  }

  List<Task> get filteredTrashTasks {
    if (this.trashName.length >= 1) {
      return this.trashTasks.where((element) => element.title.contains(this.trashName)).toList();
    } else {
      return this.trashTasks.toList();
    }
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

  List<String> get delegatedTasksUuid {
    List<String> delegated = [];

    delegated.addAll(this.inboxTasks.where((element) => element.parentUuid != null).map((e) => e.parentUuid));
    delegated.addAll(this.anytimeTasks.where((element) => element.parentUuid != null).map((e) => e.parentUuid));
    delegated.addAll(this.scheduledTasks.where((element) => element.parentUuid != null).map((e) => e.parentUuid));

    return delegated;
  }

  List<String> get tasksWithLocationId {
    List<String> withLocation = [];

    withLocation.addAll(this.inboxTasks.where((element) => element.notificationLocalizationUuid != null).map((e) => e.uuid));
    withLocation.addAll(this.anytimeTasks.where((element) => element.notificationLocalizationUuid != null).map((e) => e.uuid));
    withLocation.addAll(this.scheduledTasks.where((element) => element.notificationLocalizationUuid != null).map((e) => e.uuid));

    return withLocation;
  }

  List<Task> get tasksWithLocation {
    List<Task> withLocation = [];

    withLocation.addAll(this.inboxTasks.where((element) => element.notificationLocalizationUuid != null));
    withLocation.addAll(this.anytimeTasks.where((element) => element.notificationLocalizationUuid != null));
    withLocation.addAll(this.scheduledTasks.where((element) => element.notificationLocalizationUuid != null));

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

  List<String> receivedTasksUuid() {
    return this.tasks.where((element) => element.parentUuid != null).map((e) => e.parentUuid).toList();
  }

  void clearLocationFromTasks(String locationUuid) {
    this._inboxTasks.forEach((element) {
      if (element.notificationLocalizationUuid != null && element.notificationLocalizationUuid == locationUuid) {
        element.notificationLocalizationUuid = null;
      }
    });
    this._anytimeTasks.forEach((element) {
      if (element.notificationLocalizationUuid != null && element.notificationLocalizationUuid == locationUuid) {
        element.notificationLocalizationUuid = null;
      }
    });
    this._scheduledTasks.forEach((element) {
      if (element.notificationLocalizationUuid != null && element.notificationLocalizationUuid == locationUuid) {
        element.notificationLocalizationUuid = null;
      }
    });
    this._delegatedTasks.forEach((element) {
      if (element.notificationLocalizationUuid != null && element.notificationLocalizationUuid == locationUuid) {
        element.notificationLocalizationUuid = null;
      }
    });
    notifyListeners();
  }

  Future<void> sendSSE(String childTaskUuid, String collaboratorEmail) async {
    if (childTaskUuid != null && childTaskUuid.length > 1) {
      final notifyUrl = this._serverUrl + "delegatedTaskSSE/publish/$collaboratorEmail";

      try {
        await http.post(
          notifyUrl,
          body: json.encode(
            {
              'userMail': collaboratorEmail,
              'taskUuid': childTaskUuid,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
      } catch (error) {
        print(error);
      }
    }
  }

  Future<int> addTaskWithGeolocation(Task task, double latitude, double longitude) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/add';

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
              'localizationUuid': task.notificationLocalizationUuid,
              'localizationRadius': task.notificationLocalizationRadius,
              'notificationOnEnter': task.notificationOnEnter,
              'notificationOnExit': task.notificationOnExit,
              'taskState': task.taskState,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        final responseBody = json.decode(response.body);

        task.id = responseBody['taskId'];
        task.position = task.id + 1000.0;

        task = await TaskDatabase.create(task, this.userMail);

        if (task.notificationLocalizationUuid != null) {
          await Notifications.addGeofence(task.uuid, latitude, longitude, task.notificationLocalizationRadius, task.notificationOnEnter,
              task.notificationOnExit, task.title, task.description, task.id);
        }

        this.taskList.add(task);
        this.addToLocalization(task);

        notifyListeners();

        if (responseBody['childTaskUuid'] != null && responseBody['childTaskUuid'].length > 1) {
          await this.sendSSE(responseBody['childTaskUuid'], task.delegatedEmail);
        }

        return task.id;
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      task = await TaskDatabase.create(task, this.userMail);

      task.position = task.id + 1000.0;
      await TaskDatabase.update(task, this.userMail);

      if (task.notificationLocalizationUuid != null) {
        await Notifications.addGeofence(task.uuid, latitude, longitude, task.notificationLocalizationRadius, task.notificationOnEnter, task.notificationOnExit,
            task.title, task.description, task.id);
      }

      this.taskList.add(task);
      this.addToLocalization(task);

      notifyListeners();

      return task.id;
    }
  }

  Future<int> addTask(Task task) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/add';

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
              'localizationUuid': task.notificationLocalizationUuid,
              'localizationRadius': task.notificationLocalizationRadius,
              'notificationOnEnter': task.notificationOnEnter,
              'notificationOnExit': task.notificationOnExit,
              'taskState': task.taskState,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );
        final responseBody = json.decode(response.body);

        task.id = responseBody['taskId'];
        task.position = task.id + 1000.0;

        task = await TaskDatabase.create(task, this.userMail);

        this.taskList.add(task);
        this.addToLocalization(task);

        notifyListeners();

        if (responseBody['childTaskUuid'] != null && responseBody['childTaskUuid'].length > 1) {
          await this.sendSSE(responseBody['childTaskUuid'], task.delegatedEmail);
        }

        return task.id;
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      task = await TaskDatabase.create(task, this.userMail);

      task.position = task.id + 1000.0;
      await TaskDatabase.update(task, this.userMail);

      this.taskList.add(task);
      this.addToLocalization(task);

      notifyListeners();

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
    String url = this._serverUrl + 'task/update';

    if (task.localization != newLocation) {
      if (newLocation == 'ANYTIME' && this._anytimeTasks.length > 0) {
        task.position = this._anytimeTasks[this._anytimeTasks.length - 1].position + 1000.0;
      } else if (newLocation == 'SCHEDULED' && this._scheduledTasks.length > 0) {
        task.position = this._scheduledTasks[this._scheduledTasks.length - 1].position + 1000.0;
      }
    }

    this.deleteFromLocalization(task);
    task.localization = newLocation;
    this.addToLocalization(task);

    if (newLocation == 'TRASH' || newLocation == 'COMPLETED') {
      await Notifications.removeGeofence(task.uuid);
    }

    if (task.localization == 'INBOX') {
      this.sortByPosition(this._inboxTasks);
    } else if (task.localization == 'ANYTIME') {
      this.sortByPosition(this._anytimeTasks);
    } else if (task.localization == 'SCHEDULED') {
      this.sortByPosition(this._scheduledTasks);
    } else if (task.localization == 'DELEGATED') {
      task.taskStatus = 'Sent';
      this.sortByPosition(this._delegatedTasks);
    }

    notifyListeners();

    await TaskDatabase.update(task, this.userMail);

    if (await InternetConnection.internetConnection()) {
      try {
        final response = await http.put(
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
              'localizationUuid': task.notificationLocalizationUuid,
              'localizationRadius': task.notificationLocalizationRadius,
              'notificationOnEnter': task.notificationOnEnter,
              'notificationOnExit': task.notificationOnExit,
              'taskState': task.taskState,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        final responseBody = json.decode(response.body);

        if (responseBody['childTaskUuid'] != null && responseBody['childTaskUuid'].length > 1) {
          await this.sendSSE(responseBody['childTaskUuid'], task.delegatedEmail);
        }
        if (responseBody['parentTaskUuid'] != null && responseBody['parentTaskUuid'].length > 1) {
          await this.sendSSE(responseBody['parentTaskUuid'], responseBody['parentTaskEmail']);
        }
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> updateTaskWithGeolocation(Task task, String newLocation, double longitude, double latitude) async {
    String url = this._serverUrl + 'task/update';

    if (task.localization != newLocation) {
      if (newLocation == 'ANYTIME' && this._anytimeTasks.length > 0) {
        task.position = this._anytimeTasks[this._anytimeTasks.length - 1].position + 1000.0;
      } else if (newLocation == 'SCHEDULED' && this._scheduledTasks.length > 0) {
        task.position = this._scheduledTasks[this._scheduledTasks.length - 1].position + 1000.0;
      }
    }

    this.deleteFromLocalization(task);
    task.localization = newLocation;
    this.addToLocalization(task);

    if (newLocation == 'TRASH' || newLocation == 'COMPLETED') {
      await Notifications.removeGeofence(task.uuid);
    }

    if (task.localization == 'INBOX') {
      this.sortByPosition(this._inboxTasks);
    } else if (task.localization == 'ANYTIME') {
      this.sortByPosition(this._anytimeTasks);
    } else if (task.localization == 'SCHEDULED') {
      this.sortByPosition(this._scheduledTasks);
    } else if (task.localization == 'DELEGATED') {
      task.taskStatus = 'Sent';
      this.sortByPosition(this._delegatedTasks);
    }

    if (newLocation != 'TRASH' && newLocation != 'COMPLETED') {
      this.notificationChange(
        task.uuid,
        task.notificationLocalizationRadius,
        task.notificationOnExit,
        task.notificationOnEnter,
        latitude,
        longitude,
        task.title,
        task.description,
        task.id,
      );
    }

    await TaskDatabase.update(task, this.userMail);

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      try {
        final response = await http.put(
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
              'localizationUuid': task.notificationLocalizationUuid,
              'localizationRadius': task.notificationLocalizationRadius,
              'notificationOnEnter': task.notificationOnEnter,
              'notificationOnExit': task.notificationOnExit,
              'taskState': task.taskState,
            },
          ),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        );

        final responseBody = json.decode(response.body);

        if (responseBody['childTaskUuid'] != null && responseBody['childTaskUuid'].length > 1) {
          await this.sendSSE(responseBody['childTaskUuid'], task.delegatedEmail);
        }
        if (responseBody['parentTaskUuid'] != null && responseBody['parentTaskUuid'].length > 1) {
          await this.sendSSE(responseBody['parentTaskUuid'], responseBody['parentTaskEmail']);
        }
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<Task> fetchSingleTaskFull(String taskUuid, BuildContext context) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/getSingleTaskFull/${this.userMail}/$taskUuid';

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
          childUuid: responseBody['childUuid'],
          parentUuid: responseBody['parentUuid'],
          taskState: responseBody['tasks']['taskState'],
        );

        if (taskStatus == 'Done') {
          task.done = true;
        }

        if (responseBody['tasks']['notificationLocalization'] != null) {
          task.notificationLocalizationUuid = responseBody['tasks']['notificationLocalization']['uuid'];
          task.notificationLocalizationRadius = responseBody['tasks']['localizationRadius'];
          task.notificationOnEnter = responseBody['tasks']['notificationOnEnter'];
          task.notificationOnExit = responseBody['tasks']['notificationOnExit'];

          await Provider.of<LocationProvider>(context, listen: false).getSingleLocation(task.notificationLocalizationUuid);
        } else {
          task.notificationLocalizationUuid = null;
        }

        if (task.endDate != null && task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.endDate = null;
        }

        if (task.startDate != null && task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.startDate = null;
        }

        final bool isNew = -1 == this.taskList.indexWhere((element) => element.uuid == task.uuid);

        this.taskList.add(task);
        this.deleteFromLocalization(task);
        this.addToLocalization(task);

        notifyListeners();

        await TaskDatabase.delete(task.uuid);
        await TaskDatabase.create(task, this.userMail);

        if (isNew) {
          return task;
        } else {
          return null;
        }
      } catch (error) {
        print(error);
        throw (error);
      }
    }

    return null;
  }

  Future<void> fetchSingleTask(String taskUuid) async {
    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/getSingleTask/${this.userMail}/$taskUuid';
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
        taskState: 'COLLECT',
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
          taskState: responseBody['taskState'],
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
      String url = this._serverUrl + 'localization/getCoordinates/${task.uuid}';

      double latitude;
      double longitude;

      try {
        final response = await http.get(url);
        final responseBody = json.decode(response.body);

        latitude = responseBody['latitude'];
        longitude = responseBody['longitude'];

        await Notifications.addGeofence(
          task.uuid,
          latitude,
          longitude,
          task.notificationLocalizationRadius,
          task.notificationOnEnter,
          task.notificationOnExit,
          task.title,
          task.description,
          task.id,
        );
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  Future<void> fetchTasks() async {
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
          taskState: element['tasks']['taskState'],
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
          childUuid: element['childUuid'],
          parentUuid: element['parentUuid'],
        );

        if (taskStatus == 'Done') {
          task.done = true;
        }

        if (element['tasks']['notificationLocalization'] != null) {
          task.notificationLocalizationUuid = element['tasks']['notificationLocalization']['uuid'];
          task.notificationLocalizationRadius = element['tasks']['localizationRadius'];
          task.notificationOnEnter = element['tasks']['notificationOnEnter'];
          task.notificationOnExit = element['tasks']['notificationOnExit'];
        } else {
          task.notificationLocalizationUuid = null;
        }

        final notificationExists = await Notifications.checkIfGeofenceExists(task.id);

        if (task.localization != 'COMPLETED' &&
            task.localization != 'TRASH' &&
            !task.done &&
            task.notificationLocalizationUuid != null &&
            !notificationExists) {
          this.addGeofenceFromOtherDevice(task);
        }

        if (task.endDate != null && task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.endDate = null;
        }

        if (task.startDate != null && task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.startDate = null;
        }

        task = await TaskDatabase.create(task, this.userMail);
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

  Future<void> fetchTasksOffline(List<Tag> tags) async {
    try {
      this.taskList = await TaskDatabase.readAll(tags, this.userMail);

      this.taskList.forEach((task) {
        if (task.endDate != null && task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.endDate = null;
        }

        if (task.startDate != null && task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
          task.startDate = null;
        }
      });

      this.divideTasks();

      this.sortByPosition(this._anytimeTasks);
      this.sortByPosition(this._scheduledTasks);
      this.sortByPosition(this._inboxTasks);
      this.sortByPosition(this._delegatedTasks);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  void notify() {
    notifyListeners();
  }

  Future<void> deleteAllTasks(String listName) async {
    List<String> toDelete = [];

    if (listName == 'Completed') {
      this._completedTasks.forEach((element) {
        toDelete.add(element.uuid);
      });
    } else if (listName == 'Trash') {
      this._trashTasks.forEach((element) {
        toDelete.add(element.uuid);
      });
    }

    if (listName == 'Completed') {
      this._completedTasks = [];
    } else if (listName == 'Trash') {
      this._trashTasks = [];
    }

    await TaskDatabase.deleteAllFromList(listName.toUpperCase());

    notifyListeners();

    if (await InternetConnection.internetConnection()) {
      final url = this._serverUrl + 'task/deleteAllFromList';

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
    }
  }

  Future<void> deleteTask(String uuid, int id) async {
    final url = this._serverUrl + 'task/delete/$uuid/$id';

    Task tmpProduct = this.taskList.firstWhere((element) => element.uuid == uuid);

    await TaskDatabase.delete(uuid);

    this.deleteFromLocalization(tmpProduct);
    this.taskList.removeWhere((element) => element.uuid == uuid);

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

  Future<void> toggleTaskStatus(Task task) async {
    this.localizationTaskStatus(task);

    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/done/${task.uuid}';

      try {
        final response = await http.post(url);

        if (response != null && task.localization == 'DELEGATED') {
          final newStatus = response.body;
          this.updateTaskStatus(task.uuid, newStatus);
        }

        await TaskDatabase.update(task, this.userMail);
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      await TaskDatabase.update(task, this.userMail);
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatusWithGeolocation(Task task, double latitude, double longitude) async {
    this.localizationTaskStatus(task);

    if (task.done) {
      await Notifications.removeGeofence(task.uuid);
    } else {
      await Notifications.addGeofence(
        task.uuid,
        latitude,
        longitude,
        task.notificationLocalizationRadius,
        task.notificationOnEnter,
        task.notificationOnExit,
        task.title,
        task.description,
        task.id,
      );
    }

    if (await InternetConnection.internetConnection()) {
      String url = this._serverUrl + 'task/done/${task.uuid}';

      try {
        final response = await http.post(url);

        if (response != null && task.localization == 'DELEGATED') {
          final newStatus = response.body;
          this.updateTaskStatus(task.uuid, newStatus);
        }
        await TaskDatabase.update(task, this.userMail);

        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      await TaskDatabase.update(task, this.userMail);

      notifyListeners();
    }
  }

  Future<List<String>> getTasksFromCollaborator(String collaboratorMail) async {
    if (await InternetConnection.internetConnection()) {
      List<String> tasksUuid = [];

      final url = this._serverUrl + 'task/fromCollaborator/${this.userMail}/$collaboratorMail';

      try {
        final response = await http.get(url);

        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        print(responseBody);

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
              taskState: element['tasks']['taskState'],
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
              childUuid: element['childUuid'],
              parentUuid: element['parentUuid']);

          if (element['tasks']['notificationLocalization'] != null) {
            task.notificationLocalizationUuid = element['tasks']['notificationLocalization']['uuid'];
            task.notificationLocalizationRadius = element['tasks']['localizationRadius'];
            task.notificationOnEnter = element['tasks']['notificationOnEnter'];
            task.notificationOnExit = element['tasks']['notificationOnExit'];
          } else {
            task.notificationLocalizationUuid = null;
          }

          final notificationExists = await Notifications.checkIfGeofenceExists(task.id);

          if (task.localization != 'COMPLETED' &&
              task.localization != 'TRASH' &&
              !task.done &&
              task.notificationLocalizationUuid != null &&
              !notificationExists) {
            this.addGeofenceFromOtherDevice(task);
          }

          if (task.endDate != null && task.endDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
            task.endDate = null;
          }

          if (task.startDate != null && task.startDate.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays < 1) {
            task.startDate = null;
          }

          task = await TaskDatabase.create(task, this.userMail);
          this.taskList.add(task);

          tasksUuid.add(task.parentUuid);
        }

        this.divideTasks();

        this.sortByPosition(this._anytimeTasks);
        this.sortByPosition(this._scheduledTasks);
        this.sortByPosition(this._inboxTasks);
        this.sortByPosition(this._delegatedTasks);

        notifyListeners();

        return tasksUuid;
      } catch (error) {
        print(error);
        throw (error);
      }
    } else {
      return [];
    }
  }

  Future<void> getPriorities() async {
    this.taskPriorities = ['LOW', 'NORMAL', 'HIGH', 'HIGHER', 'CRITICAL'];

    notifyListeners();
  }

  void updateTaskStatus(String uuid, String newStatus) {
    this._delegatedTasks.firstWhere((element) => element.uuid == uuid).taskStatus = newStatus;
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
      this._inboxTasks.removeWhere((element) => element.uuid == task.uuid);
    } else if (task.localization == 'ANYTIME') {
      this._anytimeTasks.removeWhere((element) => element.uuid == task.uuid);
    } else if (task.localization == 'SCHEDULED') {
      this._scheduledTasks.removeWhere((element) => element.uuid == task.uuid);
    } else if (task.localization == 'COMPLETED') {
      this._completedTasks.removeWhere((element) => element.uuid == task.uuid);
    } else if (task.localization == 'TRASH') {
      this._trashTasks.removeWhere((element) => element.uuid == task.uuid);
    } else if (task.localization == 'DELEGATED') {
      this._delegatedTasks.removeWhere((element) => element.uuid == task.uuid);
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
      if (task.tags != null) {
        task.tags.forEach((tag) async {
          if (tag.name == oldName) {
            tag.name = newName;
            await TaskDatabase.update(task, this.userMail);
          }
        });
      }
    });

    this._anytimeTasks.forEach((task) {
      if (task.tags != null) {
        task.tags.forEach((tag) async {
          if (tag.name == oldName) {
            tag.name = newName;
            await TaskDatabase.update(task, this.userMail);
          }
        });
      }
    });

    this._scheduledTasks.forEach((task) {
      if (task.tags != null) {
        task.tags.forEach((tag) async {
          if (tag.name == oldName) {
            tag.name = newName;
            await TaskDatabase.update(task, this.userMail);
          }
        });
      }
    });

    notifyListeners();
  }

  Future<void> deleteReceivedFromCollaborator(String collaboratorEmail, List<Location> locations) async {
    final receivedTasks = this.taskList.where((task) => task.supervisorEmail == collaboratorEmail);

    receivedTasks.forEach((task) {
      String newLocation = "TRASH";

      if (task.notificationLocalizationUuid == null) {
        this.updateTask(task, newLocation);
      } else {
        final longitude = locations.firstWhere((location) => location.uuid == task.notificationLocalizationUuid).longitude;
        final latitude = locations.firstWhere((location) => location.uuid == task.notificationLocalizationUuid).latitude;

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
        element.childUuid = null;
        element.parentUuid = null;

        String newLocation;

        if (element.startDate != null) {
          newLocation = 'SCHEDULED';
        } else {
          newLocation = 'ANYTIME';
        }

        if (element.notificationLocalizationUuid == null) {
          this.updateTask(element, newLocation);
        } else {
          final longitude = locations.firstWhere((location) => location.uuid == element.notificationLocalizationUuid).longitude;
          final latitude = locations.firstWhere((location) => location.uuid == element.notificationLocalizationUuid).latitude;

          this.updateTaskWithGeolocation(element, newLocation, longitude, latitude);
        }
      },
    );
  }

  void sortByPosition(List<Task> listToSort) {
    if (listToSort.length > 1) {
      listToSort.sort((a, b) {
        return a.position.compareTo(b.position);
      });
    }
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
        .where(
            (element) => (element.startDate != null && element.startDate.difference(DateTime.now()).inDays == 0 && element.startDate.day == DateTime.now().day))
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
    return [...listToFilter.where((element) => element.notificationLocalizationUuid != null)];
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

  List<Task> filterLocations(List<Task> listToFilter, List<String> filterLocations) {
    return [
      ...listToFilter.where((element) => (element.notificationLocalizationUuid != null && filterLocations.contains(element.notificationLocalizationUuid)))
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

  void notificationChange(String taskUuid, double notificationRadius, bool onExit, bool onEnter, double latitude, double longitude, String title,
      String description, int taskId) async {
    await Notifications.removeGeofence(taskUuid);
    if (taskUuid != null && latitude != null && longitude != null && notificationRadius != null) {
      await Notifications.addGeofence(taskUuid, latitude, longitude, notificationRadius, onEnter, onExit, title, description, taskId);
    }
  }

  int countInboxDelegated() {
    return this._inboxTasks.where((task) => (task.isDelegated != null && task.isDelegated == true && !task.done)).toList().length;
  }
}
