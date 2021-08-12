import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:productive_app/widget/appBar/pdf_appBar.dart';

class PDFViewer extends StatefulWidget {
  static const routeName = "/pdfViewer";

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  PDFViewController _controller;

  int pages = 0;
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final file = arguments['file'] as File;
    final fileName = arguments['fileName'] as String;

    return Scaffold(
      appBar: PDFAppBar(
        controller: this._controller,
        fileName: fileName,
        indexPage: this.indexPage,
        pages: this.pages,
      ),
      body: PDFView(
        nightMode: Theme.of(context).brightness == Brightness.dark,
        onRender: (pages) {
          setState(() {
            this.pages = pages;
          });
        },
        onViewCreated: (controller) {
          setState(() {
            this._controller = controller;
          });
        },
        onPageChanged: (indexPage, _) {
          setState(() {
            this.indexPage = indexPage;
          });
        },
        filePath: file.path,
        autoSpacing: false,
        pageSnap: false,
        pageFling: false,
      ),
    );
  }
}
