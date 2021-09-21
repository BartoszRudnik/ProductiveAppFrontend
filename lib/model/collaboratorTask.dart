import 'package:flutter/material.dart';

final String tableCollaboratorTask = "collaboratorTask";

class CollaboratorTaskFields {
  static final List<String> values = [
    id,
    title,
    description,
    startDate,
    endDate,
    lastUpdated,
    uuid,
  ];

  static final String uuid = "uuid";
  static final String id = "id";
  static final String title = "title";
  static final String description = "description";
  static final String startDate = "startDate";
  static final String endDate = "endDate";
  static final String lastUpdated = "lastUpdated";
}

class CollaboratorTask {
  int id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  DateTime lastUpdated;
  String uuid;

  CollaboratorTask({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.startDate,
    @required this.endDate,
    @required this.lastUpdated,
    @required this.uuid,
  });

  CollaboratorTask copy({
    String uuid,
    int id,
    String title,
    String description,
    DateTime startDate,
    DateTime endDate,
    DateTime lastUpdated,
  }) =>
      CollaboratorTask(
        uuid: uuid ?? this.uuid,
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  static CollaboratorTask fromJson(Map<String, Object> json) => CollaboratorTask(
        uuid: json[CollaboratorTaskFields.uuid] as String,
        id: json[CollaboratorTaskFields.id] as int,
        title: json[CollaboratorTaskFields.title] as String,
        description: json[CollaboratorTaskFields.description] as String,
        startDate: DateTime.parse(json[CollaboratorTaskFields.startDate] as String),
        endDate: DateTime.parse(json[CollaboratorTaskFields.endDate] as String),
        lastUpdated: DateTime.parse(json[CollaboratorTaskFields.lastUpdated] as String),
      );

  Map<String, dynamic> toJson() {
    return {
      CollaboratorTaskFields.uuid: this.uuid,
      CollaboratorTaskFields.id: this.id,
      CollaboratorTaskFields.title: this.title,
      CollaboratorTaskFields.description: this.description,
      CollaboratorTaskFields.startDate: this.startDate.toIso8601String(),
      CollaboratorTaskFields.endDate: this.endDate.toIso8601String(),
      CollaboratorTaskFields.lastUpdated: this.lastUpdated.toIso8601String(),
    };
  }
}
