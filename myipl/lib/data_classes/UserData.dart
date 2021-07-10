import 'package:myipl/data_classes/Scoreboard.dart';
import 'package:myipl/data_classes/SinglePlayer.dart';
import 'dart:convert';

class UserData {
  Scoreboard scoreboard = new Scoreboard();
  String userID = "";
  LiveMatchData liveData;

  UserData() {
    liveData = null;
  }

  UserData.fromJson(Map<String, dynamic> jsn)
      : scoreboard = Scoreboard.fromJson(jsn['scoreboard']),
        userID = jsn['userID'],
        liveData = jsn['liveData'] == ""
            ? null
            : LiveMatchData.fromJson(jsn['liveData']);

  Map<String, dynamic> toJson() => {
        'scoreboard': scoreboard.toJson(),
        'userID': userID,
        'liveData': liveData == null ? "" : liveData.toJson()
      };
}

class LiveMatchData {
  Map<String, dynamic> currentMatch = new Map();
  Map<String, dynamic> ballLogs;
  Map<String, SinglePlayer> currentTeam = new Map<String, SinglePlayer>();
  String updateTime = "";

  LiveMatchData() {
    ballLogs = null;
  }

  LiveMatchData.fromJson(Map<String, dynamic> jsn)
      : currentMatch = json.decode(jsn["currentMatch"]),
        ballLogs = json.decode(jsn['ballLogs']),
        updateTime = jsn["updateTime"] {
    Map<String,dynamic> team = json.decode(jsn["currentTeam"]);
    for(MapEntry e in team.entries){
      currentTeam[e.key] = SinglePlayer.fromJson(e.value);
    }
  }

  Map<String, dynamic> toJson() => {
        'currentMatch': jsonEncode(currentMatch),
        'ballLogs': jsonEncode(ballLogs),
        'currentTeam': jsonEncode(currentTeam),
        'updateTime': updateTime
      };
}
