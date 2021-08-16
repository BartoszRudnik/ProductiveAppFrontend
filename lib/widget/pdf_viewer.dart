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
  Orientation _lastScreenOrientation;
  PDFViewController _controller;

  int pages = 0;
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._lastScreenOrientation = MediaQuery.of(context).orientation;
    });
  }

  void _repushViewer(File file, String fileName) {
    Navigator.of(context).pushReplacementNamed(
      PDFViewer.routeName,
      arguments: {
        'file': file,
        'fileName': fileName,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;

    final file = arguments['file'] as File;
    final fileName = arguments['fileName'] as String;

    if (_lastScreenOrientation != null && _lastScreenOrientation != MediaQuery.of(context).orientation) {
      Future.delayed(Duration(microseconds: 100), () => _repushViewer(file, fileName));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PDFAppBar(
        controller: this._controller,
        fileName: fileName,
        indexPage: this.indexPage,
        pages: this.pages,
        filePath: file.path,
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
