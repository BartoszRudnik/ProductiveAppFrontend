import 'package:flutter/material.dart';
import 'package:productive_app/model/task.dart';
import 'package:productive_app/provider/attachment_provider.dart';
import 'package:productive_app/screen/task_details_screen.dart';
import 'package:productive_app/screen/task_details_screen_shimmer.dart';
import 'package:provider/provider.dart';

class TaskDetailsLoadingScreen extends StatefulWidget {
  static String routeName = "/taskDetailsLoadingScreen";

  @override
  _TaskDetailsLoadingScreenState createState() => _TaskDetailsLoadingScreenState();
}

class _TaskDetailsLoadingScreenState extends State<TaskDetailsLoadingScreen> {
  Task _task;
  Future _future;

  Future<void> _loadAttachments(String taskUuid, String parentTaskUuid) async {
    await Provider.of<AttachmentProvider>(context, listen: false).getTaskAttachments(taskUuid, parentTaskUuid);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        this._task = ModalRoute.of(context).settings.arguments as Task;
      });

      this._future = this._loadAttachments(this._task.uuid, this._task.parentUuid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._future,
      builder: (ctx, loadResult) => loadResult.connectionState == ConnectionState.waiting
          ? TaskDetailsScreenShimmer()
          : TaskDetailScreen(
              task: this._task,
            ),
    );
  }
}
