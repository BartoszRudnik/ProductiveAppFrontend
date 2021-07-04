import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/shared/dialogs.dart';
import 'package:productive_app/task_page/models/collaboratorTask.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:productive_app/task_page/utils/collaborator_show_modal.dart';
import 'package:productive_app/task_page/widgets/chart.dart';
import 'package:provider/provider.dart';

import '../models/collaborator.dart';

class RecentTasks extends StatefulWidget {
  Collaborator collaborator;

  RecentTasks({
    @required this.collaborator,
  });

  @override
  _RecentTasksState createState() => _RecentTasksState();
}

class _RecentTasksState extends State<RecentTasks> {
  final _pagingController = PagingController<int, CollaboratorTask>(firstPageKey: 0);
  int allTasksNumber = 0;

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

  Future<void> _fetchAllTasksNumber() async {
    try {
      await Provider.of<DelegateProvider>(context, listen: false).getNumberOfCollaboratorFinishedTasks(this.widget.collaborator.email).then((value) {
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

      await Provider.of<DelegateProvider>(context, listen: false).getCollaboratorRecentlyFinishedTasks(this.widget.collaborator.email, page, 50).then((value) {
        newPage = value;
      });

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

      setState(() {});
    } catch (error) {
      this._pagingController.error = error;
    }
  }

  int _dayDifference(DateTime today, DateTime transactionDate) {
    return today.difference(transactionDate).inDays;
  }

  List<CollaboratorTask> get _recentTasks {
    return this._pagingController.itemList != null
        ? this._pagingController.itemList.where((task) {
            return _dayDifference(DateTime.now(), task.lastUpdated) <= 7;
          }).toList()
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recently finished tasks',
          style: TextStyle(color: Colors.black),
        ),
        toolbarHeight: 50,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: Theme.of(context).iconTheme,
        brightness: Brightness.dark,
      ),
      body: this.widget.collaborator.receivedPermission
          ? Container(
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => this._pagingController.refresh(),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 190,
                      child: Chart(
                        recentTasks: this._recentTasks,
                      ),
                    ),
                    Expanded(
                      child: PagedListView.separated(
                        builderDelegate: PagedChildBuilderDelegate<CollaboratorTask>(
                          itemBuilder: (context, task, index) => GestureDetector(
                            onTap: () {
                              return CollaboratorModal.onTaskPressed(task, context);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.update_outlined),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat('yMMMMd').format(task.lastUpdated) + ' ' + DateFormat('Hm').format(task.lastUpdated),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        pagingController: this._pagingController,
                        padding: const EdgeInsets.all(12),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You don\'t have permission to see collaborator acitivity!'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      if (this.widget.collaborator.alreadyAsked) {
                        return Dialogs.showWarningDialog(context, 'You already asked for permission!');
                      } else {
                        Provider.of<DelegateProvider>(context, listen: false).askForPermission(this.widget.collaborator.email);
                        this.widget.collaborator.alreadyAsked = true;
                      }
                    },
                    child: Text(
                      'Ask for permission',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
