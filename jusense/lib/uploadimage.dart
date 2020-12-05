import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
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
            Row(
              children: [
                IconButton(icon: Icon(Icons.image), onPressed: (){
                  getImage(true);
                }),
                IconButton(icon: Icon(Icons.camera), onPressed: (){
                  getImage(false);
                })
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              child: SingleChildScrollView(
                child: Column(

                  children: [
                    for(var img in _images)
                      Container(
                        child: Image.file(img),
                        padding: EdgeInsets.all(10),
                      )
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

