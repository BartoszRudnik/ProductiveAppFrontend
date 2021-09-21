import 'package:flutter/foundation.dart';

final String tableTags = "tags";

class TagFields {
  static final List<String> values = [
    id,
    name,
    isSelected,
    lastUpdated,
    uuid,
  ];

  static final String id = "id";
  static final String name = "name";
  static final String isSelected = "isSelected";
  static final String lastUpdated = "lastUpdated";
  static final String uuid = "uuid";
}

class Tag {
  int id;
  String name;
  bool isSelected;
  DateTime lastUpdated;
  String uuid;

  Tag({
    this.isSelected = false,
    this.lastUpdated,
    @required this.id,
    @required this.name,
    @required this.uuid,
  });

  Tag copy({
    int id,
    String name,
    bool isSelected,
    DateTime lastUpdated,
    String uuid,
  }) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected,
        lastUpdated: DateTime.now(),
        uuid: uuid ?? this.uuid,
      );

  static Tag fromJson(Map<String, Object> json) => Tag(
        uuid: json[TagFields.uuid] == null ? null : json[TagFields.uuid] as String,
        id: json[TagFields.id] == null ? null : json[TagFields.id] as int,
        name: json[TagFields.name] == null ? null : json[TagFields.name] as String,
        isSelected: json[TagFields.isSelected] == null ? null : json[TagFields.isSelected] == 1,
        lastUpdated: json[TagFields.lastUpdated] == null ? null : DateTime.tryParse(json[TagFields.lastUpdated] as String),
      );

  Map<String, dynamic> toJson() {
    return {
      TagFields.uuid: this.uuid,
      TagFields.id: this.id,
      TagFields.name: this.name,
      TagFields.isSelected: this.isSelected ? 1 : 0,
      TagFields.lastUpdated: this.lastUpdated != null ? this.lastUpdated.toIso8601String() : DateTime.now().toIso8601String()
    };
  }
}
