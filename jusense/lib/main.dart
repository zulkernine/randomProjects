import 'package:flutter/material.dart';
import 'home.dart';
import 'mapview.dart';
import 'uploadimage.dart';
import './data_objects/records_object.dart';
import './data_objects/httpservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<RecordsData> recordsData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recordsData = fetchRecords();
  }

  @override
  Widget build(BuildContext context) {
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


