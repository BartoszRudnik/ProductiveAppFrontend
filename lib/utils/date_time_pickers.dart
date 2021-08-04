import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productive_app/config/color_themes.dart';

class DateTimePickers {
  static Future<DateTime> pickDate(DateTime initDate, BuildContext context) async {
    final DateTime pick = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      builder: (context, child) => Theme.of(context).brightness == Brightness.light
          ? Theme(
              data: ColorThemes.lightDateTimePicker(context),
              child: child,
            )
          : Theme(
              data: ColorThemes.darkDateTimePicker(context),
              child: child,
            ),
    );
    return pick;
  }

  static Future<TimeOfDay> pickTime(BuildContext context) async {
    final TimeOfDay selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) => Theme.of(context).brightness == Brightness.light
          ? Theme(
              data: ColorThemes.lightDateTimePicker(context),
              child: child,
            )
          : Theme(
              data: ColorThemes.darkDateTimePicker(context),
              child: child,
            ),
    );

    return selectedTime;
  }
}
