import 'dart:convert';

import 'package:myipl/data_classes/MatchOutcome.dart';

class Scoreboard{
  String totalScore="0.0";
  List<MatchOutcome> previousScore = <MatchOutcome>[];

  Scoreboard.fromJson(Map<String, dynamic> jsn)
      : totalScore = jsn['totalScore'],
        previousScore = (json.decode(jsn['previousScore']) as List).map((i) =>
            MatchOutcome.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
    'totalScore':totalScore,
    'previousScore':jsonEncode(previousScore),
  };

  Scoreboard();
}