import 'package:flutter/material.dart';

class LoginGreet extends StatelessWidget {
  final String greetText;

  LoginGreet({
    @required this.greetText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
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
            style: TextStyle(
              fontSize: 36,
              fontFamily: 'RobotoCondensed',
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
