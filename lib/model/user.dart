import 'dart:typed_data';

import 'package:flutter/material.dart';

final String tableUser = "user";

class UserFields {
  static final List<String> values = [
    id,
    firstName,
    lastName,
    localImage,
    email,
    userType,
    lastUpdatedImage,
    lastUpdatedName,
    removed,
  ];

  static final String id = 'id';
  static final String firstName = "firstName";
  static final String lastName = "lastName";
  static final String localImage = "localImage";
  static final String email = "email";
  static final String userType = "userType";
  static final String lastUpdatedImage = "lastUpdatedImage";
  static final String lastUpdatedName = "lastUpdatedName";
  static final String removed = "removed";
}

class User with ChangeNotifier {
  int id;
  String firstName;
  String lastName;
  String email;
  String userType;
  NetworkImage userImage;
  Uint8List localImage;
  DateTime lastUpdatedImage;
  DateTime lastUpdatedName;
  bool removed;

  User({
    @required this.email,
    @required this.userType,
    this.id,
    this.firstName,
    this.lastName,
    this.localImage,
    this.lastUpdatedImage,
    this.lastUpdatedName,
    this.removed = false,
  });

  User copy({
    int id,
    String firstName,
    String lastName,
    Uint8List localImage,
    String email,
    String userType,
    DateTime lastUpdatedImage,
    DateTime lastUpdatedName,
    bool removed,
  }) =>
      User(
        email: email ?? this.email,
        userType: userType ?? this.userType,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        id: id ?? this.id,
        lastUpdatedImage: DateTime.now(),
        lastUpdatedName: DateTime.now(),
        localImage: localImage ?? this.localImage,
        removed: removed ?? this.removed,
      );

  Map<String, dynamic> toJson() {
    return {
      UserFields.id: this.id,
      UserFields.firstName: this.firstName,
      UserFields.lastName: this.lastName,
      UserFields.localImage: this.localImage,
      UserFields.email: this.email,
      UserFields.userType: this.userType,
      UserFields.removed: this.removed ? 1 : 0,
      UserFields.lastUpdatedImage: this.lastUpdatedImage != null ? this.lastUpdatedImage.toIso8601String() : DateTime.now().toIso8601String(),
      UserFields.lastUpdatedName: this.lastUpdatedName != null ? this.lastUpdatedName.toIso8601String() : DateTime.now().toIso8601String(),
    };
  }

  static User fromJson(Map<String, Object> json) => User(
        id: json[UserFields.id] as int,
        email: json[UserFields.email] as String,
        firstName: json[UserFields.firstName] as String,
        lastName: json[UserFields.lastName] as String,
        localImage: json[UserFields.localImage],
        userType: json[UserFields.userType] as String,
        removed: json[UserFields.removed] == 1 ? true : false,
        lastUpdatedImage: DateTime.parse(json[UserFields.lastUpdatedImage] as String),
        lastUpdatedName: DateTime.parse(json[UserFields.lastUpdatedName] as String),
      );
}
