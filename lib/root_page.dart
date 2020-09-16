import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:football_match/login.dart';
import 'package:football_match/tab_page.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
//    fp = Provider.of<FirebaseProvider>(context);
//
//    if(fp.getUser()!=null){
//      return LogInPage();
//    }else{
//      return TabPage(fp.getUser());
//    }
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return TabPage(snapshot.data);
        }else{
          return LogInPage();
        }
      },
    );
//    return LogInPage();
  }
}
