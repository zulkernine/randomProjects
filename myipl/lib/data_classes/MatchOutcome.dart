class MatchOutcome{
  String participants;
  String winner;
  String myScore;
  String myTeam;
  String date;

  MatchOutcome.fromJson(Map<String, dynamic> json)
      : participants = json['participants'],
        winner = json['winner'],
        myScore = json['myScore'],
        myTeam = json['myTeam'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'participants':participants,
    'winner':winner,
    'myScore':myScore,
    'myTeam':myTeam,
    'date':date
  };

  MatchOutcome();
}
