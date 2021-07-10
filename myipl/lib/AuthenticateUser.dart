import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myipl/data_classes/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AuthenticateUser extends StatefulWidget {
  final Function updateUserData;
  AuthenticateUser({this.updateUserData});

  @override
  _AuthenticateUserState createState() => _AuthenticateUserState();
}

class _AuthenticateUserState extends State<AuthenticateUser> {

  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeFlutterFire();
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      FirebaseAuth auth = FirebaseAuth.instance;

      if (auth.currentUser != null) {
        print(auth.currentUser.email);
        CollectionReference users = FirebaseFirestore.instance.collection('users');

        DocumentSnapshot snapshot = await users.doc(auth.currentUser.uid).get();
        print("snahshot data");
        print(snapshot.data());
        widget.updateUserData(data:UserData.fromJson(snapshot.data()));
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        Navigator.pushReplacementNamed(context, "/login");
      }
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
      print(e);
    }
  }

  void accessUserData() async{
    //Fetch data from database and update local data. :)
  }

  @override
  Widget build(BuildContext context) {
    if(_error){
      return SafeArea(child: Scaffold(
        body: Center(
          child: Text(
            "Sorry, Some error occurred! Check Your connection and restart."
          ),
        ),
      ));
    }

    return SafeArea(child: Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }
}
