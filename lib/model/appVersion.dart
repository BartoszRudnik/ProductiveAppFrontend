import 'package:flutter/material.dart';

final String tableVersion = "version";

class VersionFields {
  static final List<String> values = [
    version,
  ];

  static final String version = "version";
}

class AppVersion {
  String version;

  AppVersion({
    @required this.version,
  });

  AppVersion copy({
    String version,
  }) =>
      AppVersion(
        version: version ?? this.version,
      );

  Map<String, dynamic> toJson() {
    return {
      VersionFields.version: this.version,
    };
  }

  static AppVersion fromJson(Map<String, Object> json) => AppVersion(
        version: json[VersionFields.version] as String,
      );
}
