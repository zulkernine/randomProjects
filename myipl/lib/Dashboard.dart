import 'package:flutter/material.dart';
import 'package:myipl/CustomDrawer.dart';
import 'package:myipl/data_classes/MatchOutcome.dart';
import 'package:myipl/data_classes/Scoreboard.dart';


class Dashboard extends StatefulWidget {
  final Scoreboard allScore;
  Dashboard({this.allScore});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Scoreboard temp = new Scoreboard();
  @override
  void initState() {
    super.initState();
    MatchOutcome m = new MatchOutcome();
    m.participants = "KKR vs MI";
    m.myScore = "24";
    m.myTeam = "af,asf,saf, af , af, ,re gsg sdfgfsds,, fsd";
    m.winner = "KKR";
    m.date = "2008-04-24T00:00:00.000Z";

    temp.totalScore = "133";
    temp.previousScore.add(m);
    temp.previousScore.add(m);
    temp.previousScore.add(m);
    temp.previousScore.add(m);
    temp.previousScore.add(m);
    temp.previousScore.add(m);
    temp.previousScore.add(m);
    temp.previousScore.add(m);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
        ),
        drawer: CustomDrawer(),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  child: Text("Current Total Score: ${temp.totalScore}"),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.tealAccent,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        for(MatchOutcome match in temp.previousScore)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: Colors.blue,
                                border: Border.all(color: Color.fromRGBO(223, 225, 229, 1.0),width: 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Participants: ${match.participants}"),
                                Text("Winner: ${match.winner}"),
                                Text("My Score: ${match.myScore}"),
                                Text("My Team: ${match.myTeam}"),
                                Text("Date: ${match.date}"),
                              ],
                            ),
                          )
                      ]
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
