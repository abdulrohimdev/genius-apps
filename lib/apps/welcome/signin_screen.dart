import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/welcome/home_screen.dart';
import 'package:genius/apps/welcome/home_screen_v2.dart';
import 'package:package_info/package_info.dart';
import 'dart:convert';
import '../../services/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final username = TextEditingController();
  static SharedPreferences prefs;

  void _submit() async {
    if (_formKey.currentState.validate()) {
      EasyLoading.show(status: 'Authenticating...');
      var body = {
        "userid": username.text,
        "userpass": password.text,
      };
      var response = await Network().signin(body, 'oauth');
      var result = json.decode(response.body);
      if (response.statusCode == 200) {
        if (result['status'] == true) {
          prefs = await SharedPreferences.getInstance();
          EasyLoading.dismiss();
          final snackBar = SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          prefs.setBool("isLogedIn", true);
          prefs.setString("apikey", result['apikey']);
          prefs.setString("secretkey", result['secretkey']);
          prefs.setString("empid", result['employee_id']);
          prefs.setString("fullname", result['fullname']);
          Future.delayed(Duration(seconds: 0)).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreenV2()),
            );
          });
        } else {
          EasyLoading.dismiss();
          final snackBar = SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        EasyLoading.dismiss();
        final snackBar = SnackBar(
          content: Text("No internet access or server down!"),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget alertModal(message) {
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          child: Text("Oke"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 100,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(height: 20),
                new Text("Authenticating..."),
              ],
            ),
          ),
        );
      },
    );
  }

  String version = "1.0";
  getVersion() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
     version = packageInfo.version;          
    });
  }

  @override
  void initState() {
    EasyLoading.instance..dismissOnTap = true;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);
    
    // TODO: implement initState
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Stack(children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/img/bg4.png'),
                                    fit: BoxFit.fill)),
                            child: Stack(
                              children: [
                                Positioned(
                                    left: 30,
                                    top: 30,
                                    child: Container(
                                        child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'HR Genius Utility',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 28),
                                      ),
                                    ))),
                                Positioned(
                                    left: 30,
                                    top: 70,
                                    child: Container(
                                      child: Text(
                                        'Selamat datang di aplikasi HGU',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            padding: EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Masuk',
                                  style: TextStyle(
                                      color: Color(0xff505152), fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  controller: username,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan User ID anda!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'User ID',
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(13, 13, 13, 13),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Colors.black26, //this has no effect
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  controller: password,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan Kata sandi anda!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Kata sandi',
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(13, 13, 13, 13),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Colors.black26, //this has no effect
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      return _submit();
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .width /
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
                                                child: new Text('Masuk ke aplikasi',
                                                    style: new TextStyle(
                                                      fontSize: 17.0,
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
                              ],
                            ),
                          ),
                          Text("The Enterprise Application System"),
                          Text("Version ${version.toString()}"),
                          // Container(
                          //   margin: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.18),
                          //   height: 120,
                          //   decoration: BoxDecoration(
                          //       image: DecorationImage(
                          //           image:
                          //               AssetImage('assets/img/bg-bottom.png'),
                          //           fit: BoxFit.fill)),
                          // )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            )),
        onWillPop: () async {
          exit(0);
          // return (true);
        });
  }
}
