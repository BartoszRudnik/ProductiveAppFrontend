import 'package:flutter/material.dart';

class DeleteLocation {
  String ownerEmail;
  String locationName;

  DeleteLocation({
    @required this.ownerEmail,
    @required this.locationName,
  });

  Map<String, dynamic> toJson() {
    return {
      "ownerEmail": this.ownerEmail,
      "locationName": this.locationName,
    };
  }
}
