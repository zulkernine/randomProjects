import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: [
                ElevatedButton(onPressed: ()async{
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                }, child: Text("Logout",style:TextStyle(
                  color: Colors.white,
                )))
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, "/dashboard");
            },
          ),
          ListTile(
            title: Text('Play'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushNamed(context, "/play");
            },
          ),
        ],
      ),
    );
  }
}
