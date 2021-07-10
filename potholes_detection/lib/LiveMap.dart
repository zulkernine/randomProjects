import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import './components/CustomDrawer.dart';

class LiveMap extends StatefulWidget {
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  Completer<GoogleMapController> mapController = Completer();
  final Set<Marker> _markers = <Marker>{};
  Stream<DocumentSnapshot>? stream;

  Anomalies anomalies = Anomalies();

  static const LatLng _center = const LatLng(22.496695803485945, 88.37183921981813);

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
    this.setState(() {
      _markers.addAll([
        for (LatLng l in anomalies.wet_potholes)
          Marker(
            markerId: MarkerId(l.latitude.toString() + l.longitude.toString()),
            position: l,
            infoWindow: InfoWindow(
              title: "Wet Pot holes",
            ),
            onTap: () => {},
          ),

        for (LatLng l in anomalies.uneven_surface)
          Marker(
            markerId: MarkerId(l.latitude.toString() + l.longitude.toString()),
            position: l,
            infoWindow: InfoWindow(
              title: "Uneven Surface",
            ),
            onTap: () => {},
          ),

        for (LatLng l in anomalies.dry_potholes)
          Marker(
            markerId: MarkerId(l.latitude.toString() + l.longitude.toString()),
            position: l,
            infoWindow: InfoWindow(
              title: "Dry Pot holes",
            ),
            onTap: () => {},
          ),

        for (LatLng l in anomalies.speed_breaker)
          Marker(
            markerId: MarkerId(l.latitude.toString() + l.longitude.toString()),
            position: l,
            infoWindow: InfoWindow(
              title: "Speed breaker",
            ),
            onTap: () => {},
          ),

        for (LatLng l in anomalies.manholes)
          Marker(
            markerId: MarkerId(l.latitude.toString() + l.longitude.toString()),
            position: l,
            infoWindow: InfoWindow(
              title: "Manholes",
            ),
            onTap: () => {},
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

class Anomalies {
  Set<LatLng> wet_potholes = <LatLng>{};
  Set<LatLng> dry_potholes = <LatLng>{};
  Set<LatLng> manholes = <LatLng>{};
  Set<LatLng> speed_breaker = <LatLng>{};
  Set<LatLng> uneven_surface = <LatLng>{};

  Anomalies();

  Anomalies.fromJson(Map<String, dynamic> data) {

    wet_potholes.addAll([
      for (List l in jsonDecode(data["wet_potholes"])) LatLng(l.first, l.last)
    ]);
    dry_potholes.addAll([
      for (List l in jsonDecode(data["dry_potholes"])) LatLng(l.first, l.last)
    ]);
    manholes.addAll(
        [for (List l in jsonDecode(data["manholes"])) LatLng(l.first, l.last)]);
    speed_breaker.addAll([
      for (List l in jsonDecode(data["speed_breaker"])) LatLng(l.first, l.last)
    ]);
    uneven_surface.addAll([
      for (List l in jsonDecode(data["uneven_surface"])) LatLng(l.first, l.last)
    ]);
  }

  Map<String, dynamic> toJson() {
    return {
      "wet_potholes": jsonEncode(wet_potholes.toList()),
      "dry_potholes": jsonEncode(dry_potholes.toList()),
      "manholes": jsonEncode(manholes.toList()),
      "speed_breaker": jsonEncode(speed_breaker.toList()),
      "uneven_surface": jsonEncode(uneven_surface.toList()),
    };
  }

  void merge(Anomalies anm) {
    this.wet_potholes = this.wet_potholes.union(anm.wet_potholes);
    this.dry_potholes = this.dry_potholes.union(anm.dry_potholes);
    this.manholes = this.manholes.union(anm.manholes);
    this.speed_breaker = this.speed_breaker.union(anm.speed_breaker);
    this.uneven_surface = this.uneven_surface.union(anm.uneven_surface);
  }
}
