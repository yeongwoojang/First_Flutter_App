//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:football_match/seconed_create_page.dart';
//
//class FirstCreatePage extends StatefulWidget {
//  final User user;
//
//  FirstCreatePage(this.user);
//
//  @override
//  _FirstCreatePageState createState() => _FirstCreatePageState();
//}
//
//class _FirstCreatePageState extends State<FirstCreatePage> {
//  String dropdwonValue = "서울";
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: _buildBody(),
//    );
//  }
//
//  Widget _buildBody() {
//    return Center(
//      child: Column(
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.all(80.0),
//          ),
//          Text(
//            '지역을 선택하세요',
//            style: TextStyle(fontSize: 30.0),
//          ),
//          Padding(
//            padding: EdgeInsets.all(80.0),
//          ),
//          RaisedButton(
//            color: Colors.yellow,
//            child: Text('내 지역으로 설정'),
//            onPressed: (){
//              setState(() {
//
//              });
//            },
//          ),
//          DropdownButton<String>(
//            value: dropdwonValue,
//            iconSize: 24,
//            elevation: 16,
//            style: TextStyle(
//              color: Colors.black,
//            ),
//            underline: Container(
//              height: 0,
//            ),
//            onChanged: (String newValue) {
//              setState(() {
//                dropdwonValue = newValue;
//                Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => SeconedCreatePage(widget.user,dropdwonValue)
//                ));
//              });
//            },
//            items: <String>[
//              '서울',
//              '경기',
//              '인천',
//              '충북',
//              '충남',
//              '전북',
//              '전남',
//              '경북',
//              '경남',
//              '강원',
//              '제주'
//            ].map<DropdownMenuItem<String>>((String value) {
//              return DropdownMenuItem<String>(
//                value: value,
//                child: Text(value),
//              );
//            }).toList(),
//          ),
//        ],
//      ),
//    );
//  }
//
//}
