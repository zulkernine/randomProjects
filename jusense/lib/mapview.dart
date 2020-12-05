import 'dart:convert';
import './data_objects/records_object.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;


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
  StationRecord currentStation;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    loadAsset().then((value) => setState((){
      stationPosition.addAll(jsonDecode(value));
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
                    Marker(
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
                        })
                      },

                    )
            ]
        );
      }) );
      })
    );

    currentStation = null;

  }



  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if(stationPosition != {})
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

