import 'package:flutter/material.dart';

class Location {
  int id;
  String localizationName;
  String locality;
  String street;
  String country;
  double longitude;
  double latitude;

  Location({
    @required this.id,
    @required this.localizationName,
    @required this.longitude,
    @required this.latitude,
    @required this.country,
    @required this.locality,
    @required this.street,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "localizationName": this.localizationName,
      "longitude": this.longitude,
      "latitude": this.latitude,
      "street": this.street,
      "locality": this.locality,
      "country": this.country,
    };
  }
}
