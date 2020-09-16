import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:football_match/tab_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

_LogInPageState pageState;

class LogInPage extends StatefulWidget {

//  final  GoogleSignIn _googleSignIn = GoogleSignIn();
//  final  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _LogInPageState createState(){
    pageState = _LogInPageState();
    return pageState;
  }
}

class _LogInPageState extends State<LogInPage> {
bool doRemember = false;
TextEditingController _mailCon = TextEditingController();
TextEditingController _pwCon = TextEditingController();

FirebaseProvider fp;
bool didUpdateUserInfo = false;

final String fName = "name";
final String fToken = "token";
final String fCreateTime = "createTime";
final String fPlatform = "platform";
final String fLocation = "location";

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging();

final GlobalKey <ScaffoldState>_scaffoldKey = new GlobalKey<ScaffoldState>();

@override
  void initState() {
    super.initState();
  }
@override
void dispose() {
  _mailCon.dispose();
  _pwCon.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
  fp = Provider.of<FirebaseProvider>(context);
  logger.d(fp.getUser());
    return Scaffold(
      key : _scaffoldKey,
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
                    updateUserInfo();
                    _signInWithGoogle();

                  },
                ),
              ),
            ),
            TextField(
              controller: _mailCon,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                hintText: "Email",
              ),
            ),
            TextField(
              controller: _pwCon,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: "Password",
              ),
              obscureText: true,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: doRemember,
                    onChanged: (newValue) {
                      setState(() {
                        doRemember = newValue;
                      });
                    },
                  ),
                  Text("Remember Me")
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RaisedButton(
                color: Colors.indigo[300],
                child: Text(
                  "SIGN IN",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode()); // 키보드 감춤
                  _signIn();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//  Future<User> _handleSignIn() async{
//    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//    User user = (await _auth.signInWithCredential(
//     GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken)
//    )).user;
//    return user;
//  }

  void _signIn() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   Signing-In...")
          ],
        ),
      ));
    bool result = await fp.signInWithEmail(_mailCon.text, _pwCon.text);
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if (result == false) showLastFBMessage();
  }

  void _signInWithGoogle() async{
    _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: Duration(seconds: 10),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("   Signing-In")
            ],
          ),
        ));
    bool result = await fp.signInWithGoogleAccount();
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if(result){
      Navigator.pushReplacement(context,MaterialPageRoute(
                        builder: (context) => TabPage(fp.getUser())
                      ));
    }
    if(result ==false) showLastFBMessage();
  }


  setRememberInfo() async {
    logger.d(doRemember);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if (doRemember) {
      prefs.setString("userEmail", _mailCon.text);
      prefs.setString("userPasswd", _pwCon.text);
    }
  }

  showLastFBMessage(){
  _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 10),
        content : Text(fp.getLastFBMessage()),
        action: SnackBarAction(
          label : 'Done',
          textColor : Colors.white,
          onPressed: (){},
        ),
      ));
  }

  void updateUserInfo() async {
    print("업데이트");
    if (fp.getUser() == null) return;
    String token = await _fcm.getToken();
    if (token == null) return;
    var user = _db.collection("users").doc(fp.getUser().uid);
    await user.get().then((DocumentSnapshot doc){
      if(!doc.exists){
        user.set({
          fName: fp.getUser().displayName,
          fToken: token,
          fCreateTime: FieldValue.serverTimestamp(),
          fPlatform: Platform.operatingSystem,
          fLocation : ''
        });
        setState(() {
          didUpdateUserInfo = true;
        });
      }
    });
  }
}
