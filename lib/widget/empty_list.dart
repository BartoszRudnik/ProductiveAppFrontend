import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String message;

  EmptyList({
    @required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(this.message),
        ),
      ),
    );
  }
}
