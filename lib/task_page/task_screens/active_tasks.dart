import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/models/collaborator.dart';
import 'package:productive_app/task_page/models/collaboratorTask.dart';
import 'package:productive_app/task_page/providers/delegate_provider.dart';
import 'package:productive_app/task_page/utils/collaborator_show_modal.dart';
import 'package:provider/provider.dart';

class ActiveTasks extends StatefulWidget {
  Collaborator collaborator;

  ActiveTasks({
    @required this.collaborator,
  });

  @override
  _ActiveTasksState createState() => _ActiveTasksState();
}

class _ActiveTasksState extends State<ActiveTasks> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Active tasks',
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
                child: Text(
                  'tu cos jeszcze bedzie',
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
