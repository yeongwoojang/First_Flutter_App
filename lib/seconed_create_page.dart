import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SeconedCreatePage extends StatefulWidget {
  final User user;

  SeconedCreatePage(this.user);

  @override
  _SeconedCreatePageState createState() => _SeconedCreatePageState();
}

class _SeconedCreatePageState extends State<SeconedCreatePage> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.user.displayName)
                        .get()
                        .then((snapshot) {
                      if (snapshot.data() == null) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text('먼저 지역을 설정해주세요.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(widget.user.displayName)
                            .update({
                          'title': FieldValue.arrayUnion([title.text]),
                          'content': FieldValue.arrayUnion([content.text]),
                        });
                        title.clear();
                        content.clear();
                        FocusScope.of(context).unfocus();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
