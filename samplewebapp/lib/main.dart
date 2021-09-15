import 'package:flutter/material.dart';
import 'package:samplewebapp/Components/GalleryCard.dart';
import 'package:samplewebapp/Exhibition/CreateExhibitionWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            GalleryCard(
                name: "Kolkata AI Art",
                openFrom: DateTime(2021, 10, 12, 16, 0),
                endTime: DateTime(2021, 10, 19, 16, 0)),
            GalleryCard(
                name: "Rampur Gallery",
                openFrom: DateTime(2021, 10, 12, 16, 0),
                endTime: DateTime(2021, 10, 19, 16, 0)),
            GalleryCard(
                name: "National ARt exhibition",
                openFrom: DateTime(2021, 10, 12, 16, 0),
                endTime: DateTime(2021, 10, 19, 16, 0)),
            GalleryCard(
                name: "My Personal Art",
                openFrom: DateTime(2021, 10, 12, 16, 0),
                endTime: DateTime(2021, 10, 19, 16, 0)),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateExhibitionWidget()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
