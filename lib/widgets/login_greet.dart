import 'package:flutter/material.dart';

class LoginGreet extends StatelessWidget {
  final String greetText;

  LoginGreet({
    @required this.greetText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Container(
          height: 130,
          width: 130,
          child: Icon(
            Icons.person_outline_outlined,
            size: 130,
          ),
        ),
        Text(
          this.greetText,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
