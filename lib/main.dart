import "package:flutter/material.dart";
import 'package:football_match/firebase_provider.dart';
import 'package:football_match/login.dart';
import 'package:football_match/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<FirebaseProvider>(
          create: (_) => FirebaseProvider())
    ],
    child: MaterialApp(
      title: "Flutter Firebase",
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    ),
  );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        primarySwatch: Colors.blue,
    ),
      home : LogInPage(),
    );
  }
}
