import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/model/collaboratorTask.dart';
import 'package:productive_app/utils/collaborator_show_modal.dart';

class CollaboratorActiveTasks extends StatelessWidget {
  final PagingController pagingController;
  final int tommorowNumberOfTasks;
  final int todayNumberOfTasks;

  CollaboratorActiveTasks({
    @required this.pagingController,
    @required this.tommorowNumberOfTasks,
    @required this.todayNumberOfTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => this.pagingController.refresh(),
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(237, 237, 240, 1),
                border: Border.all(
                  color: Color.fromRGBO(221, 221, 226, 1),
                  width: 2.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Today\'s tasks: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 48,
                        ),
                        Text(
                          this.todayNumberOfTasks.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Tommorow\'s tasks: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          this.tommorowNumberOfTasks.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
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
                pagingController: this.pagingController,
                padding: const EdgeInsets.all(12),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
