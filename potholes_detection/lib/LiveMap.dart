import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import './components/CustomDrawer.dart';
import './components/AnnomalyLocationsServices.dart';

class LiveMap extends StatefulWidget {
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  Completer<GoogleMapController> mapController = Completer();
  final Set<Marker> _markers = <Marker>{};
  Stream<DocumentSnapshot>? stream;

  Anomalies anomalies = Anomalies();

  static const LatLng _center =
      const LatLng(22.496695803485945, 88.37183921981813);

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("road_anomalies")
        .doc("anomalies")
        .snapshots();
    stream?.listen((event) {
      anomalies.merge(Anomalies.fromJson(event.data() as Map<String, dynamic>));
      setMarkers();
      print("Listening to stream firestore");
      print(anomalies.toJson());
    });
  }

  @override
  void dispose() {
    super.dispose();
    // stream
  }

  //filler function for test
  void filler() {
    anomalies.uneven_surface.addAll([
      LatLng(22.498129, 88.370160),
    ]);

    anomalies.dry_potholes.addAll([
      LatLng(22.497609030317413, 88.37145139076004),
      LatLng(22.496958991006803, 88.37260458159948),
      LatLng(22.49803710331737, 88.37277275526357),
    ]);

    anomalies.wet_potholes.addAll([
      LatLng(22.498132230484014, 88.37122143902755),
      LatLng(22.49860469437682, 88.3717843059849),
    ]);

    anomalies.speed_breaker.addAll([
      LatLng(22.496404130715142, 88.37194268794019),
    ]);
  }

  Future<void> updateAnomaly() async {
    // filler();
    print("Updating firestore");
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("road_anomalies")
          .doc("anomalies");
      DocumentSnapshot snapshot = await transaction.get(ref);
      anomalies
          .merge(Anomalies.fromJson(snapshot.data() as Map<String, dynamic>));
      transaction.update(snapshot.reference, anomalies.toJson());
      print("Completed updating firestore");
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController.complete(controller);
    });
  }

  void setMarkers() {
    Map<LatLng, String> marker_positions = Map();
    for (LatLng l in anomalies.wet_potholes) {
      if (marker_positions.containsKey(l)) {
        marker_positions[l] = "${marker_positions[l]}, Wet pothole";
      } else {
        marker_positions[l] = "Wet pothole";
      }
    }

    for (LatLng l in anomalies.uneven_surface) {
      if (marker_positions.containsKey(l)) {
        marker_positions[l] = "${marker_positions[l]}, Uneven surface";
      } else {
        marker_positions[l] = "Uneven surface";
      }
    }

    for (LatLng l in anomalies.speed_breaker) {
      if (marker_positions.containsKey(l)) {
        marker_positions[l] = "${marker_positions[l]}, Speed breaker";
      } else {
        marker_positions[l] = "Speed breaker";
      }
    }

    for (LatLng l in anomalies.manholes) {
      if (marker_positions.containsKey(l)) {
        marker_positions[l] = "${marker_positions[l]}, Manholes";
      } else {
        marker_positions[l] = "Manholes";
      }
    }

    for (LatLng l in anomalies.dry_potholes) {
      if (marker_positions.containsKey(l)) {
        marker_positions[l] = "${marker_positions[l]}, Dry pothole";
      } else {
        marker_positions[l] = "Dry pothole";
      }
    }
    this.setState(() {
      _markers.addAll([
        for (LatLng l in marker_positions.keys)
          Marker(
            markerId: MarkerId(l.latitude.toString() + l.longitude.toString()),
            position: l,
            infoWindow: InfoWindow(
              title: "",
            ),
            onTap: () => {
              setState(() {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(50),
                      child: Column(
                        children: [
                          Text( "Lat:${l.latitude}  Lon:${l.longitude}", style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("Anomalies: " + marker_positions[l]!,style: TextStyle(fontSize: 20),)
                        ],
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  backgroundColor: Colors.white,
                );
              })
            },
          ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(anomalies.wet_potholes);
    return Scaffold(
      backgroundColor: Colors.white70,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Google map"),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          markers: _markers.toSet(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateAnomaly,
        child: Icon(Icons.update),
      ),
    );
  }
}
