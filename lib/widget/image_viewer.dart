import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {
              Share.shareFiles([file.path]);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Image.file(file),
      ),
    );
  }
}
