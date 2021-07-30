import 'package:flutter/material.dart';
import 'chart_bar.dart';

class CollaboratorTasksChart extends StatelessWidget {
  final List<Map<String, Object>> tasks;
  final int weekTasks;

  CollaboratorTasksChart({
    @required this.tasks,
    @required this.weekTasks,
  });

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
            children: this.tasks.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  tasksFinished: data['amount'],
                  tasksFinishedPercent: this.weekTasks == 0.0 ? 0.0 : (data['amount'] as int) / this.weekTasks,
                  weekDayLabel: data['day'],
                  calendarDay: data['calendarDay'],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
