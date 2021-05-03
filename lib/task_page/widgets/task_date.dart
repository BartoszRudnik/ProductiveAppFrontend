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
  TimeOfDayFormat timeFormatter = TimeOfDayFormat.HH_colon_mm;

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
                    height: 280,
                    width: 200,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: Text('Start date'),
                        ),
                        SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: double.infinity, height: 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime initDate = this.widget.startValue;
                                  if (this.widget.startValue == null) {
                                    initDate = DateTime.now();
                                  }
                                  final DateTime pick = await DateTimePickers.pickDate(initDate, context);

                                  setState(() {
                                    this._startInitialValue = pick;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(237, 237, 240, 1),
                                  onPrimary: Color.fromRGBO(119, 119, 120, 1),
                                ),
                                child: Center(
                                  child: this._startInitialValue.toString() == "null"
                                      ? Icon(Icons.calendar_today_outlined)
                                      : Text(
                                          formatter.format(this._startInitialValue),
                                        ),
                                ),
                              ),
                              SizedBox(width: 30),
                              ElevatedButton(
                                onPressed: () async {
                                  final TimeOfDay pickTime = await DateTimePickers.pickTime(context);

                                  setState(() {
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
                                    this._startInitialTime.toString() == "null"
                                        ? Icon(Icons.access_time_outlined)
                                        : Text(
                                            this._startInitialTime.format(context),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text('End date'),
                        ),
                        SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(width: double.infinity, height: 70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  DateTime initDate = this.widget.endValue;
                                  if (this.widget.endValue == null) {
                                    initDate = DateTime.now();
                                  }
                                  final DateTime pick = await DateTimePickers.pickDate(initDate, context);

                                  setState(() {
                                    this._endInitialValue = pick;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(237, 237, 240, 1),
                                  onPrimary: Color.fromRGBO(119, 119, 120, 1),
                                ),
                                child: Center(
                                  child: this._endInitialValue.toString() == "null"
                                      ? Icon(Icons.calendar_today_outlined)
                                      : Text(
                                          formatter.format(this._endInitialValue),
                                        ),
                                ),
                              ),
                              SizedBox(width: 30),
                              ElevatedButton(
                                onPressed: () async {
                                  final TimeOfDay pickTime = await DateTimePickers.pickTime(context);

                                  setState(() {
                                    this._endInitialTime = pickTime;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(237, 237, 240, 1),
                                  onPrimary: Color.fromRGBO(119, 119, 120, 1),
                                ),
                                child: Center(
                                  child: this._endInitialTime.toString() == "null"
                                      ? Icon(Icons.access_time_outlined)
                                      : Text(
                                          this._endInitialTime.format(context),
                                        ),
                                ),
                              ),
                            ],
                          ),
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
                                if ((this._startInitialTime != null && this._startInitialValue == null) || (this._endInitialTime != null && this._endInitialValue == null)) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Center(
                                        child: Text(
                                          'Cannot select only time',
                                          style: Theme.of(context).textTheme.headline2,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('...'),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context).primaryColor,
                                                  side: BorderSide(color: Theme.of(context).primaryColor),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                                child: Text(
                                                  'OK',
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
                                }

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
