import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/chating/Chating.dart';
import 'package:genius/apps/module/profile/profile_zoom.dart';
import 'package:genius/apps/module/request/RequestLeaveDetail.dart';
import 'package:genius/apps/sosmed/sosmed_chat.dart';
import 'package:genius/apps/welcome/home_screen_v2.dart';
import 'package:genius/model/ApplicationModel.dart';
import 'package:genius/services/Notification.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/Network.dart';
import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    var response = await Network().getData('common/current-version-mobile');
    var body = json.decode(response.body);
    var version_update = body['version']['version'];
    if (version != version_update) {
      AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.WARNING,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          btnOkText: 'Update',
          title: 'Anda menggunakan versi ${version}',
          desc: "Segera update versi mobile ke ${version_update} di playstore",
          btnOkOnPress: () {
            StoreRedirect.redirect(androidAppId: "com.hgu.id");
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    }
  }

  Widget alertModal() {
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("This function On Progress"),
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

  bool loading = true;

  Widget buildCard(index, result) {
    var page = result['app_route_frontend_mobile'];
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, page).whenComplete(() {
          getModule();
          getVersion();
          getPending();
        })
      },
      child: Card(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon_menu/${result['app_icon_image']}',
              fit: BoxFit.contain,
              width: 25,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${result['app_name']}",
              style: TextStyle(fontSize: 10, fontFamily: 'calibri'),
              textAlign: TextAlign.center,
            )
          ],
        )),
      ),
    );
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
                new Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  dynamic result = [];
  String company = "";
  String fullname = "";
  String employeeid = "";
  Uint8List photo;
  String image;
  bool isImage = false;

  int counting;
  getPending() async {
    var response = await Network().post({}, 'hr/leave/leave-pending');
    dynamic data = json.decode(response.body);
    if (data['status'] == true) {
      setState(() {
        counting = data['data'];
        print(counting);
      });
    }
  }

  void registerAppId() async {
    var token = await fr.getToken();
    print(token);
    var response = await Network().post({"deviceId": token}, 'register-app-id');
    dynamic data = json.decode(response.body);
    if (data['status'] == true) {
      setState(() {
        print(data['message']);
      });
    }
  }

  Future<ApplicationModel> getModule() async {
    setState(() {
      loading = true;
    });
    var response = await Network().post({}, "access-module/false/8");
    dynamic data = json.decode(response.body);
    if (data['status'] == true) {
      setState(() {
        result = data['program']['data'];
        company = data['profile']['company'];
        fullname = data['profile']['fullname'];
        employeeid = data['profile']['employeeid'];
        image = data['profile']['photo'].toString();
        photo = base64.decode(data['profile']['photo'].toString());
        isImage = true;
        loading = false;
      });
    }
  }

  FirebaseMessaging fr = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      getVersion();
      registerAppId();
      getModule();
      getPending();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);
      NotificationPush().initialization(
          context, message.data['screen'], message.data['arguments']);
      var id = int.parse(message.data['id']);
      NotificationPush().showNotification(id, message.notification.title,
          message.notification.body, message.data['hash_id']);
      getPending();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var data = message.data;
      if (data['screen'] == '/request_leave_detail') {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return RequestLeaveDetail(id: data['arguments']);
        }));
      } else {
        Navigator.of(this.context).push(MaterialPageRoute(builder: (_) {
          return HomeScreen();
        }));
      }
    });

    int count = 1;
  }

  Widget getBody(context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width,
                color: Colors.purple[700],
                alignment: Alignment.topCenter,
                child: Text(
                  'Welcome',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )),
              Positioned(
                  top: 30,
                  left: 30,
                  right: 30,
                  bottom: 30,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileImage(
                                          fullname: fullname,
                                          image: image,
                                        )));
                          },
                          child: loading
                              ? shimmer(CircleAvatar(radius: 80))
                              : GestureDetector(
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundColor: Color(0xffdddddd),
                                    backgroundImage: image != ''
                                        ? Image.memory(photo).image
                                        : AssetImage('assets/img/default.jpg'),
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        loading
                            ? shimmer(Text('Loading...'))
                            : Text(fullname ?? '',
                                style: TextStyle(
                                    color: Color(0xff444444),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 5,
                        ),
                        loading
                            ? shimmer(Text("Loading..."))
                            : Text('ID : ${employeeid ?? ''}',
                                style: TextStyle(
                                    fontFamily: 'calibri',
                                    color: Color(0xff777777),
                                    fontSize: 13)),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                children: List.generate(result.length, (index) {
                  return loading
                      ? shimmer(Card(
                          child: Text("Loading..."),
                        ))
                      : buildCard(index, result[index]);
                })),
          ),
        ),
      ],
    );
  }

  Widget shimmer(widget) {
    return Shimmer.fromColors(
        child: widget,
        baseColor: Color(0xffd4d2d2),
        highlightColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.purple[700],
                statusBarIconBrightness: Brightness.light),
            centerTitle: false,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                FirebaseMessaging.instance.deleteToken();
                Network().logout(context);
              },
              child: Icon(
                Icons.logout,
              ),
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 10.0, top: 15),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreenV2(
                                        )))
                            .then((value) => getPending());
                        // Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (BuildContext context) =>
                        //                 SosmedChat(
                        //                   photo: this.photo,
                        //                 )))
                        //     .then((value) => getPending());
                      },
                      child: Stack(
                        children: [
                          Icon(Icons.chat_bubble_outline_outlined)
                          // Positioned(
                          //   top: 0.0,
                          //   right: 2.0,
                          //   child: new Icon(Icons.brightness_1,
                          //       size: 8.0, color: Color(0xfff0ff19)),
                          // )
                        ],
                      ))),
              Padding(
                  padding: EdgeInsets.only(right: 12.0, top: 15),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Chating())).then((value) {
                          getPending();
                        });
                      },
                      child: Stack(
                        children: [
                          Icon(Icons.notifications_none_outlined),
                          counting != 0
                              ? Positioned(
                                  top: 0.0,
                                  right: 0.0,
                                  child: new Icon(Icons.brightness_1,
                                      size: 8.0, color: Color(0xfff0ff19)),
                                )
                              : Text(''),
                        ],
                      ))),
            ],
            backgroundColor: Colors.purple[700],
          ),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
            ),
            child: getBody(context),
          )),
    );
  }
}
