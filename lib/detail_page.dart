import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final dynamic data;

  DetailPage(this.data);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  bool didUpdateUserInfo = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseProvider fp;

  final String fName = "name";
  final String fToken = "token";
  final String fCreateTime = "createTime";
  final String fPlatform = "platform";
  final String fLocation = "location";

  final HttpsCallable sendFCM = CloudFunctions.instance
      .getHttpsCallable(functionName: 'sendFCM')
    ..timeout = const Duration(seconds: 30);


  Map<String,bool> _map = Map();


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
      child: SizedBox(
        width: 400.0,
        height: 400.0,
        child: StreamBuilder<QuerySnapshot>(
          stream: _db.collection('users').where('name', isEqualTo: widget.data.data()['creator']).snapshots(),
          builder:  (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text("Error: ${snapshot.error}");
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text("Loading...");
                break;
              default:
                var item = snapshot.data.docs[0];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              widget.data.data()['title'],
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.email),
                            onPressed: () {
                              sendSampleFCM(item.data()['token']);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      Divider(),
                      Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(widget.data.data()['content'])),
                    ],
                  ),
                );
            }
          }
        ),
      ),
    );
  }
  void sendSampleFCM(String token) async {
    final HttpsCallableResult result = await sendFCM.call(
      <String, dynamic>{
        fToken: token,
        "title": "Sample Title",
        "body": "This is a Sample FCM"
      },
    );
  }


  // ken리스트에 해당하는 디바이스들로 FCM 전송
  void sendSampleFCMtoSelectedDevice() async {
    List<String> tokenList = List<String>();
    _map.forEach((String key, bool value) {
      if (value) {
        tokenList.add(key);
      }
    });
    if (tokenList.length == 0) return;
    final HttpsCallableResult result = await sendFCM.call(
      <String, dynamic>{
        fToken: tokenList,
        "title": "Sample Title",
        "body": "This is a Sample FCM"
      },
    );
  }

  void sendCustomFCM(String token, String title, String body) async {
    if (title.isEmpty || body.isEmpty) return;
    final HttpsCallableResult result = await sendFCM.call(
      <String, dynamic>{
        fToken: token,
        "title": title,
        "body": body,
      },
    );
  }

  String timestampToStrDateTime(Timestamp ts) {
    if (ts == null) return "";
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
