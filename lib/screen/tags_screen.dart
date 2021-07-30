import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/tag.dart';
import '../provider/tag_provider.dart';
import '../provider/task_provider.dart';
import '../widget/new_tag.dart';
import '../widget/appBar/task_appBar.dart';

class TagsScreen extends StatefulWidget {
  static const routeName = '/tags-screen';

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  void _addNewTagForm(BuildContext buildContext, int tagsLength) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).accentColor,
      context: buildContext,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTag(
            tagsLength: tagsLength,
            editMode: false,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _editTagForm(BuildContext buildContext, int tagsLength, String initialValue) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).accentColor,
      context: buildContext,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTag(
            tagsLength: tagsLength,
            editMode: true,
            initialValue: initialValue,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = Provider.of<TagProvider>(context).tagList;
    return Scaffold(
      appBar: TaskAppBar(
        title: 'Tags',
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
          size: 50,
        ),
        onPressed: () {
          this._addNewTagForm(context, tags.length);
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 12),
        shrinkWrap: true,
        itemCount: tags.length,
        itemBuilder: (context, tagIndex) => Dismissible(
          key: ValueKey(tags[tagIndex]),
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
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              side: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Provider.of<TaskProvider>(context, listen: false).clearTagFromTasks(tags[tagIndex].name);
                              Provider.of<TagProvider>(context, listen: false).deleteTagPermanently(tags[tagIndex].name);
                              Navigator.of(context).pop(true);
                            },
                            child: Text(
                              'Yes',
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
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            if (direction == DismissDirection.startToEnd) {
              this._editTagForm(context, tags.length, tags[tagIndex].name);
            }
          },
          child: Card(
            child: ListTile(
              title: Text(
                tags[tagIndex].name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
