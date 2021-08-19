import 'package:flutter/material.dart';
import 'package:productive_app/widget/appBar/search_appBar.dart';
import 'package:provider/provider.dart';
import '../model/tag.dart';
import '../provider/tag_provider.dart';
import '../widget/appBar/task_appBar.dart';
import '../widget/new_tag.dart';
import '../widget/single_tag.dart';

class TagsScreen extends StatefulWidget {
  static const routeName = '/tags-screen';

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  void _addNewTagForm(BuildContext buildContext, int tagsLength) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).primaryColorLight,
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
      backgroundColor: Theme.of(context).primaryColorLight,
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
    List<Tag> tags = Provider.of<TagProvider>(context).tags;

    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop();
        Provider.of<TagProvider>(context, listen: false).clearSearchingText();
      },
      child: Scaffold(
        appBar: SearchAppBar(
          title: 'Tags',
          searchingName: 'tag',
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 50,
          ),
          onPressed: () {
            this._addNewTagForm(context, tags.length);
          },
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 12),
          shrinkWrap: true,
          itemCount: tags.length,
          itemBuilder: (context, index) => SingleTag(
            tag: tags[index],
            editTagForm: this._editTagForm,
            length: tags.length,
          ),
        ),
      ),
    );
  }
}
