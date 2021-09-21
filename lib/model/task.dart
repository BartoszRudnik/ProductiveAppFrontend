import 'package:flutter/material.dart';
import 'package:productive_app/model/tag.dart';

final String tableTask = "task";

class TaskFields {
  static final List<String> values = [
    id,
    position,
    title,
    description,
    priority,
    localization,
    delegatedEmail,
    taskStatus,
    supervisorEmail,
    startDate,
    endDate,
    tags,
    done,
    isDelegated,
    isCanceled,
    parentUuid,
    childUuid,
    notificationLocalizationUuid,
    notificationLocalizationRadius,
    notificationOnEnter,
    notificationOnExit,
    lastUpdated,
    uuid,
  ];

  static final String id = "id";
  static final String position = "position";
  static final String title = "title";
  static final String description = "description";
  static final String priority = "priority";
  static final String localization = "localization";
  static final String delegatedEmail = "delegatedEmail";
  static final String taskStatus = "taskStatus";
  static final String supervisorEmail = "supervisorEmail";
  static final String startDate = "startDate";
  static final String endDate = "endDate";
  static final String tags = "tags";
  static final String done = "done";
  static final String isDelegated = "isDelegated";
  static final String isCanceled = "isCanceled";
  static final String parentUuid = "parentUuid";
  static final String childUuid = "childUuid";
  static final String notificationLocalizationUuid = "notificationLocalizationUuid";
  static final String notificationLocalizationRadius = "notificationLocalizationRadius";
  static final String notificationOnEnter = "notificationOnEnter";
  static final String notificationOnExit = "notificationOnExit";
  static final String lastUpdated = "lastUpdated";
  static final String uuid = "uuid";
}

class Task {
  int id;
  num position;
  String title;
  String description;
  String priority;
  String localization;
  String delegatedEmail;
  String taskStatus;
  String supervisorEmail;
  DateTime startDate;
  DateTime endDate;
  List<Tag> tags;
  bool done;
  bool isDelegated;
  bool isCanceled;
  String parentUuid;
  String childUuid;

  String notificationLocalizationUuid;
  num notificationLocalizationRadius;
  bool notificationOnEnter;
  bool notificationOnExit;

  DateTime lastUpdated;
  String uuid;

  String joinTagList(List<Tag> tagList) {
    if (tagList != null && tagList.length > 0) {
      List<String> listOfId = [];

      tagList.forEach((element) {
        listOfId.add(element.name);
      });

      return listOfId.join('|');
    } else {
      return null;
    }
  }

  static List<Tag> splitTagList(String toSplit, List<Tag> tags) {
    if (toSplit != null && toSplit.length > 0 && tags != null) {
      final stringList = toSplit.split('|');

      List<String> idList = [];

      stringList.forEach((element) {
        idList.add(element);
      });

      List<Tag> result = [];

      idList.forEach(
        (element) {
          result.add(tags.firstWhere((tag) => tag.name == element, orElse: () => null));
        },
      );

      return result;
    } else {
      return null;
    }
  }

  Task({
    @required this.id,
    @required this.title,
    this.priority,
    this.description,
    this.startDate,
    this.endDate,
    this.tags,
    this.done = false,
    this.localization,
    this.position = 0.0,
    this.delegatedEmail,
    this.isDelegated = false,
    this.taskStatus,
    this.isCanceled = false,
    this.supervisorEmail,
    this.childUuid,
    this.parentUuid,
    this.notificationLocalizationUuid,
    this.notificationLocalizationRadius,
    this.notificationOnEnter = false,
    this.notificationOnExit = false,
    this.lastUpdated,
    @required this.uuid,
  });

  Task copy({
    int id,
    String title,
    String priority,
    String description,
    DateTime startDate,
    DateTime endDate,
    List<Tag> tags,
    bool done,
    String localization,
    num position,
    String delegatedEmail,
    bool isDelegated,
    String taskStatus,
    bool isCanceled,
    String supervisorEmail,
    String childUuid,
    String parentUuid,
    String notificationLocalizationUuid,
    num notificationLocalizationRadius,
    bool notificationOnEnter,
    bool notificationOnExit,
    DateTime lastUpdated,
    String uuid,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        childUuid: childUuid ?? this.childUuid,
        priority: priority ?? this.priority,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        tags: tags ?? this.tags,
        done: done ?? this.done,
        localization: localization ?? this.localization,
        position: position ?? this.position,
        delegatedEmail: delegatedEmail ?? this.delegatedEmail,
        isDelegated: isDelegated ?? this.isDelegated,
        isCanceled: isCanceled ?? this.isCanceled,
        taskStatus: taskStatus ?? this.taskStatus,
        supervisorEmail: supervisorEmail ?? this.supervisorEmail,
        parentUuid: parentUuid ?? this.parentUuid,
        notificationLocalizationUuid: notificationLocalizationUuid ?? this.notificationLocalizationUuid,
        notificationLocalizationRadius: notificationLocalizationRadius ?? this.notificationLocalizationRadius,
        notificationOnEnter: notificationOnEnter ?? this.notificationOnEnter,
        notificationOnExit: notificationOnExit ?? this.notificationOnExit,
        uuid: uuid ?? this.uuid,
        lastUpdated: DateTime.now(),
      );

  static Task fromJson(Map<String, Object> json, List<Tag> tags) {
    return Task(
      id: json[TaskFields.id] == null ? null : json[TaskFields.id] as int,
      title: json[TaskFields.title] == null ? null : json[TaskFields.title] as String,
      childUuid: json[TaskFields.childUuid] == null ? null : json[TaskFields.childUuid] as String,
      priority: json[TaskFields.priority] == null ? null : json[TaskFields.priority] as String,
      description: json[TaskFields.description] == null ? null : json[TaskFields.description] as String,
      startDate: json[TaskFields.startDate] == null ? null : DateTime.parse(json[TaskFields.startDate] as String),
      endDate: json[TaskFields.endDate] == null ? null : DateTime.parse(json[TaskFields.endDate] as String),
      tags: json[TaskFields.tags] == null ? null : splitTagList(json[TaskFields.tags] as String, tags),
      done: json[TaskFields.done] == null ? false : json[TaskFields.done] == 1,
      localization: json[TaskFields.localization] == null ? null : json[TaskFields.localization] as String,
      position: json[TaskFields.position] == null ? null : json[TaskFields.position],
      delegatedEmail: json[TaskFields.delegatedEmail] == null ? null : json[TaskFields.delegatedEmail] as String,
      isDelegated: json[TaskFields.isDelegated] == null ? false : json[TaskFields.isDelegated] == 1,
      isCanceled: json[TaskFields.isCanceled] == null ? false : json[TaskFields.isCanceled] == 1,
      taskStatus: json[TaskFields.taskStatus] == null ? null : json[TaskFields.taskStatus] as String,
      supervisorEmail: json[TaskFields.supervisorEmail] == null ? null : json[TaskFields.supervisorEmail] as String,
      parentUuid: json[TaskFields.parentUuid] == null ? null : json[TaskFields.parentUuid] as String,
      notificationLocalizationUuid: json[TaskFields.notificationLocalizationUuid] == null ? null : json[TaskFields.notificationLocalizationUuid] as String,
      notificationLocalizationRadius:
          json[TaskFields.notificationLocalizationRadius] == null ? null : json[TaskFields.notificationLocalizationRadius] as double,
      notificationOnEnter: json[TaskFields.notificationOnEnter] == null ? false : json[TaskFields.notificationOnEnter] == 1,
      notificationOnExit: json[TaskFields.notificationOnExit] == null ? false : json[TaskFields.notificationOnExit] == 1,
      lastUpdated: json[TaskFields.lastUpdated] == null ? null : DateTime.parse(json[TaskFields.lastUpdated] as String),
      uuid: json[TaskFields.uuid] == null ? null : json[TaskFields.uuid] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      TaskFields.id: this.id,
      TaskFields.title: this.title ?? null,
      TaskFields.childUuid: this.childUuid ?? null,
      TaskFields.priority: this.priority ?? null,
      TaskFields.description: this.description ?? null,
      TaskFields.startDate: this.startDate != null ? this.startDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
      TaskFields.endDate: this.endDate != null ? this.endDate.toIso8601String() : DateTime.fromMicrosecondsSinceEpoch(0).toIso8601String(),
      TaskFields.tags: this.joinTagList(this.tags),
      TaskFields.done: this.done == null
          ? 0
          : this.done
              ? 1
              : 0,
      TaskFields.localization: this.localization ?? null,
      TaskFields.position: this.position ?? null,
      TaskFields.delegatedEmail: this.delegatedEmail ?? null,
      TaskFields.isDelegated: this.isDelegated == null
          ? 0
          : this.isDelegated
              ? 1
              : 0,
      TaskFields.isCanceled: this.isCanceled == null
          ? 0
          : this.isCanceled
              ? 1
              : 0,
      TaskFields.taskStatus: this.taskStatus ?? null,
      TaskFields.supervisorEmail: this.supervisorEmail ?? null,
      TaskFields.parentUuid: this.parentUuid ?? null,
      TaskFields.notificationLocalizationUuid: this.notificationLocalizationUuid ?? null,
      TaskFields.notificationLocalizationRadius: this.notificationLocalizationRadius ?? null,
      TaskFields.notificationOnEnter: this.notificationOnEnter == null
          ? 0
          : this.notificationOnEnter
              ? 1
              : 0,
      TaskFields.notificationOnExit: this.notificationOnExit == null
          ? 0
          : this.notificationOnExit
              ? 1
              : 0,
      TaskFields.lastUpdated: this.lastUpdated != null ? this.lastUpdated.toIso8601String() : DateTime.now().toIso8601String(),
      TaskFields.uuid: this.uuid ?? null,
    };
  }
}
