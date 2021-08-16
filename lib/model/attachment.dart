import 'package:flutter/material.dart';

class Attachment {
  int id;
  int taskId;
  String fileName;
  bool toDelete = false;

  Attachment({
    @required this.id,
    @required this.taskId,
    @required this.fileName,
  });
}
