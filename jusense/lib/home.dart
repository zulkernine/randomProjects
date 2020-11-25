import 'package:flutter/material.dart';
import 'package:jusense/components/records.dart';
import './components/Filter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color:Color.fromRGBO(81, 134, 236, 1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)
              )
            ),
            height: size.height * 0.405,
          ),
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      child: Text(
                        "Sense Air",
                        style:TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 40
                        )
                      ),
                    ),
                    Filter(height: size.height*0.25,),
                    RaisedButton(
                      onPressed: null,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.green,

                        ),
                        child: Text(
                          "Apply",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                          ),

                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      height: size.height * .55,
                        child: SingleChildScrollView(child: Records(width: size.width * 0.9,))
                    ),

                  ],
                ),
              )
          )
        ],
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}