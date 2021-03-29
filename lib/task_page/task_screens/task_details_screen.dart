import 'package:flutter/material.dart';
import 'package:productive_app/task_page/widgets/task_appBar.dart';

class TaskDetailScreen extends StatelessWidget {
  static const routeName = "/task-details";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(
        title: 'Details',
      ),
      body: Center(
        child: Text('Task details'),
      ),
    );
  }
}
