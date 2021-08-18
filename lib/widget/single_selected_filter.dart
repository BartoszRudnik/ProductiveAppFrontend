import 'package:flutter/material.dart';

class SingleSelectedFilter extends StatelessWidget {
  final text;
  final Function onPressed;
  final icon;

  SingleSelectedFilter({
    @required this.text,
    @required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 4),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (this.icon != null) icon,
            IconButton(
              icon: Icon(Icons.cancel_outlined, color: Theme.of(context).primaryColor),
              onPressed: () {
                this.onPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
