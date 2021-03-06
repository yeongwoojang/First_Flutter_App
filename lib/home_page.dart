import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;
  var currentUser;

  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String location = '';
  String test = '';
  FirebaseProvider fp;
  bool didUpdateUserInfo = false;

  final String fName = "name";
  final String fToken = "token";
  final String fCreateTime = "createTime";
  final String fPlatform = "platform";
  final String fLocation = "location";

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  List doName = [
    '서울',
    '경기',
    '인천',
    '충북',
    '충남',
    '전북',
    '전남',
    '경북',
    '경남',
    '강원',
    '제주'
  ];
  List btclick = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  bool pressButton;

  @override
  void initState() {
    super.initState();

    _fcm.configure(
        //앱이 실행중일 경우
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage : $message');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message['notification']['title']),
            subtitle: Text(message['notification']['body']),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
        //앱이 완전히 종료된 경우
        onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch :$message');
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    });
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    if (didUpdateUserInfo == false) updateUserInfo();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Football Match'),
        backgroundColor: Colors.green[100],
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: Icon(Icons.menu),
        ),
      ),
      body: _buildBody(context),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text('등급 : ',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      Text(''),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text('경고 : ',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                      Padding(padding: EdgeInsets.only(right: 10.0)),
                      Text(''),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.green[100],
              ),
            ),
            StreamBuilder(
                stream:
                    _db.collection("users").doc(fp.getUser().uid).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  var mSelected = false;
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data.data() == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var items = snapshot.data;
                    if (items.data()['requestor'] != null) {
                      mSelected = true;
                    }
                    return ListTile(
                      title: Text('요청보기'),
                      trailing: IconButton(
                          icon: Icon(Icons.check),
                          color: Colors.black,
                          onPressed: () {
                            getRequestorList(context);
                          }),
                      selected: mSelected,
                    );
                  }
                }),
            ListTile(
              title: Text('로그아웃'),
              trailing: IconButton(
                icon: Icon(Icons.exit_to_app),
                color: Colors.black,
                onPressed: () {
                  fp.signOut();
//            fp.withdrawalAccount();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30)),
                SizedBox(
                  width: 300,
                  height: 330,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                        ),
                        Text('${widget.user.displayName}님 환영합니다.'),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.user.photoURL),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Text(widget.user.email),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: RaisedButton(
                            color: Colors.green[100],
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        content: SingleChildScrollView(
                                          child: SafeArea(
                                            child: SizedBox(
                                                width: 500.0,
                                                height: 500.0,
                                                child: Container(
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          doName.length + 1,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        if (index ==
                                                            doName.length) {
                                                          return StreamBuilder<
                                                                  DocumentSnapshot>(
                                                              stream: _db
                                                                  .collection(
                                                                      'users')
                                                                  .doc(fp
                                                                      .getUser()
                                                                      .uid)
                                                                  .snapshots(),
                                                              builder: (BuildContext
                                                                      context,
                                                                  AsyncSnapshot<
                                                                          DocumentSnapshot>
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasError)
                                                                  return Text(
                                                                      "Error: ${snapshot.error}");
                                                                switch (snapshot
                                                                    .connectionState) {
                                                                  case ConnectionState
                                                                      .waiting:
                                                                    return Text(
                                                                        "Loading...");
                                                                    break;
                                                                  default:
                                                                    return ButtonTheme(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      child:
                                                                          RaisedButton(
                                                                        child: Text(
                                                                            '저장'),
                                                                        color: Colors
                                                                            .orange,
                                                                        onPressed:
                                                                            () {
                                                                          setLocation(
                                                                              location);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        elevation:
                                                                            0.8,
                                                                      ),
                                                                    );
                                                                }
                                                              });
                                                        }
                                                        return ListTile(
                                                          title: ButtonTheme(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child: RaisedButton(
                                                              child: Text(
                                                                  (doName[
                                                                      index])),
                                                              color: btclick[index]
                                                                  ? Colors
                                                                      .red[300]
                                                                  : Colors
                                                                      .yellow,
                                                              elevation: 0.5,
                                                              onPressed: () {
                                                                setState(() {
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          btclick
                                                                              .length;
                                                                      i++) {
                                                                    if (i !=
                                                                        index) {
                                                                      btclick[i] =
                                                                          false;
                                                                    }
                                                                  }
                                                                  btclick[index] =
                                                                      !btclick[
                                                                          index];
                                                                  location =
                                                                      doName[
                                                                          index];
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                )),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Text('지역 변경'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('지역 : '),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(fp.getUser().uid)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.data.data() == null) {
                                  return Text('');
                                } else {
                                  var items = snapshot.data;
                                  return Text(items.data()['location']);
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('상태 : '),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateUserInfo() async {
    print("업데이트");
    if (fp.getUser() == null) return;
    String token = await _fcm.getToken();
    if (token == null) return;
    var user = _db.collection("users").doc(fp.getUser().uid);
    await user.get().then((DocumentSnapshot doc) {
      if (!doc.exists) {
        user.set({
          fName: fp.getUser().displayName,
          fToken: token,
          fCreateTime: FieldValue.serverTimestamp(),
          fPlatform: Platform.operatingSystem,
          fLocation: ''
        });
        setState(() {
          didUpdateUserInfo = true;
        });
      } else {}
    });
  }

  void setLocation(String location) async {
    var user = _db.collection("users").doc(fp.getUser().uid);
    await user.update({fLocation: location});
  }

  void getRequestorList(context) async {
    var list;
    var user = _db.collection("users").doc(fp.getUser().uid);
    await user.get().then((DocumentSnapshot doc) {
      if(doc.data()['requestor']==null){
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('요청이 없습니다.'),
          duration: Duration(seconds: 1),
        ));
        return false;
      }else{
        List<String> test = List.from(doc.data()['requestor']);
        if (test.length!=0) {
          _db.collection('users').get().then((QuerySnapshot snapshot){
            list = snapshot.docs;
            for(int i=0;i<list.length;i++){
              if(test.contains(list[i].id)){
                print(list[i].data()['name']);
              }
            }
            showDialog( context: context,
                builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    content: SingleChildScrollView(
                        child: SafeArea(
                            child: SizedBox(
                              width: 500,
                              height: 500,
                              child: Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: list.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                          title : Text(list[index].data()['name'])
                                      );
                                    }),
                              ),
                            ))),
                  );
                });

          });

      }


      }
    });

  }
}
