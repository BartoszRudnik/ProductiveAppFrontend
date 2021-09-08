import 'package:flutter/material.dart';
import 'package:productive_app/model/tag.dart';
import 'package:productive_app/provider/tag_provider.dart';
import 'package:provider/provider.dart';

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
    parentId,
    childId,
    notificationLocalizationId,
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
  static final String parentId = "parentId";
  static final String childId = "childId";
  static final String notificationLocalizationId = "notificationLocalizationId";
  static final String notificationLocalizationRadius = "notificationLocalizationRadius";
  static final String notificationOnEnter = "notificationOnEnter";
  static final String notificationOnExit = "notificationOnExit";
  static final String lastUpdated = "lastUpdated";
  static final String uuid = "uuid";
}

class Task with ChangeNotifier {
  int id;
  double position;
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
  int parentId;
  int childId;

  int notificationLocalizationId;
  double notificationLocalizationRadius;
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

  static List<Tag> splitTagList(String toSplit, BuildContext context) {
    if (toSplit != null && toSplit.length > 0) {
      final stringList = toSplit.split('|');

      List<String> idList = [];

      stringList.forEach((element) {
        idList.add(element);
      });

      final tagList = Provider.of<TagProvider>(context, listen: false).tagList;

      List<Tag> result = [];

      idList.forEach(
        (element) {
          result.add(tagList.firstWhere((tag) => tag.name == element, orElse: () => null));
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
    this.childId,
    this.parentId,
    this.notificationLocalizationId,
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
    double position,
    String delegatedEmail,
    bool isDelegated,
    String taskStatus,
    bool isCanceled,
    String supervisorEmail,
    int childId,
    int parentId,
    int notificationLocalizationId,
    double notificationLocalizationRadius,
    bool notificationOnEnter,
    bool notificationOnExit,
    DateTime lastUpdated,
    String uuid,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        childId: childId ?? this.childId,
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
        parentId: parentId ?? this.parentId,
        notificationLocalizationId: notificationLocalizationId ?? this.notificationLocalizationId,
        notificationLocalizationRadius: notificationLocalizationRadius ?? this.notificationLocalizationRadius,
        notificationOnEnter: notificationOnEnter ?? this.notificationOnEnter,
        notificationOnExit: notificationOnExit ?? this.notificationOnExit,
        uuid: uuid ?? this.uuid,
        lastUpdated: DateTime.now(),
      );

  static Task fromJson(Map<String, Object> json, BuildContext context) {
    return Task(
      uuid: json[TaskFields.uuid] == null ? null : json[TaskFields.uuid] as String,
      id: json[TaskFields.id] == null ? null : json[TaskFields.id] as int,
      title: json[TaskFields.title] == null ? null : json[TaskFields.title] as String,
      childId: json[TaskFields.childId] == null ? null : json[TaskFields.childId] as int,
      priority: json[TaskFields.priority] == null ? null : json[TaskFields.priority] as String,
      description: json[TaskFields.description] == null ? null : json[TaskFields.description] as String,
      startDate: json[TaskFields.startDate] == null ? null : DateTime.tryParse(json[TaskFields.startDate] as String),
      endDate: json[TaskFields.endDate] == null ? null : DateTime.tryParse(json[TaskFields.endDate] as String),
      tags: json[TaskFields.tags] == null ? null : splitTagList(json[TaskFields.tags] as String, context),
      done: json[TaskFields.done] == null ? false : json[TaskFields.done] == 1,
      localization: json[TaskFields.localization] == null ? null : json[TaskFields.localization] as String,
      position: json[TaskFields.position] == null ? null : json[TaskFields.position] as double,
      delegatedEmail: json[TaskFields.delegatedEmail] == null ? null : json[TaskFields.delegatedEmail] as String,
      isDelegated: json[TaskFields.isDelegated] == null ? false : json[TaskFields.isDelegated] == 1,
      isCanceled: json[TaskFields.isCanceled] == null ? false : json[TaskFields.isCanceled] == 1,
      taskStatus: json[TaskFields.taskStatus] == null ? null : json[TaskFields.taskStatus] as String,
      supervisorEmail: json[TaskFields.supervisorEmail] == null ? null : json[TaskFields.supervisorEmail] as String,
      parentId: json[TaskFields.parentId] == null ? null : json[TaskFields.parentId] as int,
      notificationLocalizationId: json[TaskFields.notificationLocalizationId] == null ? null : json[TaskFields.notificationLocalizationId] as int,
      notificationLocalizationRadius:
          json[TaskFields.notificationLocalizationRadius] == null ? null : json[TaskFields.notificationLocalizationRadius] as double,
      notificationOnEnter: json[TaskFields.notificationOnEnter] == null ? false : json[TaskFields.notificationOnEnter] == 1,
      notificationOnExit: json[TaskFields.notificationOnExit] == null ? false : json[TaskFields.notificationOnExit] == 1,
      lastUpdated: json[TaskFields.lastUpdated] == null ? null : DateTime.tryParse(json[TaskFields.lastUpdated] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      TaskFields.uuid: this.uuid,
      TaskFields.id: this.id,
      TaskFields.title: this.title,
      TaskFields.childId: this.childId,
      TaskFields.priority: this.priority,
      TaskFields.description: this.description,
      TaskFields.startDate: this.startDate != null ? this.startDate.toIso8601String() : null,
      TaskFields.endDate: this.endDate != null ? this.endDate.toIso8601String() : null,
      TaskFields.tags: this.joinTagList(this.tags),
      TaskFields.done: this.done == null
          ? 0
          : this.done
              ? 1
              : 0,
      TaskFields.localization: this.localization,
      TaskFields.position: this.position,
      TaskFields.delegatedEmail: this.delegatedEmail,
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
      TaskFields.taskStatus: this.taskStatus,
      TaskFields.supervisorEmail: this.supervisorEmail,
      TaskFields.parentId: this.parentId,
      TaskFields.notificationLocalizationId: this.notificationLocalizationId,
      TaskFields.notificationLocalizationRadius: this.notificationLocalizationRadius,
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
    };
  }
}
