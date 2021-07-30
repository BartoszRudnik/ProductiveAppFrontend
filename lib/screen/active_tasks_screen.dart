import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/collaborator.dart';
import '../model/collaboratorTask.dart';
import '../provider/delegate_provider.dart';
import '../utils/collaborator_show_modal.dart';
import '../widget/appBar/active_tasks_appBar.dart';
import '../widget/ask_for_activity_permission.dart';
import '../widget/chart/collaborator_tasks_chart.dart';

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
            if (task.endDate != null) {
              return _dayDifference(DateTime.now(), task.endDate) <= 7;
            }
          }).toList()
        : [];
  }

  int get _weekTasks {
    int totalTasks = 0;
    _groupedTransactionsValues.forEach((element) {
      totalTasks += element['amount'];
    });
    return totalTasks;
  }

  List<Map<String, Object>> get _groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().add(
        Duration(days: index),
      );
      int dayTotalTasks = 0;

      final recentTasks = this._recentTasks;

      for (var i = 0; i < recentTasks.length; i++) {
        if (recentTasks[i].endDate.day == weekDay.day && recentTasks[i].endDate.month == weekDay.month && recentTasks[i].endDate.year == weekDay.year) {
          dayTotalTasks += 1;
        }
      }

      return {
        'calendarDay': DateFormat.MMMd().format(weekDay),
        'day': DateFormat.E().format(weekDay),
        'amount': dayTotalTasks,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActiveTasksAppBar(
        message: 'Active tasks',
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
                      height: 205,
                      child: CollaboratorTasksChart(
                        tasks: this._groupedTransactionsValues,
                        weekTasks: this._weekTasks,
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
          : AskForActivityPermission(
              collaborator: this.widget.collaborator,
            ),
    );
  }
}
