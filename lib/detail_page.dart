import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final User user;
  final dynamic data;

  DetailPage(this.user, this.data);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SizedBox(
        width: 400.0,
        height: 400.0,
        child: Card(
          elevation: 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Padding(
                padding: EdgeInsets.only(left : 8.0),
                child: Text(
                  widget.data['title'],
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Divider(),
              Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(widget.data['content'])),
            ],
          ),
        ),
      ),
    );
  }
}
