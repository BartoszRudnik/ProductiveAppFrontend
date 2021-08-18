import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/tag_provider.dart';
import '../provider/task_provider.dart';

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
              'Edit tag',
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
              'Delete tag',
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
                  'Delete',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to delete this tag?'),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<TaskProvider>(context, listen: false).clearTagFromTasks(tag.name);
                          Provider.of<TagProvider>(context, listen: false).deleteTagPermanently(tag.name);
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        if (direction == DismissDirection.startToEnd) {
          this.editTagForm(context, length, tag.name);
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
