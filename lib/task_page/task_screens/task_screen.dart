import 'package:flutter/material.dart';
import 'package:productive_app/task_page/appbar/task_appBar.dart';
import 'package:productive_app/task_page/drawers/main_drawer.dart';

class TaskScreen extends StatelessWidget {
  static const routeName = '/task-screen';

  String username = 'Karolina Modzelewska';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(),
      drawer: MainDrawer(
        username: this.username,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
          size: 50,
        ),
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
