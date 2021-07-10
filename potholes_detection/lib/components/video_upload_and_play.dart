import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class UploadIndividualVideo extends StatefulWidget {
  final File imageFile;
  final Function delete;
  final String url;
  UploadIndividualVideo({required this.imageFile, required this.delete,this.url = "https://19495e184dba.ngrok.io/predict"});

  @override
  _UploadIndividualVideoState createState() => _UploadIndividualVideoState();
}

class _UploadIndividualVideoState extends State<UploadIndividualVideo> {
  bool _error = false;
  bool _uploadComplete = false;
  bool _uploadingNow = false;
  double _uploadSize = 0;
  String downloadUrl = "";
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.imageFile);
    controller?.initialize();
  }

  Future<void> handleUploadTask(File largeFile) async {
    await _uploadToFirebase(largeFile);
    var response = await http.get(Uri.parse(this.widget.url),headers: {"file":downloadUrl,"type":"video"});
    if(response.statusCode == 200){
      //TODO code additional
      await _updateAnnomalyLocations();
    }
  }

  Future<void> _uploadToFirebase(File largeFile)async{
    String filename = 'uploads/${largeFile.path.split('/').last}';

    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref(filename)
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
      String url = await firebase_storage.FirebaseStorage.instance
          .ref(filename)
          .getDownloadURL();
      setState(() {
        _uploadComplete = true;
        downloadUrl = url;
        _error = false;
      });
    } on firebase_core.FirebaseException catch (e) {
      setState(() {
        _error = true;
      });
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      } else {
        print(e);
      }
    }finally{
      setState(() {
        _uploadingNow = false;
      });
    }
  }

  Future<void> _updateAnnomalyLocations()async{

  }

  Future<String> getFileSize(File file, int decimals) async {
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
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
          FittedBox(
            child: FutureBuilder(
              future: getFileSize(widget.imageFile, 2),
              builder: (ctx,snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occured',
                        style: TextStyle(fontSize: 18),
                      ),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    final data = snapshot.data as String;
                    return Row(
                      children: [
                        ElevatedButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlayVideo(
                              videoPlayerController: VideoPlayerController.file(widget.imageFile),
                              looping: true,
                              autoplay: true,
                            ),),
                          );
                        }
                            , child: Text("Play")),
                        Text("Captured Video: $data"),
                      ],
                    );
                  }
                }

                // Displaying LoadingSpinner to indicate waiting state
                return Center(
                  child: CircularProgressIndicator(),
                );

              },
            ),
          ),
          Row(
            children: [
              if (_uploadComplete)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
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
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () async {
                        if(this.widget.url.length < 26){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Insert key'),
                              content: const Text("Can't upload without key"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }else{
                          await handleUploadTask(this.widget.imageFile);
                        }
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
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    this.widget.delete(this.widget.imageFile,isVideo:true);
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
          if (_uploadComplete)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Download Url:",
                  ),
                  SelectableText(
                    downloadUrl,
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}

class PlayVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;

  const PlayVideo({required this.videoPlayerController,
    required this.looping, required this.autoplay,Key? key}) : super(key: key);

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio:5/8,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Play Video"),
        ),
        body: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}


