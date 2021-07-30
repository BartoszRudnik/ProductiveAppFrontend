import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../model/collaborator.dart';
import '../model/collaboratorTask.dart';
import '../provider/delegate_provider.dart';
import '../widget/appBar/active_tasks_appBar.dart';
import '../widget/ask_for_activity_permission.dart';
import '../widget/collaborator_active_tasks.dart';

class ActiveTasks extends StatefulWidget {
  final Collaborator collaborator;

  ActiveTasks({
    @required this.collaborator,
  });

  @override
  _ActiveTasksState createState() => _ActiveTasksState();
}

class _ActiveTasksState extends State<ActiveTasks> {
  final _pagingController = PagingController<int, CollaboratorTask>(firstPageKey: 0);
  int allTasksNumber = 0;
  int todayNumberOfTasks = 0;
  int tommorowNumberOfTasks = 0;

  @override
  void initState() {
    this._fetchAllTasksNumber();

    this._pagingController.addPageRequestListener((pageKey) {
      this._fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  void dispose() {
    this._pagingController.dispose();
    super.dispose();
  }

  void getNumberOfTodayTasks() {
    int count = 0;

    this._pagingController.itemList.forEach((task) {
      if (task.endDate != null && task.endDate.year == DateTime.now().year && task.endDate.month == DateTime.now().month && task.endDate.day == DateTime.now().day) {
        count++;
      }
    });

    setState(() {
      this.todayNumberOfTasks = count;
    });
  }

  void getNumberOfTommorowTasks() {
    int count = 0;

    this._pagingController.itemList.forEach((task) {
      if (task.endDate != null && task.endDate.year == DateTime.now().year && task.endDate.month == DateTime.now().month && task.endDate.day == (DateTime.now().day + 1)) {
        count++;
      }
    });

    setState(() {
      this.tommorowNumberOfTasks = count;
    });
  }

  Future<void> _fetchAllTasksNumber() async {
    try {
      await Provider.of<DelegateProvider>(context, listen: false).getNumberOfCollaboratorActiveTasks(this.widget.collaborator.email).then((value) {
        setState(() {
          allTasksNumber = value;
        });
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _fetchPage(int page) async {
    try {
      List<CollaboratorTask> newPage = [];

      await Provider.of<DelegateProvider>(context, listen: false).getCollaboratorActiveTasks(this.widget.collaborator.email, page, 50).then((value) {
        newPage = value;
      });

      newPage = newPage.reversed.toList();

      int loadedTasksLength = 0;

      if (this._pagingController.itemList != null) {
        loadedTasksLength = this._pagingController.itemList.length;
      }

      if (newPage.length + loadedTasksLength == this.allTasksNumber) {
        this._pagingController.appendLastPage(newPage);
      } else {
        final nextPage = page + 1;
        this._pagingController.appendPage(newPage, nextPage);
      }

      this.getNumberOfTodayTasks();
      this.getNumberOfTommorowTasks();
    } catch (error) {
      this._pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActiveTasksAppBar(
        message: 'Active tasks',
      ),
      body: this.widget.collaborator.receivedPermission
          ? CollaboratorActiveTasks(
              pagingController: this._pagingController,
              tommorowNumberOfTasks: tommorowNumberOfTasks,
              todayNumberOfTasks: todayNumberOfTasks,
            )
          : AskForActivityPermission(
              collaborator: this.widget.collaborator,
            ),
    );
  }
}
