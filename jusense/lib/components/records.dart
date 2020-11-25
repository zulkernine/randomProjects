import 'package:flutter/material.dart';


class Records extends StatefulWidget {
  final double width;

  Records({this.width});

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
          Record(width: this.widget.width,),
          Record(width: this.widget.width,),
          Record(width: this.widget.width,),
          Record(width: this.widget.width,),
        ],
      ),
    );
  }
}



class Record extends StatefulWidget {
  final double width;

  Record({this.width});

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
          border: Border.all(color: Color.fromRGBO(223, 225, 229, 1.0),width: 2)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Ballygunge, Kolkata - WBPCB",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),

          SizedBox(height: 10,),
          Column(

            children: [
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
                        "PM10",
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "min:118"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "avg:157"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "max:200"
                        )
                    ),

                  ],
                ),
              ),
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
                        "PM10",
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "min:118"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "avg:157"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "max:200"
                        )
                    ),

                  ],
                ),
              ),
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
                        "PM10",
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "min:118"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "avg:157"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "max:200"
                        )
                    ),

                  ],
                ),
              ),
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
                        "PM10",
                        style: TextStyle(
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "min:118"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "avg:157"
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top:8.0,left:5,bottom:8),
                        child: Text(
                            "max:200"
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



