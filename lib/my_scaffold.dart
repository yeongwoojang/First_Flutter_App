import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/my_drawer.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class MyScaffold extends StatelessWidget {
  final Widget body;
  final Widget appbar;
  MyScaffold({this.appbar,this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: body,
      drawer: MyDrawer(
        header: UserAccountsDrawerHeader(
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
      ),
    );
  }
}
