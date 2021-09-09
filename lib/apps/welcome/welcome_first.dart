import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/welcome/home_screen.dart';
import 'package:genius/apps/welcome/home_screen_v2.dart';
import 'package:genius/apps/welcome/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeFirst extends StatefulWidget {
  WelcomeFirst({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _WelcomeFirstState createState() => _WelcomeFirstState();
}

class _WelcomeFirstState extends State<WelcomeFirst> {
  bool loading = true;
  bool loggedIn = false;
  @override
  void initState() {
    super.initState();
    _isLogin();
  }

  Future _isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') != null) {
      setState(() {
        loggedIn = true;
      });
    }
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (c) => loggedIn ? HomeScreenV2() : SigninScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light));
    return Scaffold(
        backgroundColor: Color(0xff180524),
        body: Stack(
          children: <Widget>[
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.width *
                    0.32, 
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AvatarGlow(
                            glowColor: Colors.white,
                            endRadius: 200.0,
                            duration: Duration(milliseconds: 1000),
                            repeat: true,
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 0),
                            child: Material(
                              elevation: 8.0,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      AssetImage('assets/img/logo.png')),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Welcome To HGU Services",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'calibri',
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text("HR Genius Utility",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontFamily: 'calibri',
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 40,
                        ),
                        loading
                            ? Text("")
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SigninScreen()));
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.9,
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.width /
                                                40),
                                    margin: EdgeInsets.all(0.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey.shade200,
                                              offset: Offset(2, 4),
                                              blurRadius: 5,
                                              spreadRadius: 2)
                                        ],
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color(0xff75379e),
                                              Color(0xff3c379e)
                                            ])),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Center(
                                            child: new Text('Get Started',
                                                style: new TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.white,
                                                ))),
                                        new Center(
                                            child: new Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 25.0,
                                          color: Colors.white,
                                        ))
                                      ],
                                    )))
                      ]),
                ))
          ],
        ));
  }
}
