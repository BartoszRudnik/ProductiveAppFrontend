import 'package:flutter/material.dart';

import '../models/collaborator.dart';

class RecentTasks extends StatelessWidget {
  Collaborator collaborator;

  RecentTasks({
    @required this.collaborator,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text('Recent tasks' + this.collaborator.receivedPermission.toString()),
      ),
    );
  }
}
