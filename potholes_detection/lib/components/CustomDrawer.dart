import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Sample User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            onTap: (){
              Navigator.pushNamed(context, "/");
            },
            splashColor: Colors.blue,

          ),
          InkWell(
              child: ListTile(
                leading: Icon(Icons.upload_file),
                title: Text('Upload Pic and get Recommendation'),
              ),
              onTap: (){
                Navigator.pushNamed(context, "/upload");
              }
          ),
          InkWell(
              child: ListTile(
                leading: Icon(Icons.map),
                title: Text('See anomalies live'),
              ),
              onTap: (){
                Navigator.pushNamed(context, "/map");
              }
          ),
        ],
      ),
    );
  }
}
