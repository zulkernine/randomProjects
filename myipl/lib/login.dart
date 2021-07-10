import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myipl/data_classes/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogIn extends StatefulWidget {
  Function setUserData;
  LogIn({this.setUserData});
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email;
  String password;

  bool hasAccount = true;
  bool makingRequest = false;
  String errorMesssage = "";

  void handleLogin() async {
    setState(() {
      makingRequest = true;
      errorMesssage = "";
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, "/home");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          errorMesssage = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorMesssage = 'Wrong password provided for that user.';
        });
      }
    }

    setState(() {
      makingRequest = false;
    });
  }

  void handleSignUp() async {
    setState(() {
      makingRequest = true;
      errorMesssage = "";
    });

    UserCredential userCredential = null;

    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          errorMesssage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMesssage = 'The account already exists for that email.';
        }
      });
    } catch (e) {
      setState(() {
        errorMesssage = "Check your mail, or use good/long password!";
      });
    }

    if (userCredential != null) {
      UserData userData = new UserData();
      userData.userID = userCredential.user.uid;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      try {
        widget.setUserData(data:userData);
        await users.doc(userCredential.user.uid).set(userData.toJson());
      } catch (e) {
        print("newerror");
        print(e.toString());
      }
      Navigator.pushReplacementNamed(context, "/home");
    }
    setState(() {
      makingRequest = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.account_circle_outlined,
                size: 150,
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onChanged: (String text) {
                  setState(() {
                    email = text;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
                onChanged: (String text) {
                  setState(() {
                    password = text;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              makingRequest
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: hasAccount ? handleLogin : handleSignUp,
                      child: hasAccount ? Text("Login") : Text("Register"),
                    ),
              SizedBox(
                height: 20,
              ),
              errorMesssage.isEmpty
                  ? Text("")
                  : Text(
                      errorMesssage,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    hasAccount = (!hasAccount);
                  });
                },
                child: hasAccount
                    ? Text(
                        "Create Account",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      )
                    : Text(
                        "Sign In",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
