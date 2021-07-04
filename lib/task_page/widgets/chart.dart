import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/models/collaboratorTask.dart';
import 'package:productive_app/task_page/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<CollaboratorTask> recentTasks;

  Chart({
    this.recentTasks,
  });

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

      for (var i = 0; i < recentTasks.length; i++) {
        if (recentTasks[i].lastUpdated.day == weekDay.day && recentTasks[i].lastUpdated.month == weekDay.month && recentTasks[i].lastUpdated.year == weekDay.year) {
          dayTotalTasks += 1;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': dayTotalTasks,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _groupedTransactionsValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  tasksFinished: data['amount'],
                  tasksFinishedPercent: _weekTasks == 0.0 ? 0.0 : (data['amount'] as int) / _weekTasks,
                  weekDayLabel: data['day'],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
