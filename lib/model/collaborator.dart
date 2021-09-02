import 'package:flutter/material.dart';

final String tableCollaborators = "collaborators";

class CollaboratorsFields {
  static final List<String> values = [
    id,
    email,
    relationState,
    collaboratorName,
    alreadyAsked,
    isAskingForPermission,
    sentPermission,
    receivedPermission,
    received,
    isSelected,
    lastUpdated,
  ];

  static final String id = "id";
  static final String email = "email";
  static final String relationState = "relationState";
  static final String collaboratorName = "collaboratorName";
  static final String alreadyAsked = "alreadyAsked";
  static final String isAskingForPermission = "isAskingForPermission";
  static final String sentPermission = "sentPermission";
  static final String receivedPermission = "receivedPermission";
  static final String received = "received";
  static final String isSelected = "isSelected";
  static final String lastUpdated = "lastUpdated";
}

class Collaborator {
  int id;
  String email;
  String relationState;
  String collaboratorName;
  bool alreadyAsked;
  bool isAskingForPermission;
  bool sentPermission;
  bool receivedPermission;
  bool received;
  bool isSelected;

  DateTime lastUpdated;

  Collaborator({
    this.lastUpdated,
    this.id,
    this.sentPermission = false,
    this.receivedPermission = false,
    this.collaboratorName,
    @required this.email,
    @required this.relationState,
    this.isSelected = false,
    this.received = false,
    this.isAskingForPermission = false,
    this.alreadyAsked = false,
  });

  Collaborator copy({
    int id,
    String email,
    String relationState,
    String collaboratorName,
    bool alreadyAsked,
    bool isAskingForPermission,
    bool sentPermission,
    bool receivedPermission,
    bool received,
    bool isSelected,
    DateTime lastUpdated,
  }) =>
      Collaborator(
        email: email ?? this.email,
        relationState: relationState ?? this.relationState,
        id: id ?? this.id,
        collaboratorName: collaboratorName ?? this.collaboratorName,
        alreadyAsked: alreadyAsked ?? this.alreadyAsked,
        isAskingForPermission: isAskingForPermission ?? this.isAskingForPermission,
        sentPermission: sentPermission ?? this.sentPermission,
        receivedPermission: receivedPermission ?? this.receivedPermission,
        received: received ?? this.received,
        isSelected: isSelected ?? this.isSelected,
        lastUpdated: DateTime.now(),
      );

  static Collaborator fromJson(Map<String, Object> json) => Collaborator(
        id: json[CollaboratorsFields.id] as int,
        email: json[CollaboratorsFields.email] as String,
        relationState: json[CollaboratorsFields.relationState] as String,
        collaboratorName: json[CollaboratorsFields.collaboratorName] as String,
        alreadyAsked: json[CollaboratorsFields.alreadyAsked] == 1,
        isAskingForPermission: json[CollaboratorsFields.isAskingForPermission] == 1,
        sentPermission: json[CollaboratorsFields.sentPermission] == 1,
        receivedPermission: json[CollaboratorsFields.receivedPermission] == 1,
        received: json[CollaboratorsFields.received] == 1,
        isSelected: json[CollaboratorsFields.isSelected] == 1,
        lastUpdated: DateTime.parse(json[CollaboratorsFields.lastUpdated] as String),
      );

  Map<String, dynamic> toJson() {
    return {
      CollaboratorsFields.id: this.id,
      CollaboratorsFields.email: this.email,
      CollaboratorsFields.relationState: this.relationState,
      CollaboratorsFields.collaboratorName: this.collaboratorName,
      CollaboratorsFields.alreadyAsked: this.alreadyAsked ? 1 : 0,
      CollaboratorsFields.isAskingForPermission: this.isAskingForPermission ? 1 : 0,
      CollaboratorsFields.sentPermission: this.sentPermission ? 1 : 0,
      CollaboratorsFields.receivedPermission: this.receivedPermission ? 1 : 0,
      CollaboratorsFields.received: this.received ? 1 : 0,
      CollaboratorsFields.isSelected: this.isSelected ? 1 : 0,
      CollaboratorsFields.lastUpdated: this.lastUpdated != null ? this.lastUpdated.toIso8601String() : DateTime.now().toIso8601String()
    };
  }
}
