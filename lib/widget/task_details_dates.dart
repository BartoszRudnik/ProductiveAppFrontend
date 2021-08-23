import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/color_themes.dart';
import '../model/task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDetailsDates extends StatefulWidget {
  final Function selectStartDate;
  final Function selectEndDate;
  final Function selectStartTime;
  final Function selectEndTime;
  final Task taskToEdit;
  TimeOfDay endTime;
  TimeOfDay startTime;

  TaskDetailsDates({
    @required this.selectEndDate,
    @required this.selectStartDate,
    @required this.selectStartTime,
    @required this.selectEndTime,
    @required this.taskToEdit,
    @required this.endTime,
    @required this.startTime,
  });

  @override
  _TaskDetailsDatesState createState() => _TaskDetailsDatesState();
}

class _TaskDetailsDatesState extends State<TaskDetailsDates> {
  final formatter = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minLeadingWidth: 16,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: Icon(Icons.calendar_today),
          title: Align(
            alignment: Alignment(-1.1, 0),
            child: Text(
              AppLocalizations.of(context).startAndEndDate,
              style: TextStyle(fontSize: 21),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).startDate,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => this.widget.selectStartDate(),
                      style: ColorThemes.taskDetailsButtonStyle(context),
                      child: Center(
                        child: this.widget.taskToEdit.startDate.toString() == "null" || this.widget.taskToEdit.startDate.year == 1970
                            ? Icon(Icons.calendar_today_outlined)
                            : Text(
                                formatter.format(this.widget.taskToEdit.startDate),
                              ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ColorThemes.taskDetailsButtonStyle(context),
                      onPressed: () => this.widget.selectStartTime(),
                      child: Center(
                        child: this.widget.startTime.toString() == "null"
                            ? Icon(Icons.access_time_outlined)
                            : Text(
                                this.widget.startTime.format(context),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: double.infinity, height: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).endDate,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ColorThemes.taskDetailsButtonStyle(context),
                      onPressed: () => this.widget.selectEndDate(),
                      child: Center(
                        child: this.widget.taskToEdit.endDate.toString() == "null" || this.widget.taskToEdit.endDate.year == 1970
                            ? Icon(Icons.calendar_today_outlined)
                            : Text(
                                formatter.format(this.widget.taskToEdit.endDate),
                              ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ColorThemes.taskDetailsButtonStyle(context),
                      onPressed: () => this.widget.selectEndTime(),
                      child: Center(
                        child: this.widget.endTime.toString() == "null"
                            ? Icon(Icons.access_time_outlined)
                            : Text(
                                this.widget.endTime.format(context),
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
    );
  }
}
