import 'package:flutter/material.dart';

class DeleteTag {
  String ownerEmail;
  String tagName;

  DeleteTag({
    @required this.ownerEmail,
    @required this.tagName,
  });

  Map<String, dynamic> toJson() {
    return {
      "ownerEmail": this.ownerEmail,
      "tagName": this.tagName,
    };
  }
}
