import 'package:flutter/material.dart';
import 'package:productive_app/config/images.dart';

class EmptyList extends StatelessWidget {
  final String message;

  EmptyList({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Image.asset(Theme.of(context).brightness == Brightness.dark ? Images.emptyTaskListDark : Images.emptyTaskListLight),
          Center(
            child: Text(this.message),
          ),
        ],
      ),
    );
  }
}
