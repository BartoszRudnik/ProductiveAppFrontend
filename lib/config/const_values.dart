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

  static String priorities(String priority, BuildContext context) {
    if (priority.toLowerCase() == "CRITICAL".toLowerCase()) {
      return AppLocalizations.of(context).critical;
    } else if (priority.toLowerCase() == "HIGHER".toLowerCase()) {
      return AppLocalizations.of(context).higher;
    } else if (priority.toLowerCase() == "HIGH".toLowerCase()) {
      return AppLocalizations.of(context).high;
    } else if (priority.toLowerCase() == "NORMAL".toLowerCase()) {
      return AppLocalizations.of(context).normal;
    } else {
      return AppLocalizations.of(context).low;
    }
  }

  static String listName(String listName, BuildContext context) {
    if (listName.toLowerCase() == "inbox") {
      return AppLocalizations.of(context).inbox;
    } else if (listName.toLowerCase() == "scheduled") {
      return AppLocalizations.of(context).scheduled;
    } else if (listName.toLowerCase() == "anytime") {
      return AppLocalizations.of(context).anytime;
    } else if (listName.toLowerCase() == "completed") {
      return AppLocalizations.of(context).completed;
    } else if (listName.toLowerCase() == "trash") {
      return AppLocalizations.of(context).trash;
    } else {
      return AppLocalizations.of(context).delegated;
    }
  }

  static String stateName(String listName, BuildContext context) {
    if (listName.toLowerCase() == "collect") {
      return AppLocalizations.of(context).collect;
    } else if (listName.toLowerCase() == "plan&do") {
      return AppLocalizations.of(context).planDo;
    } else {
      return AppLocalizations.of(context).completed;
    }
  }

  static String language(String langCode, BuildContext context) {
    if (langCode.toLowerCase() == "EN".toLowerCase()) {
      return AppLocalizations.of(context).english;
    } else {
      return AppLocalizations.of(context).polish;
    }
  }

  static String taskStatus(String status, BuildContext context) {
    if (status.toLowerCase() == "sent") {
      return AppLocalizations.of(context).taskSent;
    } else if (status.toLowerCase() == "waiting") {
      return AppLocalizations.of(context).waiting;
    } else if (status.toLowerCase() == "in progress") {
      return AppLocalizations.of(context).inProgress;
    } else if (status.toLowerCase() == "canceled") {
      return AppLocalizations.of(context).canceled;
    } else if (status.toLowerCase() == "done") {
      return AppLocalizations.of(context).done;
    } else {
      return AppLocalizations.of(context).deleted;
    }
  }

  static const fontSizes = [48.0, 36.0, 32.0, 26.0, 24.0, 20.0, 18.0, 16.0, 14.0, 12.0];
}
