import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String weekDayLabel;
  final int tasksFinished;
  final double tasksFinishedPercent;
  final String calendarDay;

  ChartBar({
    @required this.tasksFinished,
    @required this.tasksFinishedPercent,
    @required this.weekDayLabel,
    @required this.calendarDay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20,
          child: FittedBox(
            child: Text(
              tasksFinished.toString(),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 80,
          width: 10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: tasksFinishedPercent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FittedBox(
          child: Text(
            this.weekDayLabel,
          ),
        ),
        FittedBox(
          child: Text(
            this.calendarDay,
          ),
        ),
      ],
    );
  }
}
