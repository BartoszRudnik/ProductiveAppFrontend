import 'package:flutter/material.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/collaborators";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        title: 'Profile settings',
      ),
      body: Text("Settings screen"),
    );
  }
}
