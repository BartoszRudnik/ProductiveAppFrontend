import 'package:flutter/material.dart';
import 'package:productive_app/provider/attachment_provider.dart';
import 'package:productive_app/provider/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsDataUsage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final receivedTasks = Provider.of<TaskProvider>(context).receivedTasksUuid();
    final usedMegaBytes = Provider.of<AttachmentProvider>(context).getAttachmentsSize(receivedTasks) / 1000000;
    final double maxMEgaBytes = 50.0;

    return Container(
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        border: Border.all(
          color: Theme.of(context).primaryColorDark,
          width: 2.5,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            minLeadingWidth: 16,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Align(
              alignment: Alignment(-1.1, 0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context).dataUsage,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).accentColor,
              color: Theme.of(context).primaryColor,
              value: (usedMegaBytes / maxMEgaBytes),
            ),
          ),
          SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).used + usedMegaBytes.toStringAsFixed(2) + " MB / 50 MB",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
