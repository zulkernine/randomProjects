import 'package:flutter/material.dart';
import 'package:myipl/data_classes/SinglePlayer.dart';
import 'package:myipl/data_classes/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class LiveMatch extends StatefulWidget {
  UserData userData;

  LiveMatch({this.userData});

  @override
  _LiveMatchState createState() => _LiveMatchState();
}

class _LiveMatchState extends State<LiveMatch> {

  double totalScore=0;
  Map<String,dynamic> ballLogs = {
    "over":"11.4",
    "batsman": "W Jaffer",
    "bowler": "JDP Oram",
    "extras": {
      "wides": 1
    },
    "non_striker": "B Chipli",
    "runs": {
      "batsman": 0,
      "extras": 1,
      "total": 1
    },
    "wicket": {
      "kind": "bowled",
      "player_out": "B Chipli",
      "fielders": [
        "SK Raina",
        "MS Dhoni"
      ],
    }
  };


  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(widget.userData.userID).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        print(snapshot.data.data());
        
        UserData updatedData =UserData.fromJson(snapshot.data.data());
        print(updatedData.liveData.currentTeam);
        if(updatedData.liveData==null){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        // updatedData.liveData.currentMatch

        return Container(
            child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width ,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your Score",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Expanded(child: Container()),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "${updatedData.scoreboard.totalScore}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width ,
                    child: Text(
                      updatedData.liveData.currentMatch["info"]["teams"].join("\nvs\n"),
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Venue: " + updatedData.liveData.currentMatch["info"]["venue"]+", "+updatedData.liveData.currentMatch["info"]["city"],
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    child: Text(
                      updatedData.liveData.currentMatch["innings"][0].keys.first +" : " + updatedData.liveData.currentMatch["innings"][0].values.first["team"],
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    child: Text(
                      "Batsman: " + ballLogs["batsman"],
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    child: Text(
                      "Bowler: " + ballLogs["bowler"],
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    child: Text(
                      "Non Striker: " + ballLogs["non_striker"],
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ),

                  ballLogs.containsKey("extras") ? Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    child: Text(
                      "Extra: " + ballLogs["extras"].keys.toList().join(" ").toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ) : Container(),

                  Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    child: Text(
                      "Total Run: " + ballLogs["runs"]["total"].toString(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    child: Text(
                      "Over: " + ballLogs["over"],
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17
                      ),
                    ),
                  ),

                  ballLogs.containsKey("wicket") ? Container(
                    margin: EdgeInsets.fromLTRB(10,5,10,5),
                    padding: EdgeInsets.fromLTRB(15,5,15,5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.blue,
                      border: Border.all(color: Color.fromRGBO(223, 225, 229, 1.0),width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wicket!",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 17
                          ),
                        ),
                        Text(
                          "Player Out: " + ballLogs["wicket"]["player_out"],
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 17
                          ),
                        ),
                        Text(
                          "Type: " + ballLogs["wicket"]["kind"],
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 17
                          ),
                        ),
                        ballLogs["wicket"].containsKey("fielders") ?  Text(
                          "Accompanying Fielders: " + ballLogs["wicket"]["fielders"].join(","),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 17
                          ),
                        ):Container(),
                      ],
                    ),
                  ):Container(),
                ],
              ),
            )
        );
      },
    );




  }
}
