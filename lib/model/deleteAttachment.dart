import 'package:flutter/cupertino.dart';

class DeleteAttachment {
  String uuid;

  DeleteAttachment({
    @required this.uuid,
  });

  Map<String, dynamic> toJson() {
    return {
      "uuid": this.uuid,
    };
  }
}
