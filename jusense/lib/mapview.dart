import 'dart:convert';
import './data_objects/records_object.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import './components/records.dart';


Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/json/stationposition.json');
}

class MapView extends StatefulWidget {
  final Future<RecordsData> recordsData;

  MapView({this.recordsData});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
  final stationPosition = {};
  final List<Marker> _markers = <Marker>[];
  StationRecord currentStation=null;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    loadAsset().then((value) => setState((){
      stationPosition.addAll(jsonDecode(value));
      print(stationPosition);
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                  double.parse(stationPosition["Jadavpur, Kolkata - WBPCB"]["latitude"]),
                  double.parse(stationPosition["Jadavpur, Kolkata - WBPCB"]["longitude"])
              ),
            zoom: 11.0
        ),
      ));

      this.widget.recordsData.then((value) => setState((){
        _markers.addAll(
            [
              for(var strec in value.stateRecords)
                for(var cityRec in strec.cityRecords )
                  for(StationRecord stat in cityRec.stationRecords)
                    if(stationPosition[stat.stationName] != null) Marker(
                      markerId: MarkerId(stat.stationName),
                      position: LatLng(
                          double.parse(stationPosition[stat.stationName]["latitude"]),
                          double.parse(stationPosition[stat.stationName]["longitude"])
                      ),
                      infoWindow: InfoWindow(
                        title: stat.stationName,
                      ),
                      onTap: ()=>{
                        setState(() {
                          currentStation = stat;
                          showModalBottomSheet(context: context, builder: (BuildContext context){
                            return Record(stationRecord: currentStation,width: MediaQuery.of(context).size.width * 0.90,enableBorder: false,);

                          },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                            ),
                            backgroundColor: Colors.white,
                          );
                        })
                      },
                    )
            ]
        );
      }) );
      print(_markers.length);
      })
    );

    currentStation = null;

  }



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if( stationPosition.isNotEmpty)
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    double.parse(stationPosition["Jadavpur, Kolkata - WBPCB"]["latitude"]),
                    double.parse(stationPosition["Jadavpur, Kolkata - WBPCB"]["longitude"])
                ),
                zoom: 11.0
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    print("build:");
    print(_markers.length);
    return Scaffold(
      backgroundColor: Colors.transparent,
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
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 1.0,
        ),
        markers: _markers.toSet(),
      ),
    );
  }
}

