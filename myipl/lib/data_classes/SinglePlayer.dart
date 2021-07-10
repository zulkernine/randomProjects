class SinglePlayer{
  String name;
  String team;
  String title="player";
  double credit=0;
  int run=0;
  int wicket=0;

  SinglePlayer();

  SinglePlayer.fromJson(Map<String, dynamic> jsn)
      : name = jsn['name'],
        team = jsn["team"],
        title = jsn["title"],
        run = jsn["run"],
        wicket = jsn["wicket"]
  {
    credit=0;
  }

  Map<String, dynamic> toJson() => {
    "name":name,
    "team":team,
    "title":title,
    "run":run,
    "wicket":wicket
  };
}