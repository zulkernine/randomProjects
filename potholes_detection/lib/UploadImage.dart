import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potholes_detection/components/video_upload_and_play.dart';
import 'dart:io';

import './components/image_upload_component.dart';
import './components/CustomDrawer.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  List<File> _images = [];
  File? _videoes =null;
  String url = "";


  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if(gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,maxHeight: 512,
          maxWidth: 512,
          imageQuality: 50);
    }
    // Otherwise open camera to get new photo
    else{
      pickedFile = await picker.getImage(
        source: ImageSource.camera,);
    }

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  Future getVideo(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if(gallery) {
      pickedFile = await picker.getVideo(
        source: ImageSource.gallery,);
    }
    // Otherwise open camera to get new photo
    else{
      print(DateTime.now());
      pickedFile = await picker.getVideo(
        source: ImageSource.camera,);
    }

    setState(() {
      if (pickedFile != null) {
        _videoes = File(pickedFile.path);
      } else {
        print('No Video selected.');
      }
    });
  }

  deleteImage(File img, {bool isVideo = false}){
    setState(() {
      if(isVideo){
        _videoes= null;
      }else{
        _images.remove(img);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Upload Image"),
        ),
        drawer: CustomDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'KEY',
                    ),
                    onChanged: (String value){
                      this.setState(() {
                        url = "https://$value.ngrok.io/predict" ;
                      });
                    },
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {getVideo(false);},
                      child: Row(
                        children: [
                          Icon(Icons.videocam),
                          Padding(
                            padding: const EdgeInsets.only(left:5.0),
                            child: Text("Video"),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {getImage(false);},
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          Padding(
                            padding: const EdgeInsets.only(left:5.0),
                            child: Text("Image"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                (_images.length==0)? Center(
                  child: Text(
                      "Select Image to upload"
                  ),
                ) :Column(
                  children: [
                    for(var img in _images)
                      UploadIndividualImage(imageFile: img,delete: deleteImage,url: url,)
                  ],
                ),

                _videoes == null ? Container() :  UploadIndividualVideo(imageFile: _videoes!, delete: deleteImage,url: url,)

              ],
            ),
          ),
        )
    );
  }
}

