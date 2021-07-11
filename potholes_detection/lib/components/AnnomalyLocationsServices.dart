import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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


Future<void> updateAnomaly({required LatLng location,required Set<String> anomaliesName}) async {
  Anomalies anomalies = Anomalies();
  for(String string in anomaliesName){
    switch(string){
      case "wet pothole" : anomalies.wet_potholes.add(location);break;
      case "dry pothole" : anomalies.dry_potholes.add(location); break;
      case "manhole" : anomalies.manholes.add(location); break;
      case "speed breaker" : anomalies.speed_breaker.add(location); break;
      case "uneven surface": anomalies.uneven_surface.add(location); break;
    }
  }

  print("Updating firestore");
  print(anomalies.toJson());
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
