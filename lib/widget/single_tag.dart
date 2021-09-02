import 'package:flutter/material.dart';
import 'package:productive_app/provider/synchronize_provider.dart';
import 'package:provider/provider.dart';
import '../provider/tag_provider.dart';
import '../provider/task_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleTag extends StatelessWidget {
  final tag;
  final length;
  final Function editTagForm;

  SingleTag({
    @required this.tag,
    @required this.editTagForm,
    @required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(tag),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            Icon(
              Icons.edit,
              color: Theme.of(context).accentColor,
              size: 50,
            ),
            Text(
              AppLocalizations.of(context).edit,
              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context).delete,
              style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Icon(
              Icons.delete_outline,
              color: Theme.of(context).accentColor,
              size: 40,
            ),
          ],
        ),
      ),
      // ignore: missing_return
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  AppLocalizations.of(context).delete,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context).areYouSureDeleteTag),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<TaskProvider>(context, listen: false).clearTagFromTasks(tag.name);
                          Provider.of<SynchronizeProvider>(context, listen: false).addTagToDelete(tag.name);
                          Provider.of<TagProvider>(context, listen: false).deleteTagPermanently(tag.name);
                          Navigator.of(context).pop(true);
                        },
                        child: Text(AppLocalizations.of(context).yes),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(AppLocalizations.of(context).no),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        if (direction == DismissDirection.startToEnd) {
          this.editTagForm(context, length, this.tag.name, this.tag.id);
        }
      },
      child: Card(
        child: ListTile(
          title: Text(
            tag.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
