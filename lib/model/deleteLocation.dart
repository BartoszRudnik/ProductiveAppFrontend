import 'package:flutter/material.dart';

class DeleteLocation {
  String uuid;

  DeleteLocation({
    @required this.uuid,
  });

  Map<String, dynamic> toJson() {
    return {
      "uuid": this.uuid,
    };
  }
}
