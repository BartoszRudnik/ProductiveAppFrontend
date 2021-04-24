import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/task_page/utils/date_time_pickers.dart';

class TaskDate extends StatefulWidget {
  DateTime startValue;
  DateTime endValue;
  TimeOfDay startTime;
  TimeOfDay endTime;
  Function setDate;

  TaskDate({
    @required this.startValue,
    @required this.endValue,
    @required this.startTime,
    @required this.endTime,
    @required this.setDate,
  });

  @override
  _TaskDateState createState() => _TaskDateState();
}

class _TaskDateState extends State<TaskDate> {
  DateTime _startInitialValue;
  DateTime _endInitialValue;
  TimeOfDay _startInitialTime;
  TimeOfDay _endInitialTime;

  DateFormat formatter = DateFormat("yyyy-MM-dd");

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.calendar_today_outlined,
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  content: Container(
                    height: 230,
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: double.infinity, height: 70),
                          child: ElevatedButton(
                              onPressed: () async {
                                DateTime initDate = this.widget.startValue;
                                if (this.widget.startValue == null) {
                                  initDate = DateTime.now();
                                }
                                final DateTime pick = await DateTimePickers.pickDate(initDate, context);
                                final TimeOfDay pickTime = await DateTimePickers.pickTime(context);
                                setState(() {
                                  this._startInitialValue = pick;
                                  this._startInitialTime = pickTime;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(237, 237, 240, 1),
                                onPrimary: Color.fromRGBO(119, 119, 120, 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (this._startInitialValue.toString() == "null") ? "Start date" : "Start date: " + formatter.format(this._startInitialValue),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: double.infinity, height: 70),
                          child: ElevatedButton(
                              onPressed: () async {
                                DateTime initDate = this.widget.endValue;
                                if (this.widget.endValue == null) {
                                  initDate = DateTime.now();
                                }
                                final DateTime pick = await DateTimePickers.pickDate(initDate, context);
                                final TimeOfDay pickTime = await DateTimePickers.pickTime(context);
                                setState(() {
                                  this._endInitialValue = pick;
                                  this._endInitialTime = pickTime;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(237, 237, 240, 1),
                                onPrimary: Color.fromRGBO(119, 119, 120, 1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (this._endInitialValue.toString() == "null") ? "End date" : "End date: " + formatter.format(this._endInitialValue),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                this._startInitialValue = this.widget.startValue;
                                this._endInitialValue = this.widget.endValue;
                                this._startInitialTime = this.widget.startTime;
                                this._endInitialTime = this.widget.endTime;
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                setState(() {
                                  this.widget.startValue = this._startInitialValue;
                                  this.widget.endValue = this._endInitialValue;
                                  this.widget.startTime = this._startInitialTime;
                                  this.widget.endTime = this._endInitialTime;

                                  this.widget.setDate(
                                        this._startInitialValue,
                                        this._endInitialValue,
                                        this._startInitialTime,
                                        this._endInitialTime,
                                      );
                                });
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
