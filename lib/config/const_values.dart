import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConstValues {
  static String sortingModes(int index, BuildContext context) {
    if (index == 0) {
      return AppLocalizations.of(context).endDateAsc;
    } else if (index == 1) {
      return AppLocalizations.of(context).endDateDesc;
    } else if (index == 2) {
      return AppLocalizations.of(context).startDateAsc;
    } else if (index == 3) {
      return AppLocalizations.of(context).startDateDesc;
    } else if (index == 4) {
      return AppLocalizations.of(context).priorityDesc;
    } else if (index == 5) {
      return AppLocalizations.of(context).priorityAsc;
    } else {
      return AppLocalizations.of(context).custom;
    }
  }

  static const fontSizes = [48.0, 36.0, 32.0, 26.0, 24.0, 20.0, 18.0, 16.0, 14.0, 12.0];
}
