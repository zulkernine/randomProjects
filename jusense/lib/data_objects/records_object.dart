import 'package:flutter/cupertino.dart';

class StateRecord{
  String stateName;
  List<CityRecord> cityRecords=[];
}

class CityRecord{
  String cityName;
  List<StationRecord> stationRecords=[];
}

class StationRecord{
  String stationName;
  String updateTime;
  List<Pollutant> pollutants=[];
}

class Pollutant{
  String id;
  String min;
  String max;
  String avg;
  Pollutant({@required this.id,@required this.max,@required this.avg,@required this.min});
}

class RecordsData{
  List<StateRecord> stateRecords=[];

  RecordsData({this.stateRecords});
  factory RecordsData.fromJson(Map<String, dynamic> json){
    List records = json['records'];

    Map recs = Map();

    for(final rec in records){
      if(recs.containsKey(rec["state"])){
        Map state = recs[rec["state"]];

        if(state.containsKey(rec["city"])){
          Map city = state[rec["city"]];

          if(city.containsKey(rec["station"])){
            StationRecord stationRecord = city[rec["station"]];
            stationRecord.pollutants.add(Pollutant(
                id: rec["pollutant_id"],
                max: rec["pollutant_max"],
                min: rec["pollutant_min"],
                avg: rec["pollutant_avg"]
            ));
          }else{
            city[rec["station"]] = StationRecord();
            StationRecord stationRecord = city[rec["station"]];
            stationRecord.stationName = rec["station"];
            stationRecord.updateTime = rec["last_update"];

            stationRecord.pollutants.add(Pollutant(
                id: rec["pollutant_id"],
                max: rec["pollutant_max"],
                min: rec["pollutant_min"],
                avg: rec["pollutant_avg"]
            ));
          }

        }else{
          state[rec["city"]] = Map();
        }
      }else{
        recs[rec["state"]] = Map();
      }
    }


    RecordsData newRec = RecordsData(stateRecords: []);

    for(MapEntry ent in recs.entries){
      StateRecord stateRecord = StateRecord();
      stateRecord.stateName = ent.key;
      for(MapEntry entCity in ent.value.entries){
        CityRecord cityRecord = CityRecord();
        cityRecord.cityName = entCity.key;

        for(MapEntry entStation in entCity.value.entries){
          cityRecord.stationRecords.add(entStation.value);
        }
        stateRecord.cityRecords.add(cityRecord);
      }
      newRec.stateRecords.add(stateRecord);
    }

    return newRec;
  }
}
