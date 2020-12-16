import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import './components/image_upload_component.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  List<File> _images = [];
  // File _image; // Used only if you need a single picture

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if(gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,);
    }
    // Otherwise open camera to get new photo
    else{
      pickedFile = await picker.getImage(
        source: ImageSource.camera,);
    }

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
        //_image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  deleteImage(File img){
    setState(() {
      _images.remove(img);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: (){
        //
        //   },
        // ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Sample User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            InkWell(
                child: ListTile(
                  leading: Icon(Icons.analytics_rounded),
                  title: Text('List View'),
                ),
                onTap: (){
                  Navigator.pushReplacementNamed(context, "/");
                }
            ),
            InkWell(
                child: ListTile(
                  leading: Icon(Icons.analytics_rounded),
                  title: Text('Map View'),
                ),
                onTap: (){
                  Navigator.pushReplacementNamed(context, "/mapview");
                }
            ),
            InkWell(
                child: ListTile(
                  leading: Icon(Icons.analytics_rounded),
                  title: Text('Upload Pic and get Recommendation'),
                ),
                onTap: (){
                  Navigator.pushReplacementNamed(context, "/upload");
                }
            ),

          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {getImage(true);},
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text("Gallery"),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {getImage(false);},
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text("Camera"),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              child: (_images.length==0)? Center(
                child: Text(
                  "Select Image to upload"
                ),
              ) :SingleChildScrollView(
                child: Column(
                  children: [
                    for(var img in _images)
                      UploadIndividualImage(imageFile: img,delete: deleteImage,)
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

