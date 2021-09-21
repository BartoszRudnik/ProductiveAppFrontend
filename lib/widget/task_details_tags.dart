import 'package:flutter/material.dart';
import 'package:productive_app/widget/task_tags_edit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskDetailsTags extends StatelessWidget {
  final tags;
  final Function editTags;

  TaskDetailsTags({
    @required this.tags,
    @required this.editTags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minLeadingWidth: 16,
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          leading: Icon(Icons.tag),
          title: Align(
            alignment: Alignment(-1.1, 0),
            child: Text(
              AppLocalizations.of(context).tags,
              style: TextStyle(fontSize: 21),
            ),
          ),
        ),
        TextButton(
          onPressed: () => this.editTags(context),
          child: TaskTagsEdit(
            tags: tags,
          ),
        ),
      ],
    );
  }
}
