import 'package:flutter/material.dart';
import './components/records.dart';
import './components/Filter.dart';
import './data_objects/records_object.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.recordsData}) : super(key: key);

  final String title;
  final Future<RecordsData> recordsData;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FilterObj filterValue ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterValue = null;
  }

  void updateFilter(FilterObj fil){
    setState(() {
      filterValue=fil;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.transparent,
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
                },
              splashColor: Colors.blue,

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
                    Filter(height: size.height*0.18,recordsData: this.widget.recordsData,updateParentFilter: updateFilter,),
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
                    SizedBox(height: 20,),
                    Container(
                      height: size.height * .5,
                        child: SingleChildScrollView(
                          child:FutureBuilder<RecordsData>(
                            future: this.widget.recordsData,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                RecordsData records = snapshot.data;
                                return Container(
                                  child: SingleChildScrollView(
                                      child: Records(width: size.width * 0.9,recordsData: records,filter: filterValue,)
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              // By default, show a loading spinner.
                              return CircularProgressIndicator();
                            },
                          ),

                        )
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