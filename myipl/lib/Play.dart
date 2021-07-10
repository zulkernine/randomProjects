import 'package:flutter/material.dart';
import 'package:myipl/CreateTeam.dart';
import 'package:myipl/CustomDrawer.dart';
import 'package:myipl/LiveMatch.dart';
import 'package:myipl/data_classes/SinglePlayer.dart';
import 'package:myipl/data_classes/UserData.dart';
import 'dart:isolate';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Play extends StatefulWidget {
  UserData userData;
  Play({this.userData});

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  bool fetchData = false;
  bool isPlaying = false;

  Map<String, SinglePlayer> myCurrentTeam = new Map<String, SinglePlayer>();
  Map<String, dynamic> currentMatch = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setMatchTeam(
      Map<String, dynamic> match, Map<String, SinglePlayer> team) async {
    LiveMatchData liveData = new LiveMatchData();
    liveData.updateTime =
        (DateTime.now().microsecondsSinceEpoch ~/ 1000).toString();
    liveData.currentTeam.clear();
    liveData.currentTeam.addAll(team);
    liveData.currentMatch.clear();
    liveData.currentMatch.addAll(match);
    widget.userData.liveData = liveData;

    updateUserData(widget.userData).then((value) => {
          setState(() {
            isPlaying = true;
          })
        });

    //TODO start the game, with push to firestore
    simulateTheMatch();
  }

  Future<void> updateUserData(UserData userData) async {
    User user = FirebaseAuth.instance.currentUser;
    print(user.uid + "   json: " + userData.liveData.toJson().toString());

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.doc(user.uid).update(userData.toJson());
  }

  void simulateTheMatch() async {
    User user = FirebaseAuth.instance.currentUser;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentSnapshot snapshot = await users.doc(user.uid).get();

    print(snapshot.data());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Let's Play"),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: fetchData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (isPlaying
                  ? LiveMatch(
                      userData: widget.userData,
                    )
                  : CreateTeam(
                      updateMatchTeam: setMatchTeam,
                    )),
        ),
      ),
    ));
  }
}
