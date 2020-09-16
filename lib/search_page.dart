import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/detail_page.dart';
import 'package:football_match/firebase_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {

  final User user;


  SearchPage(this.user);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseProvider fp;
  String dropDownValue;
  List<String> titleList = [];

  @override
  void initState() {
    super.initState();

    _db.collection('users').doc(widget.user.uid)
    .get().then((DocumentSnapshot doc){
      setState(() {
        dropDownValue = doc.data()['location'];
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Match'),
        actions: <Widget>[
          DropdownButton<String>(
            value: dropDownValue,
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
                dropDownValue = newValue;
              });
            },
            items: <String>['서울','경기','인천', '충북','충남','전남','경북','경남','강원','제주']
            .map<DropdownMenuItem<String>>((String value) {
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
    return StreamBuilder<QuerySnapshot>(
      stream: _db.collection('matches')
          .where('location', isEqualTo: dropDownValue)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          var items = snapshot.data.documents;
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildList(context,items[index]);
              });
        }
      },
    );
  }

  Widget _buildList(context, document) {
    return Hero(
      tag: document.id,
      child: SizedBox(
        child: Card(
          elevation: 2.0,
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(document)));
              },
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      document.data()['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
