import 'package:flutter/material.dart';

class DeleteTask {
  String uuid;

  DeleteTask({
    @required this.uuid,
  });

  Map<String, dynamic> toJson() {
    return {
      "uuid": this.uuid,
    };
  }
}
