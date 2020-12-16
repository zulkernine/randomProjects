import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class UploadIndividualImage extends StatefulWidget {
  final File imageFile;
  final Function delete;
  UploadIndividualImage({@required this.imageFile, @required this.delete});

  @override
  _UploadIndividualImageState createState() => _UploadIndividualImageState();
}

class _UploadIndividualImageState extends State<UploadIndividualImage> {
  bool _error = false;
  bool _uploadComplete = false;
  bool _uploadingNow = false;
  double _uploadSize = 0;

  Future<void> handleUploadTask(File largeFile) async {
    // File largeFile = File(filePath);

    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref('uploads/${largeFile.path.split('/').last}')
        .putFile(largeFile);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      setState(() {
        _uploadSize =
            ((snapshot.totalBytes / (1024 * 1024)) * 100).round().toDouble() /
                100;
      });
    }, onError: (e) {
      setState(() {
        _error = true;
        _uploadingNow = false;
      });
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      setState(() {
        _uploadingNow = true;
      });
      await task;
      print('Upload complete.');
      setState(() {
        _uploadComplete = true;
        _error = false;
      });
    } on firebase_core.FirebaseException catch (e) {
      setState(() {
        _error = true;
        _uploadingNow = false;
      });
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      } else {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(color: Color.fromRGBO(223, 225, 229, 1.0), width: 1)),
      child: Column(
        children: [
          Image.file(this.widget.imageFile),
          Row(
            children: [
              if (_uploadComplete)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Uploaded Successfully!",
                  ),
                )
              else if (_uploadingNow)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Colors.tealAccent,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Size: $_uploadSize MB"),
                      )
                    ],
                  ),
                )
              else
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: () async {
                        await handleUploadTask(this.widget.imageFile);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.cloud_upload),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text("Upload"),
                          )
                        ],
                      ),
                    )),
              if (_error)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Failed to Upload :(\nTry again!",
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    this.widget.delete(this.widget.imageFile);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.delete),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("Delete"),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
