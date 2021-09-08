import 'package:flutter/material.dart';

class DeleteTask {
  String ownerEmail;
  String taskName;
  int taskId;

  DeleteTask({
    @required this.ownerEmail,
    @required this.taskId,
    @required this.taskName,
  });

  Map<String, dynamic> toJson() {
    return {
      "ownerEmail": this.ownerEmail,
      "taskId": this.taskId,
      "taskName": this.taskName,
    };
  }
}
