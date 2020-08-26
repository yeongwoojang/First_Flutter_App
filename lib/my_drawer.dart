import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
class MyDrawer extends StatelessWidget {
UserAccountsDrawerHeader header;

MyDrawer({this.header});

  @override
  Widget build(BuildContext context) {
    return Drawer(
              child: ListView(children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('image/default_u_image.png'),
              backgroundColor: Colors.transparent,
            ),
            accountName: Text(_auth.currentUser.displayName),
            accountEmail: Text(_auth.currentUser.email),
            onDetailsPressed: () {
              print('arrow is clicked');
            },
            decoration: BoxDecoration(
                color: Colors.amber[300],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )),
          ),
        //   ListTile(
        //     leading: Icon(
        //       Icons.home,
        //       color: Colors.grey[850],
        //     ),
        //     title: Text('Home'),
        //     onTap: () {
        //       print('Home is cliked');
        //     },
        //     trailing: Icon(Icons.add),
        //   ),
        //   ListTile(
        //     leading: Icon(
        //       Icons.home,
        //       color: Colors.grey[850],
        //     ),
        //     title: Text('Q&A'),
        //     onTap: () {
        //       print('Settings is cliked');
        //     },
        //     trailing: Icon(Icons.settings),
        //   ),
        //   ListTile(
        //     leading: Icon(
        //       Icons.home,
        //       color: Colors.grey[850],
        //     ),
        //     title: Text('Q&A'),
        //     onTap: () {
        //       print('Q&A is cliked');
        //     },
        //     trailing: Icon(Icons.question_answer),
        //   ),
        ]
        ),
    );
  }
}