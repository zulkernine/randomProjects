import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potholes_detection/components/CustomDrawer.dart';
import 'package:location/location.dart';
import 'dart:io';

import 'UploadImage.dart';
import 'LiveMap.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  UserCredential? userCredential;
  bool _error = false;
  String _error_message = "Something went wrong!\nPlease restart the app";

  //States value for UploadImage()
  List<File> _images = [];
  File? _videoes = null;
  String processedVideoUrl = "";
  String server_url = "";
  Map<int, LatLng> path_coordinate = {};

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      userCredential = await FirebaseAuth.instance.signInAnonymously();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
      print(e);
    }
  }

  void checkLocationPermission() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        setState(() {
          _error = true;
          _error_message =
              "We can't Work without location service :(, Enable it, give permission and reopen the app.";
        });
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() {
          _error = true;
          _error_message =
              "We can't Work without location service :(, Enable it, give permission and reopen the app.";
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeFlutterFire();
    checkLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
        home: SafeArea(
          child: Scaffold(
            body: Center(
              child: Container(
                child: Text(_error_message),
              ),
            ),
          ),
        ),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(
        home: SafeArea(
          child: Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      home: MyHomePage(
        title: "Home Page",
      ),
      routes: {
        '/upload': (context) => UploadImage(
              images: _images,
              url: server_url,
              videoes: _videoes,
              path: path_coordinate,
              processedVideoUrl: processedVideoUrl,
            ),
        '/map': (context) => LiveMap(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: CustomDrawer(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SelectableText(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
