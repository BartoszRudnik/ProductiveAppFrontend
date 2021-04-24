import 'package:flutter/material.dart';

class IsDoneButton extends StatefulWidget {
  bool isDone;
  Function changeIsDoneStatus;
  Future<void> changeTaskStatusOnServer;

  IsDoneButton({
    @required this.isDone,
    this.changeIsDoneStatus,
    this.changeTaskStatusOnServer,
  });

  @override
  _IsDoneButtonState createState() => _IsDoneButtonState();
}

class _IsDoneButtonState extends State<IsDoneButton> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: this.widget.isDone ? Colors.grey : Theme.of(context).accentColor,
      focusElevation: 0,
      child: this.widget.isDone
          ? Icon(
              Icons.done,
              color: Colors.white,
              size: 14,
            )
          : null,
      onPressed: () {
        setState(() {
          this.widget.isDone = !this.widget.isDone;
          this.widget.changeIsDoneStatus();
        });
      },
      constraints: BoxConstraints(minWidth: 20, minHeight: 18),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: CircleBorder(
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      padding: EdgeInsets.zero,
    );
  }
}
