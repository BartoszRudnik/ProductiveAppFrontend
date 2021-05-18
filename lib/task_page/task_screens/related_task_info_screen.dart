import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productive_app/task_page/models/task.dart';
import 'package:productive_app/task_page/providers/settings_provider.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';
import 'package:provider/provider.dart';

class RelatedTaskInfoScreen extends StatefulWidget{
  static const routeName = '/related-task-info-screen';

  @override
  _RelatedTaskInfoScreenState createState() => _RelatedTaskInfoScreenState();
}

class _RelatedTaskInfoScreenState extends State<RelatedTaskInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        title: 'Related task',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text("Related task details"),
        )
      )
    );
  }
}