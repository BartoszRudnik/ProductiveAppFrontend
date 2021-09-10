import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskTagsEdit extends StatelessWidget {
  final tags;

  TaskTagsEdit({
    @required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return (this.tags != null && this.tags.length > 0)
        ? Container(
            alignment: Alignment.centerLeft,
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: this.tags.length,
              itemBuilder: (ctx, secondIndex) => Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    this.tags[secondIndex].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: 30,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(color: Color.fromRGBO(237, 237, 240, 1), borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Center(
              child: Text(
                AppLocalizations.of(context).addTags,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(119, 119, 120, 1),
                ),
              ),
            ),
          );
  }
}
