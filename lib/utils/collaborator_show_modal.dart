import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:productive_app/model/collaboratorTask.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CollaboratorModal {
  static void onTaskPressed(CollaboratorTask task, BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30.0),
          topRight: const Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: task.description != null && task.description.length > 0
              ? 350
              : 325,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 2.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(AppLocalizations.of(context).taskName),
                        Flexible(
                          child: Text(
                            ": " + task.title,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    if (task.description != null && task.description.length > 1)
                      Row(
                        children: [
                          Text(AppLocalizations.of(context).description),
                          Flexible(
                            child: Text(
                              ": " + task.description,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 2.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined),
                        SizedBox(
                          width: 16,
                        ),
                        Text(AppLocalizations.of(context).startAndEndDate),
                      ],
                    ),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context).startDate),
                        SizedBox(width: 32),
                        Container(
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Center(
                                  child: task.startDate.toString() == "null" ||
                                          task.startDate.year == 1970
                                      ? Icon(Icons.calendar_today_outlined)
                                      : Text(
                                          DateFormat("yyyy-MM-dd")
                                              .format(task.startDate),
                                        ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                child: Center(
                                  child: task.startDate.toString() == "null" ||
                                          task.startDate.year == 1970
                                      ? Icon(Icons.access_time_outlined)
                                      : Text(
                                          DateFormat("Hm")
                                              .format(task.startDate),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(AppLocalizations.of(context).endDate),
                        SizedBox(width: 32),
                        Container(
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Center(
                                  child: task.endDate.toString() == "null" ||
                                          task.endDate.year == 1970
                                      ? Icon(Icons.calendar_today_outlined)
                                      : Text(
                                          DateFormat("yyyy-MM-dd")
                                              .format(task.endDate),
                                        ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                child: Center(
                                  child: task.endDate.toString() == "null" ||
                                          task.endDate.year == 1970
                                      ? Icon(Icons.access_time_outlined)
                                      : Text(
                                          DateFormat("Hm").format(task.endDate),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, left: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(
                    color: Theme.of(context).primaryColorDark,
                    width: 2.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.update_outlined),
                    SizedBox(
                      width: 8,
                    ),
                    Flexible(
                      child: AutoSizeText(
                        AppLocalizations.of(context).lastUpdated,
                        minFontSize: 12,
                        maxFontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Center(
                              child: task.lastUpdated.toString() == "null" ||
                                      task.lastUpdated.year == 1970
                                  ? Icon(Icons.calendar_today_outlined)
                                  : Text(
                                      DateFormat("yyyy-MM-dd")
                                          .format(task.lastUpdated),
                                    ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: Center(
                              child: task.lastUpdated.toString() == "null" ||
                                      task.lastUpdated.year == 1970
                                  ? Icon(Icons.access_time_outlined)
                                  : Text(
                                      DateFormat("Hm").format(task.lastUpdated),
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
          ),
        );
      },
    );
  }
}
