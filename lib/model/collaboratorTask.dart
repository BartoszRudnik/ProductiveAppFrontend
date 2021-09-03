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
  ];

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

  CollaboratorTask({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.startDate,
    @required this.endDate,
    @required this.lastUpdated,
  });

  CollaboratorTask copy({
    int id,
    String title,
    String description,
    DateTime startDate,
    DateTime endDate,
    DateTime lastUpdated,
  }) =>
      CollaboratorTask(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  static CollaboratorTask fromJson(Map<String, Object> json) => CollaboratorTask(
        id: json[CollaboratorTaskFields.id] as int,
        title: json[CollaboratorTaskFields.title] as String,
        description: json[CollaboratorTaskFields.description] as String,
        startDate: DateTime.parse(json[CollaboratorTaskFields.startDate] as String),
        endDate: DateTime.parse(json[CollaboratorTaskFields.endDate] as String),
        lastUpdated: DateTime.parse(json[CollaboratorTaskFields.lastUpdated] as String),
      );

  Map<String, dynamic> toJson() {
    return {
      CollaboratorTaskFields.id: this.id,
      CollaboratorTaskFields.title: this.title,
      CollaboratorTaskFields.description: this.description,
      CollaboratorTaskFields.startDate: this.startDate.toIso8601String(),
      CollaboratorTaskFields.endDate: this.endDate.toIso8601String(),
      CollaboratorTaskFields.lastUpdated: this.lastUpdated.toIso8601String(),
    };
  }
}
