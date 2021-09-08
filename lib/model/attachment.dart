import 'dart:typed_data';

import 'package:flutter/material.dart';

final String tableAttachment = "attachment";

class AttachmentFields {
  static final List<String> values = [
    id,
    taskId,
    fileName,
    toDelete,
    lastUpdated,
    localFile,
    uuid,
  ];

  static final String id = "id";
  static final String taskId = "taskId";
  static final String fileName = "fileName";
  static final String toDelete = "toDelete";
  static final String lastUpdated = "lastUpdated";
  static final String localFile = "localFile";
  static final String uuid = "uuid";
}

class Attachment {
  int id;
  int taskId;
  String fileName;
  bool toDelete;
  DateTime lastUpdated;
  Uint8List localFile;
  String uuid;

  Attachment({
    this.id,
    @required this.taskId,
    @required this.fileName,
    @required this.uuid,
    this.lastUpdated,
    this.localFile,
    this.toDelete = false,
  });

  Attachment copy({
    int id,
    int taskId,
    String fileName,
    bool toDelete,
    DateTime lastUpdated,
    Uint8List localFile,
    String uuid,
  }) =>
      Attachment(
        uuid: uuid ?? this.uuid,
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        fileName: fileName ?? this.fileName,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        localFile: localFile ?? this.localFile,
        toDelete: toDelete ?? this.toDelete,
      );

  Map<String, dynamic> toJson() {
    return {
      AttachmentFields.uuid: this.uuid,
      AttachmentFields.id: this.id,
      AttachmentFields.taskId: this.taskId,
      AttachmentFields.fileName: this.fileName,
      AttachmentFields.toDelete: this.toDelete ? 1 : 0,
      AttachmentFields.lastUpdated: this.lastUpdated != null ? this.lastUpdated.toIso8601String() : DateTime.now().toIso8601String(),
      AttachmentFields.localFile: this.localFile
    };
  }

  static Attachment fromJson(Map<String, Object> json) => Attachment(
        uuid: json[AttachmentFields.uuid] as String,
        id: json[AttachmentFields.id] as int,
        taskId: json[AttachmentFields.taskId] as int,
        fileName: json[AttachmentFields.fileName] as String,
        toDelete: json[AttachmentFields.toDelete] == 1 ? true : false,
        localFile: json[AttachmentFields.localFile],
        lastUpdated: DateTime.tryParse(json[AttachmentFields.lastUpdated] as String),
      );
}
