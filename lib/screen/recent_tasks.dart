import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/config/images.dart';
import 'package:productive_app/provider/locale_provider.dart';
import 'package:provider/provider.dart';

import '../model/collaborator.dart';
import '../model/collaboratorTask.dart';
import '../provider/delegate_provider.dart';
import '../widget/appBar/active_tasks_appBar.dart';
import '../widget/button/ask_for_activity_permission.dart';
import '../widget/chart/chart_shimmer.dart';
import '../widget/chart/collaborator_tasks_chart.dart';
import '../widget/list_shimmer.dart';
import '../widget/single_collaborator_task.dart';

class RecentTasks extends StatefulWidget {
  final Collaborator collaborator;

  RecentTasks({
    @required this.collaborator,
  });

  @override
  _RecentTasksState createState() => _RecentTasksState();
}

class _RecentTasksState extends State<RecentTasks> {
  final _pagingController = PagingController<int, CollaboratorTask>(firstPageKey: 0);
  int allTasksNumber = 0;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    this._fetchAllTasksNumber();

    this._pagingController.addPageRequestListener((pageKey) {
      this._fetchPage(pageKey);
    });
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

      setState(() {
        this.loaded = true;
      });
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

  int get _weekTasks {
    int totalTasks = 0;
    _groupedTransactionsValues.forEach((element) {
      totalTasks += element['amount'];
    });
    return totalTasks;
  }

  List<Map<String, Object>> get _groupedTransactionsValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      int dayTotalTasks = 0;

      final recentTasks = this._recentTasks;

      for (var i = 0; i < recentTasks.length; i++) {
        if (recentTasks[i].lastUpdated.day == weekDay.day &&
            recentTasks[i].lastUpdated.month == weekDay.month &&
            recentTasks[i].lastUpdated.year == weekDay.year) {
          dayTotalTasks += 1;
        }
      }

      return {
        'calendarDay': DateFormat.MMMd(Provider.of<LocaleProvider>(context, listen: false).locale.languageCode).format(weekDay),
        'day': DateFormat.E(Provider.of<LocaleProvider>(context, listen: false).locale.languageCode).format(weekDay),
        'amount': dayTotalTasks,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActiveTasksAppBar(message: AppLocalizations.of(context).recentlyFinishedTasks),
      body: this.widget.collaborator.receivedPermission
          ? Container(
              height: MediaQuery.of(context).size.height,
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => this._pagingController.refresh(),
                ),
                child: Column(
                  children: [
                    this.loaded
                        ? Container(
                            height: 205,
                            child: CollaboratorTasksChart(
                              tasks: this._groupedTransactionsValues,
                              weekTasks: this._weekTasks,
                            ),
                          )
                        : ChartShimmer(),
                    Expanded(
                      child: PagedListView.separated(
                        builderDelegate: PagedChildBuilderDelegate<CollaboratorTask>(
                          itemBuilder: (context, task, index) => SingleCollaboratorTask(task: task),
                          firstPageProgressIndicatorBuilder: (_) => ListShimmer(),
                          firstPageErrorIndicatorBuilder: (_) => Container(
                            child: Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Image.asset(
                                    Images.noInternet,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Text('No internet connection, try again later.')
                              ],
                            ),
                          ),
                          noItemsFoundIndicatorBuilder: (_) => Container(
                            child: Center(
                              child: Text(AppLocalizations.of(context).emptyList),
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
