import 'package:flutter/cupertino.dart';

class DeleteCollaborator {
  String uuid;

  DeleteCollaborator({
    @required this.uuid,
  });

  Map<String, dynamic> toJson() {
    return {
      "uuid": this.uuid,
    };
  }
}
