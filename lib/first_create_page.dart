import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:football_match/second_create_page.dart';
import 'package:provider/provider.dart';

class FirstCreatePage extends StatefulWidget {

  FirstCreatePage();

  @override
  _FirstCreatePageState createState() => _FirstCreatePageState();
}

class _FirstCreatePageState extends State<FirstCreatePage> {
  String dropdwonValue = "서울";

  FirebaseProvider fp;
  bool didUpdateUserInfo = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      //앱이 실행중일 경우
        onMessage: (Map<String,dynamic> message) async{
          print('onMessage : $message');
          showDialog(
            context : context,
            builder: (context) => AlertDialog(
              content : ListTile(
                title : Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        //앱이 완전히 종료된 경우
        onLaunch: (Map<String,dynamic>message) async{
          print('onLaunch :$message');
        },

        onResume: (Map<String,dynamic>message) async{
          print("onResume: $message");
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    fp = Provider.of<FirebaseProvider>(context);
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(80.0),
          ),
          Text(
            '지역을 선택하세요',
            style: TextStyle(fontSize: 30.0),
          ),
          Padding(
            padding: EdgeInsets.all(80.0),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: _db.collection('users').doc(fp.getUser().uid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              return RaisedButton(
                color: Colors.yellow,
                child: Text('내 지역으로 설정'),
                onPressed: (){
                  if(snapshot.data.data()['location']==''){
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content : Text('지역을 먼저 설정해주세요.'),
                      duration: Duration(seconds: 1),
                    ));
                  }else{
                    Navigator.push(context,MaterialPageRoute(
                        builder: (context)=>SecondCreatePage(snapshot.data.data()['location'])));
                  }
                },
              );
            }
          ),

          DropdownButton<String>(
            value: dropdwonValue,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(
              color: Colors.black,
            ),
            underline: Container(
              height: 0,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdwonValue = newValue;
                Navigator.push(context, MaterialPageRoute(
                 builder: (context) => SecondCreatePage(dropdwonValue)
                ));
              });
            },
            items: <String>[
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
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

}
