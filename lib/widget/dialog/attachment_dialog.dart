import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttachmentDialog extends StatefulWidget {
  final List<File> files;

  AttachmentDialog({
    @required this.files,
  });

  @override
  _AttachmentDialogState createState() => _AttachmentDialogState();
}

class _AttachmentDialogState extends State<AttachmentDialog> {
  double actualBytes = 0.0;
  double maxBytes = 1000000.0;

  @override
  void initState() {
    super.initState();

    this.actualBytes = 0.0;

    if (this.widget.files.length > 0) {
      this.widget.files.forEach(
        (file) {
          this.actualBytes += file.lengthSync();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        title: Column(
          children: [
            Text(
              AppLocalizations.of(context).addNewFiles,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 15),
            LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColorLight,
              color: Theme.of(context).primaryColor,
              value: (actualBytes / maxBytes),
            ),
            SizedBox(height: 10),
            Text(
              AppLocalizations.of(context).used + ((actualBytes / maxBytes).toStringAsFixed(2)) + " MB / 1 MB",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                allowCompression: true,
                allowMultiple: true,
                allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
                type: FileType.custom,
              );

              result.files.forEach(
                (file) {
                  final newFile = File(file.path);

                  if (this.actualBytes + newFile.lengthSync() <= this.maxBytes) {
                    this.actualBytes += newFile.lengthSync();
                    this.widget.files.add(newFile);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).primaryColorLight,
                        duration: Duration(seconds: 2),
                        content: Text(
                          AppLocalizations.of(context).attachmentsSpace,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    );
                  }
                },
              );

              setState(() {});
            },
            child: Text(
              AppLocalizations.of(context).addNewFile,
              textAlign: TextAlign.start,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(this.widget.files);
            },
            child: Text(
              AppLocalizations.of(context).save,
              textAlign: TextAlign.end,
            ),
          ),
        ],
        content: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: this.widget.files.length,
              itemBuilder: (ctx, index) {
                return Container(
                  height: 75,
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Center(
                              child: Text(
                                basename(this.widget.files[index].path),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel_outlined),
                            onPressed: () {
                              setState(() {
                                this.actualBytes -= this.widget.files[index].lengthSync();
                                this.widget.files.remove(this.widget.files[index]);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
