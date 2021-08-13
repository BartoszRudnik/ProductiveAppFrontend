import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageViewer extends StatelessWidget {
  static const routeName = "/imageViewer";

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final file = arguments['file'] as File;
    final fileName = arguments['fileName'] as String;

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Theme.of(context).accentColor,
        backwardsCompatibility: false,
        title: Text(
          fileName,
          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Image.asset(file.path),
      ),
    );
  }
}
