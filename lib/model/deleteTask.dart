import 'package:flutter/material.dart';

class DeleteTask{
  String ownerEmail;
  int taskId;

  DeleteTask({
    @required this.ownerEmail,
    @required this.taskId,
});

  Map<String, dynamic> toJson() {
    return {
      "ownerEmail": this.ownerEmail,
      "taskId": this.taskId,
    };
  }
}