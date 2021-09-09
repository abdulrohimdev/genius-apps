import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/module/request/RequestLeaveDetail.dart';
import 'package:genius/services/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Chating extends StatefulWidget {
  @override
  _ChatingState createState() => _ChatingState();
}

class _ChatingState extends State<Chating> {
  bool isSearching = false;
  TextEditingController request = new TextEditingController();
  var data = [];
  bool loading = false;
  Future getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = true;
      selectedData = [];
    });
    try{
      var response = await Network().post(
          {'approved_by': prefs.getString('empid')},
          'hr/leave/leave-list-request');
      var result = json.decode(response.body);
      if(response.statusCode == 200){
        if (result['status'] == true) {
          setState(() {
            data = result['data'];
            selectedData = data;
            loading = false;
          });
        }
      }
    }catch(Exception){
      setState(() {
        loading = false;
        selectedData = [];              
      });
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
          btnOkOnPress: () {
            getData();
          },
          btnCancelOnPress: () {
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    }

  }

  Widget _searching() {
    return TextFormField(
      controller: request,
      cursorColor: Colors.black,
      style: TextStyle(fontSize: 20.0),
      autofocus: true,
      autocorrect: true,
      onChanged: (value) {
        this.setState(() {
          selectedData = data
              .where((list) =>
                  list['name'].toLowerCase().contains(value.toLowerCase()))
              .toList();
          if (selectedData.length == 0) {
            selectedData = data
                .where((list) =>
                    list['status'].toLowerCase().contains(value.toLowerCase()))
                .toList();
          }
        });
      },
      decoration: new InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: "Cari ..."),
    );
  }

  Widget _btnSearch() {
    return GestureDetector(
      onTap: () {
        this.setState(() {
          this.isSearching = true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(
          Icons.search,
        ),
      ),
    );
  }

  Widget _btnClose() {
    return GestureDetector(
      onTap: () {
        this.setState(() {
          this.isSearching = false;
          request.text = "";
          selectedData = data;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(
          Icons.close,
        ),
      ),
    );
  }

  var selectedData = [];
  @override
  void initState() {
    super.initState();
    getData();
    // customBoxWaitAnimation=new AnimationController(duration: const Duration(milliseconds: 1000*100), vsync: this);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      getData();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getData();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      getData();
    });
  }

  Widget listTile(index) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RequestLeaveDetail(
                      id: selectedData[index]['request_hash_id'],
                    ))).then((value) {
          getData();
        });
      },
      tileColor: selectedData[index]['status'] == 'Pending'
          ? Color(0xffe0d4ff)
          : Colors.white,
      title: Text(
        '${selectedData[index]['name']}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Container(
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 12.0),
          text: TextSpan(
              style: TextStyle(color: Colors.black),
              text: '${selectedData[index]['message']}'),
        ),
      ),
      isThreeLine: true,
    );
  }

  Widget content() {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return listTile(index);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: selectedData.length);
  }

  Widget shimmer(widget) {
    return Shimmer.fromColors(
        child: widget,
        baseColor: Color(0xffd4d2d2),
        highlightColor: Colors.white);
  }

  Widget _cardFake() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmer(Card(
            child: Text("loading untuk nama dan tanggal aksjgaksg ka"),
          )),
          shimmer(Card(
            child: Text("loading untuk nama dan"),
          )),
          shimmer(Card(
            child:
                Text("loading data deskripsii sampai mentok ini messagenya ya"),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          title: isSearching
              ? _searching()
              : Text('Notifikasi izin',
                  style: TextStyle(fontFamily: "calibri", color: Colors.black)),
          elevation: 1.0,
          iconTheme: IconThemeData(color: Color(0xff333333)),
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_outlined, // add custom icons also
            ),
          ),
          actions: [
            isSearching ? _btnClose() : _btnSearch(),
          ],
          backgroundColor: Colors.white,
        ),
        body: Container(
            child: loading
                ? ListView(
                    children: [
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                      _cardFake(),
                    ],
                  )
                : RefreshIndicator(child: content(), onRefresh: getData)));
  }
}
