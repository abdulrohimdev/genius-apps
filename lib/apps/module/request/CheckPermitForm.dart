import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/module/request/ListRequest.dart';
import 'package:genius/apps/module/request/security_check_leave/ByInputNumber.dart';
import 'package:genius/apps/module/request/security_check_leave/ByScanner.dart';

class CheckPermitForm extends StatefulWidget {
  const CheckPermitForm({Key key}) : super(key: key);

  @override
  _CheckPermitFormState createState() => _CheckPermitFormState();
}

class _CheckPermitFormState extends State<CheckPermitForm> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          // backgroundColor: Color(0xfff2f2f0),
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.input, color: Colors.black)),
                Tab(icon: Icon(Icons.qr_code_scanner, color: Colors.black))
              ],
            ),
            centerTitle: false,
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark),
            title: Text('Pemeriksaan Karyawan',
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ListRequest()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.list_alt,
                  ),
                ),
              )
            ],
            backgroundColor: Colors.white,
          ),
          body: TabBarView(
            children: [
              ByInputNumber(),
              ByScanner(),
            ],
          )),
    );
  }
}
