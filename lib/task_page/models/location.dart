import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:productive_app/task_page/models/tag.dart';

class Location{
  int id;
  String localizationName;
  double longitude;
  double latitude;

  Location({
    @required this.id,
    @required this.localizationName,
    @required this.longitude,
    @required this.latitude
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "localizationName": this.localizationName,
      "longitude": this.longitude,
      "latitude": this.latitude
    };
  }
}