import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PDFAppBar extends StatelessWidget with PreferredSizeWidget {
  final controller;
  final fileName;
  final indexPage;
  final pages;

  PDFAppBar({
    @required this.controller,
    @required this.fileName,
    @required this.indexPage,
    @required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
      backgroundColor: Theme.of(context).accentColor,
      backwardsCompatibility: false,
      title: Text(
        fileName,
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
      actions: [
        Center(
          child: Text(
            (this.indexPage + 1).toString() + ' of ' + this.pages.toString(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.navigate_before_outlined),
          onPressed: () {
            if (this.indexPage - 1 >= 0) {
              this.controller.setPage(this.indexPage - 1);
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.navigate_next_outlined),
          onPressed: () {
            if (this.indexPage + 1 < this.pages) {
              this.controller.setPage(this.indexPage + 1);
            }
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
