import 'package:flutter/material.dart';


class Filter extends StatefulWidget {

  final double height;

  Filter({this.height});

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  var filter = FilterObj();

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
            child:DropdownButton<String>(
              value: filter.stateName,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 76,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                // height: 0,
                // color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  filter.stateName = newValue;
                });
              },
              items: <String>['Oneasfaf', 'All', 'Freefgjkla', 'Fourafsjlflsa']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child:DropdownButton<String>(
              value: filter.cityName,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 76,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                // height: 0,
                // color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  filter.cityName = newValue;
                });
              },
              items: <String>['Ojkfaslafne', 'Twkjflasfaso', 'Frefjkasdadsklfae',"All", 'FoJKHEWUHLAKSur']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child:DropdownButton<String>(
              value: filter.pollutant,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 76,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                // height: 0,
                // color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  filter.pollutant = newValue;
                });
              },
              items: <String>['One', 'Two', 'Free', 'Four','All']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
  String stateName= "All";
  String cityName= "All";
  String pollutant= "All";
}

