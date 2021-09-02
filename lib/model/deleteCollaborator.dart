import 'package:flutter/cupertino.dart';

class DeleteCollaborator {
  String user1Mail;
  String user2Mail;

  DeleteCollaborator({
    @required this.user1Mail,
    @required this.user2Mail,
  });

  Map<String, dynamic> toJson() {
    return {
      "user1Mail": this.user1Mail,
      "user2Mail": this.user2Mail,
    };
  }
}
