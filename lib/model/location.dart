import 'package:flutter/material.dart';

final String tableLocations = "locations";

class LocationFields {
  static final List<String> values = [
    id,
    localizationName,
    locality,
    street,
    country,
    longitude,
    latitude,
    lastUpdated,
    isSelected,
  ];

  static final String id = "id";
  static final String localizationName = "localizationName";
  static final String locality = "locality";
  static final String street = "street";
  static final String country = "country";
  static final String longitude = "longitude";
  static final String latitude = "latitude";
  static final String lastUpdated = "lastUpdated";
  static final String isSelected = "isSelected";
}

class Location {
  int id;
  String localizationName;
  String locality;
  String street;
  String country;
  double longitude;
  double latitude;

  DateTime lastUpdated;

  bool isSelected;

  Location({
    this.lastUpdated,
    @required this.id,
    @required this.localizationName,
    @required this.longitude,
    @required this.latitude,
    @required this.country,
    @required this.locality,
    @required this.street,
    this.isSelected = false,
  });

  Location copy({
    int id,
    String localizationName,
    String locality,
    String street,
    String country,
    double longitude,
    double latitude,
    DateTime lastUpdated,
    bool isSelected,
  }) =>
      Location(
        id: id ?? this.id,
        localizationName: localizationName ?? this.localizationName,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        country: country ?? this.country,
        locality: locality ?? this.locality,
        street: street ?? this.street,
        lastUpdated: DateTime.now(),
        isSelected: isSelected ?? this.isSelected,
      );

  static Location fromJson(Map<String, Object> json) => Location(
        id: json[LocationFields.id] as int,
        localizationName: json[LocationFields.localizationName] as String,
        longitude: json[LocationFields.longitude] as double,
        latitude: json[LocationFields.latitude] as double,
        country: json[LocationFields.country] as String,
        locality: json[LocationFields.locality] as String,
        street: json[LocationFields.street] as String,
        isSelected: json[LocationFields.isSelected] == 1,
        lastUpdated: DateTime.parse(
          json[LocationFields.lastUpdated] as String,
        ),
      );

  Map<String, dynamic> toJson() {
    return {
      LocationFields.id: this.id,
      LocationFields.localizationName: this.localizationName,
      LocationFields.longitude: this.longitude,
      LocationFields.latitude: this.latitude,
      LocationFields.street: this.street,
      LocationFields.locality: this.locality,
      LocationFields.country: this.country,
      LocationFields.isSelected: this.isSelected ? 1 : 0,
      LocationFields.lastUpdated:
          this.lastUpdated != null ? this.lastUpdated.toIso8601String() : DateTime.now().toIso8601String()
    };
  }
}
