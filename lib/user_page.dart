import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_match/login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _msg = 'Welcome to WillPopScope World';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          _msg = "You can not get out of here! kkk";
        });
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text('UserPage'),
          centerTitle: true,
          actions: <Widget>[
            Builder(builder: (BuildContext ctx) {
              return IconButton(
                  icon: Icon(Icons.reply),
                  onPressed: () async {
                    Navigator.pop(context);
                    final User user = await _auth.currentUser;
                    _signOut();
                    final String uid = user.displayName;
                    // Scaffold.of(ctx).showSnackBar(SnackBar(
                    // content: Text(uid + '이(가) 로그아웃 되었습니다.'),
                    // ));
                  });
            })
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('image/user_image.png'),
                  backgroundColor: Colors.transparent,
                ),
                accountName: Text(_auth.currentUser.displayName),
                accountEmail: Text(_auth.currentUser.email),
                onDetailsPressed: () {
                  print('arrow is clicked');
                },
                decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    )),
              ),
              ListTile(
                leading: Icon(
                  Icons.call_received,
                  color: Colors.grey[850],
                ),
                title: Text('matching'),
                onTap: () {
                  print('matching is cliked');
                },
                trailing: Icon(Icons.add),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Color(0xff344955),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: 56.0,
            child: Row(children: <Widget>[
              IconButton(
                onPressed: showMenu,
                icon: Icon(Icons.menu),
                color: Colors.white,
              ),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
                color: Colors.white,
              )
            ]),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ButtonTheme(
                    height: 50,
                    minWidth: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Text(
                        '매칭시작',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.greenAccent,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.close,color: Colors.white,),
                                          backgroundColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    ListView(
                                      children: <Widget>[
                                        Text('asdasd'),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Color(0xff232f34),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 36,
                ),
                SizedBox(
                    height: (56 * 6).toDouble(),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          color: Color(0xff344955),
                        ),
                        child: Stack(
                          alignment: Alignment(0, 0),
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              top: -36,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        color: Color(0xff232f34), width: 10)),
                                child: Center(
                                  child: ClipOval(
                                    child: Image.network(
                                      "https://i.stack.imgur.com/S11YG.jpg?s=64&g=1",
                                      fit: BoxFit.cover,
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Inbox",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.inbox,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Starred",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.star_border,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Sent",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Trash",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Spam",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.error,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Drafts",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      Icons.mail_outline,
                                      color: Colors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
                Container(
                  height: 56,
                  color: Color(0xff4a6572),
                )
              ],
            ),
          );
        });
  }
}

Future<void> _signOut() async {
  await _auth.signOut();
}
