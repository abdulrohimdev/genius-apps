import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/chating/Chating.dart';
import 'package:genius/apps/module/news/News.dart';
import 'package:genius/apps/module/profile/profile_account.dart';
import 'package:genius/apps/welcome/welcome_first.dart';
import 'package:genius/apps/welcome/welcome_first_rev.dart';
import 'package:genius/services/Network.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:genius/apps/chating/Chating.dart';
import 'package:genius/apps/module/request/RequestLeaveDetail.dart';
import 'package:genius/model/ApplicationModel.dart';
import 'package:genius/services/Notification.dart';
import 'package:shimmer/shimmer.dart';
import '../../services/Network.dart';
import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({Key key}) : super(key: key);

  @override
  _HomeScreenV2State createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2> {
  int counting = 0;
  dynamic imgList = [];

  Widget _carouselCard(){
    return shimmer(Card(
      child: Container(
        color: Color(0xffdddddd),
        height: 200,
      ),
    ));
  }

  Widget _carousel(index, result) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => News(
                          data: result[index],
                        ))).then((value) {
              getModule();
              getPending();
              getVersion();
              getNews();
              // getBirthdayEuclid();
            });
          },
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: result[index]['image_uri'],
                      placeholder: (context, url) => Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          strutStyle: StrutStyle(fontSize: 20.0),
                          text: TextSpan(
                            text: result[index]['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    var response = await Network().getData('common/current-version-mobile');
    var body = json.decode(response.body);
    var version_update = body['version']['version'];
    if (version != version_update) {
      print(version);
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

  bool loading = true;

  Widget buildBirthday(index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: Color(0xffff4133),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: loading
              ? shimmer(CircleAvatar(radius: 27))
              : CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: Image.memory(base64.decode(listBirthday[index]['photo'].toString())).image,
                  ),
                ),
          title: loading
              ? shimmer(Card(child: Container(width: 100, height: 10)))
              : Text(
                  listBirthday[index]['fullname'],
                  style: GoogleFonts.lato(color: Colors.white),
                ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              loading
                  ? shimmer(Card(child: Container(width: 150, height: 10)))
                  : Text(listBirthday[index]['company_name'],
                      style: GoogleFonts.lato(color: Colors.white)),
              loading
                  ? shimmer(Card(child: Container(width: 70, height: 10)))
                  : Text("${listBirthday[index]['divisi']} ${listBirthday[index]['department']}",
                      style: GoogleFonts.lato(color: Colors.white)),
            ],
          ),
          trailing: loading
              ? shimmer(Card(child: Container(width: 20, height: 20)))
              : Icon(
                  Icons.cake,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }

  Widget _buildMenuShimer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        shimmer(CircleAvatar(radius: 17)),
        SizedBox(
          height: 5,
        ),
        shimmer(Card(
          child: Container(width: 30, height: 10),
        )),
      ],
    );
  }

  Widget _buildMenu(int index, result) {
    var page = result['app_route_frontend_mobile'];
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, page).whenComplete(() {
          getModule();
          getVersion();
          getPending();
          getNews();
        })
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loading
              ? shimmer(CircleAvatar(radius: 17))
              : CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/icon_menu/${result['app_icon_image']}'),
                  radius: 17,
                ),
          SizedBox(
            height: 5,
          ),
          loading
              ? shimmer(Card(
                  child: Container(width: 30, height: 10),
                ))
              : Text(
                  "${result['app_name']}",
                  style: TextStyle(fontSize: 11, color: Color(0xff333333)),
                  textAlign: TextAlign.center,
                ),
        ],
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

  String firstname = "";

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
        var name = fullname.split(' ');
        firstname = name[0];
        employeeid = data['profile']['employeeid'];
        image = data['profile']['photo'].toString();
        photo = base64.decode(data['profile']['photo'].toString());
        isImage = true;
        loading = false;
      });
    }
  }

  void getNews() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await Network().getData('common/news');
      print(response.statusCode);
      dynamic data = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          imgList = data['data'];
          loading = false;
        });
      }
    } catch (Exception) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          btnOkText: "Try again",
          btnCancelText: "Cancel",
          dismissOnTouchOutside: false,
          title: 'Error',
          desc: Exception.message,
          btnOkOnPress: () {},
          btnCancelOnPress: () {},
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    }
  }

  dynamic listBirthday = [];
  void getBirthday() async {
    setState(() {
      loading = true;
    });
    try {
      var response = await Network().getData('common/birthday');
      print(response.statusCode);
      dynamic data = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          listBirthday = data['data'];
          loading = false;
        });
      }
    } catch (Exception) {
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          btnOkText: "Try again",
          btnCancelText: "Cancel",
          dismissOnTouchOutside: false,
          title: 'Error',
          desc: Exception.message,
          btnOkOnPress: () {},
          btnCancelOnPress: () {},
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    }
  }

  // Future getBirthdayEuclid() async{
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     var response = await Network().getOriginal('hris.dharmap.com','txn?fnc=runLib;opic=kMwKyTP7zw16NWbPMoLaMw;csn=P04;rc=XeK6Oco4vot6H0JjiqhI8muELKwEyRoM');
  //     dynamic data = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         // listBirthday = data['data'];
  //         print(data);
  //         loading = false;
  //       });
  //     }
  //   } catch (Exception) {
  //     AwesomeDialog(
  //         context: context,
  //         animType: AnimType.TOPSLIDE,
  //         headerAnimationLoop: false,
  //         dialogType: DialogType.ERROR,
  //         showCloseIcon: true,
  //         btnOkText: "Try again",
  //         btnCancelText: "Cancel",
  //         dismissOnTouchOutside: false,
  //         title: 'Error',
  //         desc: Exception.message,
  //         btnOkOnPress: () {},
  //         btnCancelOnPress: () {},
  //         btnOkIcon: Icons.check_circle,
  //         onDissmissCallback: (type) {
  //           debugPrint('Dialog Dissmiss from callback $type');
  //         })
  //       ..show();
  //   }

  // }

  FirebaseMessaging fr = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      getVersion();
      registerAppId();
      getModule();
      getNews();
      getPending();
      getBirthday();
      // getBirthdayEuclid();
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
          return HomeScreenV2();
        }));
      }
    });

    int count = 1;
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
          appBar: AppBar(
            backwardsCompatibility: false,
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
            title: Text(
              "Beranda",
              style: TextStyle(fontFamily: "calibri"),
            ),
            centerTitle: true,
            elevation: 0.0,
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 20.0, top: 15),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Chating())).then((value) {
                          getModule();
                          getPending();
                          getVersion();
                          // getBirthdayEuclid();
                          getNews();
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
                                      size: 8.0, color: Color(0xfff5845b)),
                                )
                              : Text(''),
                        ],
                      ))),
            ],
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xff180524),
                statusBarIconBrightness: Brightness.light),
            backgroundColor: Color(0xff180524),
          ),
          backgroundColor: Color(0xff180524),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to leave'),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff180524),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(70))),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              loading
                                  ? shimmer(Card(
                                      child: Container(width: 120, height: 25),
                                    ))
                                  : AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          'Hai ${firstname}',
                                          textStyle: const TextStyle(
                                            fontSize: 25.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 100),
                                        ),
                                      ],
                                      totalRepeatCount: 4,
                                      pause: const Duration(milliseconds: 3000),
                                      displayFullTextOnTap: true,
                                      stopPauseOnTap: true,
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              loading
                                  ? shimmer(Card(
                                      child: Container(width: 250, height: 15),
                                    ))
                                  : AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          'Selamat datang di aplikasi HGU!',
                                          textStyle: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          speed:
                                              const Duration(milliseconds: 100),
                                        ),
                                      ],
                                      totalRepeatCount: 4,
                                      pause: const Duration(milliseconds: 1000),
                                      displayFullTextOnTap: true,
                                      stopPauseOnTap: true,
                                    ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AccountProfile())).then((value) {
                                getModule();
                                getPending();
                                getVersion();
                                // getBirthdayEuclid();
                                getNews();
                              });
                            },
                            child: AvatarGlow(
                              endRadius: 35.0,
                              child: Material(
                                elevation: 8.0,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Colors.white,
                                  child: loading
                                      ? shimmer(CircleAvatar(radius: 25))
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundImage: image != ''
                                              ? Image.memory(photo).image
                                              : AssetImage(
                                                  'assets/img/default.jpg'),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 50),
                        decoration: BoxDecoration(
                            color: Color(0xfffcfcfc),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                topRight: Radius.circular(0))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Menu",
                                style: GoogleFonts.lato(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Container(
                              height: 80,
                              child: loading
                                  ? GridView.count(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 15,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: List.generate(6, (index) {
                                        return _buildMenuShimer();
                                      }))
                                  : GridView.count(
                                      crossAxisCount: 1,
                                      mainAxisSpacing: 15,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children:
                                          List.generate(result.length, (index) {
                                        return _buildMenu(index, result[index]);
                                      })),
                            ),
                            Divider(),
                            SizedBox(height: 20),
                            Text(
                              "Berita",
                              style: GoogleFonts.lato(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: loading ? _carouselCard() : CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 2.0,
                                  enlargeCenterPage: true,
                                ),
                                items: List.generate(imgList.length, (index) {
                                  return _carousel(index, imgList);
                                }),
                              ),
                            ),
                            // sample
                            SizedBox(height: 20),
                            Text(
                              "Selamat ulang tahun",
                              style: GoogleFonts.lato(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: loading ? CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 3.5,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  scrollDirection: Axis.vertical,
                                  enlargeCenterPage: true,
                                ),
                                items: List.generate(6, (index) {
                                  return buildBirthday(index);
                                }),
                              ) : CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  aspectRatio: 3.5,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  scrollDirection: Axis.vertical,
                                  enlargeCenterPage: true,
                                ),
                                items: List.generate(listBirthday.length, (index) {
                                  return buildBirthday(index);
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
