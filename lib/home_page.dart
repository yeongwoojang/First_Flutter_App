import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = '';
  String test = '';
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
  bool pressButton;
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

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Football Match'),
        backgroundColor: Colors.green[100],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 300,
                  height: 330,
                  child: Card(
                    child: Column(
                      children: <Widget>[
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
                                                height: 700.0,
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
                                                          return RaisedButton(
                                                            child: Text('저장'),
                                                            color: Colors
                                                                .green[100],
                                                            elevation: 0.8,
                                                            onPressed: () {
                                                              var doc = FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'user')
                                                                  .doc(widget
                                                                      .user
                                                                      .displayName);
                                                              doc.set({
                                                                'loc': location,
                                                              }).then(
                                                                  (onValue) {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                          );
                                                        }
                                                        return ListTile(
                                                          title: RaisedButton(
                                                            child: Text((doName[
                                                                index])),
                                                            color: btclick[index]
                                                                ? Colors
                                                                    .red[300]
                                                                : Colors.yellow,
                                                            elevation: 0.8,
                                                            onPressed: () {
                                                              setState(() {
                                                                for (int i = 0;
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
                                  .collection('user')
                                  .doc(widget.user.displayName)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: CircularProgressIndicator());
                                }else if(snapshot.data.data()==null){
                                   return Text('');
                                }else {
                                  var items = snapshot.data;
                                  return Text(items.data()['loc']);
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
                            Text('매칭대기'),
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

//  void _showDialog() {
//
//
//  }
}
