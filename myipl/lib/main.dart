import 'package:flutter/material.dart';
import 'package:myipl/AuthenticateUser.dart';
import 'package:myipl/CreateTeam.dart';
import 'package:myipl/CustomDrawer.dart';
import 'package:myipl/Dashboard.dart';
import 'package:myipl/Home.dart';
import 'package:myipl/LiveMatch.dart';
import 'package:myipl/Play.dart';
import 'package:myipl/data_classes/Scoreboard.dart';
import 'package:myipl/data_classes/SinglePlayer.dart';
import 'package:myipl/data_classes/UserData.dart';
import 'package:myipl/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Scoreboard allScore;
  UserData userData;
  Map<String,SinglePlayer> myCurrentTeam = new Map<String,SinglePlayer>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fetchUserData({@required UserData data}){
    setState(() {
      userData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthenticateUser(updateUserData: fetchUserData),
        // '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/login': (context) => LogIn(setUserData: fetchUserData,),
        '/home':(context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/dashboard':(context) => Dashboard(allScore: allScore,),
        '/play':(context) => Play(userData: userData,),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
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