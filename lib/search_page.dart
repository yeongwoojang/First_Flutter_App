import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/detail_page.dart';

class SearchPage extends StatefulWidget {
  final User user;

  SearchPage(this.user);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  String dropdwonValue;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('user').doc(widget.user.displayName).get().then((snapshot){
      setState(() {
        dropdwonValue = snapshot.data()['loc'];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match'),
        actions: <Widget>[
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(widget.user.displayName)
          .collection('matchInfo').where('loc',isEqualTo: dropdwonValue).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          var items = snapshot.data?.documents ?? [];
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildList(context, items[index]);
              });
        }
      },
    );
  }

  Widget _buildList(context, document) {
    return Hero(
      tag: document.data()['content'],
      child: SizedBox(
        child: Card(
          elevation: 2.0,
          child: Material(
            child: InkWell(
              onTap: () {
                print(document.data());
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DetailPage(widget.user,document.data())
                ));
              },
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      document.data()['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(document.data()['loc'],
                        style: TextStyle(fontSize: 10.0, color: Colors.orange)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}