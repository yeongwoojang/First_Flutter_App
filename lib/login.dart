import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/tab_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogInPage extends StatelessWidget {

  final  GoogleSignIn _googleSignIn = GoogleSignIn();
  final  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FootBall Match',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(50.0),
            ),
            Padding(
              padding : EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: ButtonTheme(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
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
                        child : Image.asset('image/glogo.png'),
                      ),
                    ],
                  ),
                  color : Colors.white,
                  onPressed: (){
                    _handleSignIn().then((user){
                      Navigator.pushReplacement(context,MaterialPageRoute(
                        builder: (context) => TabPage(user)
                      ));
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User> _handleSignIn() async{
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    User user = (await _auth.signInWithCredential(
     GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken)
    )).user;
    return user;
  }
}
