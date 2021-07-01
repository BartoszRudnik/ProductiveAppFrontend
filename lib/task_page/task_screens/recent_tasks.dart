import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/models/collaboratorTask.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
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

  void _onTaskPressed(CollaboratorTask task) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: task.description != null && task.description.length > 0 ? 350 : 325,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  border: Border.all(
                    color: Color.fromRGBO(221, 221, 226, 1),
                    width: 2.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Title:      '),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4 + 16,
                        ),
                        Text(
                          task.title,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (task.description != null && task.description.length > 1)
                      Row(
                        children: [
                          Text('Description: '),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            task.description,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  border: Border.all(
                    color: Color.fromRGBO(221, 221, 226, 1),
                    width: 2.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined),
                        SizedBox(
                          width: 16,
                        ),
                        Text('Start and due date:'),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Start date:'),
                        SizedBox(width: 32),
                        Container(
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(237, 237, 240, 1),
                                  onPrimary: Color.fromRGBO(119, 119, 120, 1),
                                ),
                                child: Center(
                                  child: task.startDate.toString() == "null" || task.startDate.year == 1970
                                      ? Icon(Icons.calendar_today_outlined)
                                      : Text(
                                          DateFormat("yyyy-MM-dd").format(task.startDate),
                                        ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(237, 237, 240, 1),
                                  onPrimary: Color.fromRGBO(119, 119, 120, 1),
                                ),
                                child: Center(
                                  child: task.startDate.toString() == "null" || task.startDate.year == 1970
                                      ? Icon(Icons.access_time_outlined)
                                      : Text(
                                          DateFormat("Hm").format(task.startDate),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Due date:  '),
                        SizedBox(width: 32),
                        Container(
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(237, 237, 240, 1),
                                  onPrimary: Color.fromRGBO(119, 119, 120, 1),
                                ),
                                child: Center(
                                  child: task.endDate.toString() == "null" || task.endDate.year == 1970
                                      ? Icon(Icons.calendar_today_outlined)
                                      : Text(
                                          DateFormat("yyyy-MM-dd").format(task.endDate),
                                        ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(237, 237, 240, 1),
                                  onPrimary: Color.fromRGBO(119, 119, 120, 1),
                                ),
                                child: Center(
                                  child: task.endDate.toString() == "null" || task.endDate.year == 1970
                                      ? Icon(Icons.access_time_outlined)
                                      : Text(
                                          DateFormat("Hm").format(task.endDate),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  border: Border.all(
                    color: Color.fromRGBO(221, 221, 226, 1),
                    width: 2.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.done_all_outlined),
                    SizedBox(
                      width: 16,
                    ),
                    Text('Last updated:'),
                    SizedBox(
                      width: 16,
                    ),
                    Container(
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(237, 237, 240, 1),
                              onPrimary: Color.fromRGBO(119, 119, 120, 1),
                            ),
                            child: Center(
                              child: task.lastUpdated.toString() == "null" || task.lastUpdated.year == 1970
                                  ? Icon(Icons.calendar_today_outlined)
                                  : Text(
                                      DateFormat("yyyy-MM-dd").format(task.lastUpdated),
                                    ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(237, 237, 240, 1),
                              onPrimary: Color.fromRGBO(119, 119, 120, 1),
                            ),
                            child: Center(
                              child: task.lastUpdated.toString() == "null" || task.lastUpdated.year == 1970
                                  ? Icon(Icons.access_time_outlined)
                                  : Text(
                                      DateFormat("Hm").format(task.lastUpdated),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
      body: Container(
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
                        return this._onTaskPressed(task);
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
                                  Icon(Icons.done_all_outlined),
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
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
