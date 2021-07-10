import 'package:flutter/material.dart';
import 'package:myipl/data_classes/SinglePlayer.dart';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';

class CreateTeam extends StatefulWidget {
  Function updateMatchTeam;
  CreateTeam({@required this.updateMatchTeam});

  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  var allDummyMatch = <Map<String, dynamic>>[];
  Map<String, SinglePlayer> myCurrentTeam = new Map<String, SinglePlayer>();
  Map<String, dynamic> selectedDummyMatch;
  Map<String, SinglePlayer> availablePlayers = new Map<String, SinglePlayer>();
  double currentUserCredit = 100;

  bool isProcessing = false;
  bool isTeamReady = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDummyMatch = null;
    isProcessing = true;
    createDummyMatch();
  }

  void createDummyMatch() async {
    ByteData clockData = await rootBundle.load('assets/All_Matches.zip');
    Uint8List clockBytes = clockData.buffer.asUint8List();

    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(clockBytes);

    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      if (file.isFile) {
        allDummyMatch.add(jsonDecode(String.fromCharCodes(file.content)));
        var tmp = jsonDecode(String.fromCharCodes(file.content));
      }

      if (this.mounted) {
        setState(() {
          isProcessing = false;
          selectedDummyMatch = allDummyMatch[0];
        });
      } else {
        isProcessing = false;
        selectedDummyMatch = allDummyMatch[0];
      }
      processAvailablePlayers();
    }
  }

  void processAvailablePlayers() async {
    String data = await rootBundle.loadString('assets/players.json');
    Map<String, dynamic> playersCredit = json.decode(data);

    String team;
    var innings = selectedDummyMatch['innings'][0]["1st innings"];
    team = innings["team"];
    for (var ballLogs in innings["deliveries"]) {
      String batsman = ballLogs.values.first["batsman"];
      if (!availablePlayers.containsKey(batsman)) {
        SinglePlayer pl = new SinglePlayer();
        pl.name = batsman;
        pl.credit = double.parse(playersCredit[batsman]);
        pl.team = team;

        if (this.mounted) {
          setState(() {
            availablePlayers[batsman] = pl;
          });
        } else {
          availablePlayers[batsman] = pl;
        }
      }

      String bowler = ballLogs.values.first["bowler"];
      if (!availablePlayers.containsKey(bowler)) {
        SinglePlayer pl = new SinglePlayer();
        pl.name = bowler;
        pl.credit = double.parse(playersCredit[bowler]);
        pl.team = selectedDummyMatch['innings'][1]["2nd innings"]["team"];

        if (this.mounted) {
          setState(() {
            availablePlayers[bowler] = pl;
          });
        } else {
          availablePlayers[bowler] = pl;
        }
      }
    }

    innings = selectedDummyMatch['innings'][1]["2nd innings"];
    team = innings["team"];
    for (var ballLogs in innings["deliveries"]) {
      String batsman = ballLogs.values.first["batsman"];
      if (!availablePlayers.containsKey(batsman)) {
        SinglePlayer pl = new SinglePlayer();
        pl.name = batsman;
        pl.credit = double.parse(playersCredit[batsman]);
        pl.team = team;

        if (this.mounted) {
          setState(() {
            availablePlayers[batsman] = pl;
          });
        } else {
          availablePlayers[batsman] = pl;
        }
      }

      String bowler = ballLogs.values.first["bowler"];
      if (!availablePlayers.containsKey(bowler)) {
        SinglePlayer pl = new SinglePlayer();
        pl.name = bowler;
        pl.credit = double.parse(playersCredit[bowler]);
        pl.team = selectedDummyMatch['innings'][0]["1st innings"]["team"];

        if (this.mounted) {
          setState(() {
            availablePlayers[bowler] = pl;
          });
        } else {
          availablePlayers[bowler] = pl;
        }
      }
    }

    for (int i = availablePlayers.keys.length; i < 28;) {
      var random = new Random();
      String player =
          playersCredit.keys.toList()[random.nextInt(playersCredit.length)];
      if (!availablePlayers.containsKey(player)) {
        SinglePlayer pl = new SinglePlayer();
        pl.name = player;
        pl.credit = double.parse(playersCredit[player]);
        pl.team = i % 2 == 0
            ? selectedDummyMatch['innings'][0]["1st innings"]["team"]
            : selectedDummyMatch['innings'][1]["2nd innings"]["team"];

        if (this.mounted) {
          setState(() {
            availablePlayers[player] = pl;
          });
        } else {
          availablePlayers[player] = pl;
        }

        i++;
      }
    }
  }

  void checkCurrentTeam(){
    int n1=0;
    int n2=0;

    for(var values in myCurrentTeam.values){
      if(values.title != "player") n1++;
      n2++;
    }
    print("${n1}  ${n2}");

    setState(() {
      if(n1==2 && n2==11){
        isTeamReady = true;
      }else{
        isTeamReady = false;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: Text(
              "Choose a match to create your team. Select 11 players and make captain, vice captain to start playing!",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.96,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  "Your Credit",
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
                    "${currentUserCredit}",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )
              ],
            )
          ),
          InkWell(
            onTap: isTeamReady ? (){
                widget.updateMatchTeam(selectedDummyMatch,myCurrentTeam);
            } : null,

            child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    color: isTeamReady ? Colors.tealAccent : Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
                child:Text("Start Playing",textAlign: TextAlign.center,)
            ),
          ),

          isProcessing
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: DropdownButton<Map<String, dynamic>>(
                    isExpanded: true,
                    value: selectedDummyMatch,
                    onChanged: (Map<String, dynamic> newValue) {
                      setState(() {
                        selectedDummyMatch = newValue;
                        currentUserCredit = 100.0;
                        myCurrentTeam.clear();
                        availablePlayers.clear();

                        processAvailablePlayers();
                      });
                    },
                    items: allDummyMatch
                        .map<DropdownMenuItem<Map<String, dynamic>>>(
                            (Map<String, dynamic> value) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: value,
                        child: Text(
                          value['info']['teams'].join(' vs '),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
          Divider(
            thickness: 2,
            color: Colors.blue,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: Text(
              "My Team(Select from available players)  ${myCurrentTeam.length} selected",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          for (MapEntry e in myCurrentTeam.entries)
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amberAccent,
                border: Border.all(
                    color: Color.fromRGBO(223, 225, 229, 1.0), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        e.value.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              myCurrentTeam.remove(e.key);
                              currentUserCredit += e.value.credit;
                            });
                            checkCurrentTeam();
                          }, child: Text("Remove"))
                    ],
                  ),
                   e.value.title == "player" ? Container() : Text(e.value.title,style: TextStyle(
                    color: Colors.green
                  ),),
                  Text("Credit: ${e.value.credit}"),
                  Text("Team: ${e.value.team}"),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            for(var key in myCurrentTeam.keys){
                              print(myCurrentTeam[key].title);
                              if(myCurrentTeam[key].title == "captain"){
                                setState(() {
                                  myCurrentTeam[key].title = "player";
                                });
                                break;
                              }
                            }
                            setState(() {
                              myCurrentTeam[e.key].title = "captain";
                            });
                            checkCurrentTeam();
                          }, child: Text("Make Captain")),
                      Expanded(child: Container()),
                      ElevatedButton(
                          onPressed: () {
                            for(var key in myCurrentTeam.keys){
                              if(myCurrentTeam[key].title == "vice captain"){
                                setState(() {
                                  myCurrentTeam[key].title = "player";
                                  myCurrentTeam[e.key].title = "vice captain";
                                });
                                break;
                              }
                            }
                            setState(() {
                              myCurrentTeam[e.key].title = "vice captain";
                            });
                            checkCurrentTeam();
                          }, child: Text("Make Vice captain"))
                    ],
                  ),
                ],
              ),
            ),
          Divider(
            thickness: 2,
            color: Colors.blue,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.92,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            child: Text(
              "Available Players",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          for (MapEntry<String,SinglePlayer> e in availablePlayers.entries)
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black26,
                border: Border.all(
                    color: Color.fromRGBO(223, 225, 229, 1.0), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        e.value.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      ElevatedButton(
                          onPressed: (e.value.credit <= currentUserCredit && !myCurrentTeam.containsKey(e.key)) ? () {

                            setState(() {
                              myCurrentTeam[e.key] = e.value;
                              currentUserCredit -= e.value.credit;
                            });
                            checkCurrentTeam();
                          } : null, child: Text("Add to your team"))
                    ],
                  ),
                  Text("Credit: ${e.value.credit}"),
                  Text("Team: ${e.value.team}"),
                ],
              ),
            )
        ],
      ),
    );
  }
}
