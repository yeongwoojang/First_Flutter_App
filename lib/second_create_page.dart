import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:provider/provider.dart';

class SecondCreatePage extends StatefulWidget {
  final String location;

  SecondCreatePage(this.location);

  @override
  _SecondCreatePageState createState() => _SecondCreatePageState();
}

class _SecondCreatePageState extends State<SecondCreatePage> {

  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseProvider fp;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();



  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title : Text('Football Match')

      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              TextField(
                controller: title,
                decoration: InputDecoration(hintText: '제목'),
              ),
              TextField(
                controller: content,
                decoration: InputDecoration(
                  hintText: "내용",
                ),
                scrollPadding: EdgeInsets.all(10.0),
                maxLines: 10,
              ),
              ButtonTheme(
                minWidth: 400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  color: Colors.grey,
                  child: Text('등록'),
                  onPressed: () {
                    write();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    title.dispose();
    content.dispose();
  }
  void write() async{
    var now = new DateTime.now();
    var matches = _db.collection('matches').doc(now.toString());
    var users = _db.collection('users').doc(fp.getUser().uid);
    await matches.set({
      'creator' :fp.getUser().displayName,
      'location' : widget.location,
      'title' : title.text,
      'content': content.text
    });

    await users.collection('myMatch').doc(now.toString())
    .set({
      'title' : title.text,
      'content' : content.text,
      'location' : widget.location,
      'matchingState' : false
    });
  }
}
