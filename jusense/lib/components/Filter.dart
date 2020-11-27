import 'dart:ffi';

import 'package:flutter/material.dart';
import '../data_objects/records_object.dart';

class Filter extends StatefulWidget {

  final double height;
  final Future<RecordsData> recordsData;
  final Function updateParentFilter;
  Filter({this.height,this.recordsData,this.updateParentFilter});

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  FilterObj filter ;
  RecordsData _recordsData;
  List<FilterData> stateList = <FilterData>[
    FilterData(name: "All States",value: nullptr),
  ], cityList = <FilterData>[
    FilterData(name: "All City",value: nullptr),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filter = FilterObj(stateName: stateList[0]);
    filter.cityName = cityList[0];


    this.widget.recordsData.then((value) {
      print("record data");
      setState(() {
        _recordsData = value;
        stateList.addAll(
            <FilterData>[
              if(_recordsData!=null) for(StateRecord strec in _recordsData.stateRecords)
                FilterData(name: strec.stateName,value: strec)
            ]
        ) ;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.widget.height,
      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
      margin:EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child:DropdownButton<FilterData>(
              value: filter.stateName,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 76,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                // height: 0,
                // color: Colors.deepPurpleAccent,
              ),
              onChanged: ( newValue) {
                setState(() {
                  filter.stateName = newValue;
                  cityList.removeWhere((element) => element.value!=nullptr);
                  cityList.addAll(
                      <FilterData>[
                        if(filter.stateName.value != nullptr) for(CityRecord strec in filter.stateName.value.cityRecords)
                          FilterData(name: strec.cityName,value: strec)
                      ]
                  );
                  filter.cityName = cityList[0];
                  this.widget.updateParentFilter(filter);
                });
              },
              items: stateList.map<DropdownMenuItem<FilterData>>((FilterData listItem) {
                return DropdownMenuItem<FilterData>(
                  value: listItem,
                  child: Text(listItem.name),
                );
              }).toList(),
            ),
          ),
          Spacer(),
          if(filter.stateName.value != nullptr) Container(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child:DropdownButton<FilterData>(
              value: filter.cityName,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 76,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                // height: 0,
                // color: Colors.deepPurpleAccent,
              ),
              onChanged: (FilterData newValue) {
                setState(() {
                  filter.cityName = newValue;
                });
                this.widget.updateParentFilter(filter);
              },
              items: cityList.map<DropdownMenuItem<FilterData>>((FilterData listItem) {
                return DropdownMenuItem<FilterData>(
                  value: listItem,
                  child: Text(listItem.name),
                );
              }).toList(),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class FilterObj{
  FilterData stateName;
  FilterData cityName;
  FilterObj({this.stateName,this.cityName});
}

class FilterData{
  String name;
  dynamic value;// Holds StateRecord,CityRecord
  FilterData({this.name,this.value});
}

