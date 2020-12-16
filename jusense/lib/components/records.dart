import 'dart:ffi';

import 'package:flutter/material.dart';
import '../data_objects/records_object.dart';
import '../components/Filter.dart';


class Records extends StatefulWidget {
  final double width;
  final RecordsData recordsData;
  final FilterObj filter;

  Records({this.width , this.recordsData,this.filter});

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          if(this.widget.filter == null || this.widget.filter.stateName.value == nullptr) for(var strec in this.widget.recordsData.stateRecords)
            for(var cityRec in strec.cityRecords )
              for(StationRecord stat in cityRec.stationRecords)
                Record(width: this.widget.width*0.95,stationRecord: stat,)
          else if(this.widget.filter.cityName.value == nullptr)
            for(var cityRec in this.widget.filter.stateName.value.cityRecords )
              for(StationRecord stat in cityRec.stationRecords)
                Record(width: this.widget.width*0.95,stationRecord: stat,)
          else  for(StationRecord stat in this.widget.filter.cityName.value.stationRecords)
              Record(width: this.widget.width*0.95,stationRecord: stat,)
        ],
      ),
    );
  }
}



class Record extends StatefulWidget {
  final double width;
  final StationRecord stationRecord;
  final bool enableBorder;

  Record({this.width = double.infinity , this.stationRecord,this.enableBorder=true});

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 23,
      width: this.widget.width,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top:10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Colors.blue,
          border: this.widget.enableBorder ? Border.all(color: Color.fromRGBO(223, 225, 229, 1.0),width: 2): Border.all(color: Colors.transparent,width: 0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            this.widget.stationRecord.stationName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),

          SizedBox(height: 10,),
          Column(
            children: [
              for(Pollutant data in this.widget.stationRecord.pollutants)
                Container(
                margin:EdgeInsets.only(top:10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Color.fromRGBO(223, 225, 229, 1.0),width: 1)
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                      child: Text(
                        data.id,
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "min:${data.min}"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "avg:${data.avg}"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "max:${data.max}"
                        )
                    ),

                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20,),
          Text(
            "last updated: 20:00 25th Nov,2020",
          ),
        ],
      ),
    );
  }
}



