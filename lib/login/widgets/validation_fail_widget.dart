import 'package:flutter/material.dart';

class ValidationFailWidget extends StatelessWidget {
  final String message;

  ValidationFailWidget({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning_amber_outlined,
            size: 30,
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              this.message,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
