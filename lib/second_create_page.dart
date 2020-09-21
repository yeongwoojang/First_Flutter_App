import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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

  String _selectedDate;
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
//      appBar: AppBar(
//        title: Text('글쓰기'),
//        centerTitle: true,
//        backgroundColor: Colors.greenAccent,
//        automaticallyImplyLeading: false,
//      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              elevation: 0.8,
                            ),
                          ),
                          Text('글쓰기',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                          ButtonTheme(
                            minWidth: 50.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Text('등록'),
                              elevation: 0.8,
                              onPressed: () {
                                print(_selectedDate);
                                if (_selectedDate == null ||title.text==null || content.text ==null) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('정확히 입력해주세요'
                                        ''),
                                    duration: Duration(seconds: 1),
                                  ));
                                } else {
                                  write();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text('날짜 : '),
                      Text(_selectedDate ?? ''),
                      IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
                          Future<DateTime> date = showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(Duration(days: 1000)),
                              builder:
                                  (BuildContext buildContext, Widget child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child,
                                );
                              });
                          date.then((dateTime) {
                            setState(() {
                              _selectedDate = dateFormat.format(dateTime);
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  TextField(
                    controller: title,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                      hintText: "제목",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    scrollPadding: EdgeInsets.all(10.0),
                  ),
                  TextField(
                    controller: content,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5.0),
                      hintText: "내용",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    scrollPadding: EdgeInsets.all(10.0),
                    maxLines: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    title.dispose();
    content.dispose();
  }

  void write() async {
    var now = new DateTime.now();
    var matches = _db.collection('matches').doc(now.toString());
    var users = _db.collection('users').doc(fp.getUser().uid);
    await matches.set({
      'creator': fp.getUser().displayName,
      'location': widget.location,
      'title': title.text,
      'content': content.text,
      'date': _selectedDate
    });

    await users.collection('myMatch').doc(now.toString()).set({
      'title': title.text,
      'content': content.text,
      'location': widget.location,
      'date': _selectedDate,
      'matchingState': false
    });
  }
}
