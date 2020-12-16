import 'package:flutter/material.dart';
import 'home.dart';
import 'mapview.dart';
import 'uploadimage.dart';
import './data_objects/records_object.dart';
import './data_objects/httpservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<RecordsData> recordsData;
  bool _initialized = false;
  UserCredential userCredential;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      userCredential = await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeFlutterFire();
    recordsData = fetchRecords();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if(_error) {
      return MaterialApp(
        home: SafeArea(
          child: Center(
            child: Container(
              child:Text("Something went wrong!\nPlease restart the app"),
            ),
          ),
        ),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return CircularProgressIndicator();
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Home Page',recordsData: recordsData,),
        '/mapview': (context) => MapView(recordsData: recordsData,),
        '/upload':(context) => UploadImage(),
      },
    );
  }
}


