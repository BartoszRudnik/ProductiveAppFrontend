import 'package:flutter/material.dart';

class TaskTags extends StatelessWidget {
  final tags;

  TaskTags({
    @required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return (this.tags != null && this.tags.length > 0)
        ? Container(
            alignment: Alignment.centerLeft,
            height: 20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: this.tags.length,
              itemBuilder: (ctx, secondIndex) => Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 4),
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 0.2,
                  ),
                ),
                child: Center(
                  child: Text(
                    this.tags[secondIndex].name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        : Container(
            height: 15,
          );
  }
}
