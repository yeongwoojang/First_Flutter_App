import 'package:flutter/material.dart';
import 'package:football_match/auth.dart';
import 'package:football_match/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:football_match/user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Auth _auth = Auth();
  final bool isLogged = await _auth.isLogged();
  runApp(MyApp(
      initialRoute : isLogged ? '/user' : '/'
  ));
}

class MyApp extends StatelessWidget {

  final String initialRoute;


  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Football_Match',
      initialRoute: initialRoute,
      routes: {
        '/': (BuildContext context) => LogInPage(),
        '/user': (BuildContext context) => UserPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
    );
  }
}
