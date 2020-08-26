import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:football_match/user_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
        'LogIn',
        style: TextStyle(
        color: Colors.white,
    ),
    ),
    centerTitle: true,
    elevation: 0.2,
    ),
      body : Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset('image/glogo.png'),
                Text(
                  '구글로그인',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Image.asset('image/glogo.png'),
                ),
              ],
            ),
            color: Colors.white,
            onPressed: () async {
              final User user = await _auth.currentUser;
              if (user == null) {
                _signInWithGoogle(context);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('이미 로그인되어있습니다.'),
                  ),
                );
              }
            },
          ),
          RaisedButton(
            child: Text(
              '로그아웃',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
            onPressed: () async {
              final User user = await _auth.currentUser;
              if (user == null) {
                Scaffold.of(context).showSnackBar(const SnackBar(
                  content: Text('로그인 하지 않았습니다.'),
                ));
                return;
              }
              _signOut();
              final String uid = user.displayName;
              // Scaffold.of(context).showSnackBar(SnackBar(
                // content: Text(uid + '이(가) 로그아웃 되었습니다.'),
              // ));
            },
          ),
        ],
      ),
    ),
    );
  }
}

Future<void> _signInWithGoogle(BuildContext context) async {
  try {
    UserCredential userCredential;
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      userCredential = await _auth.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
    }

    final user = userCredential.user;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return UserPage();
      }),
    );
  } catch (e) {
    print(e);
    print("Failed to sign in with Google: $e");
  }
}

Future<void> _signOut() async {
  await _auth.signOut();
}
