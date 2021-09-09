import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/module/profile/profile_zoom.dart';
import 'package:genius/services/Network.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SecurityApproval extends StatefulWidget {
  const SecurityApproval({Key key, this.data, this.title}) : super(key: key);

  final dynamic data;
  final String title;

  @override
  _SecurityApprovalState createState() => _SecurityApprovalState();
}

class _SecurityApprovalState extends State<SecurityApproval> {
  dynamic data = [];

  Widget _buttonAcceptable() {
    if (data['security_check_leave'] == null &&
        data['security_check_return'] == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Text(
              'Cek karyawan keluar',
              style: TextStyle(color: Colors.white),
            ),
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {
              securityAcction();
            },
          ),
          SizedBox(width: 10.0,),
          TextButton(
            child: Text(
              'Cek karyawan masuk',
              style: TextStyle(color: Colors.white),
            ),
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffffbcb8))),
            onPressed: () {
              // securityAcction();
            },
          ),
        ],
      );
    } 
    else if(data['security_check_leave'] != null &&
        data['security_check_return'] == null){
        return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Text(
              'Cek karyawan keluar',
              style: TextStyle(color: Colors.white),
            ),
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffffbcb8))),
            onPressed: () {
              // securityAcction();
            },
          ),
          SizedBox(width: 10.0,),
          TextButton(
            child: Text(
              'Cek karyawan masuk',
              style: TextStyle(color: Colors.white),
            ),
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
            onPressed: () {
              securityAcction();
            },
          ),
        ],
      );  
    }
    else {
      return Text("");
    }
  }

  void securityAcction() async {
    EasyLoading.show(status: 'Mengirim persetujuan...');
    var response = await Network().post(
        {"number_unix": data['number_unix']}, 'hr/leave/leave-security-action');
    var result = json.decode(response.body);
    if (result['status'] == true) {
      EasyLoading.dismiss();
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: true,
          dialogType: DialogType.SUCCES,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          title: 'Sukses menyetujui',
          desc: 'Silahkan klik tombol OK',
          btnOkOnPress: () {
            Navigator.pop(context, true);
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();

      setState(() {
        data['security_check_leave'] = result['data']['security_check_leave'];
        data['security_check_return'] = result['data']['security_check_return'];
      });
    }
  }

  Widget _alertSuccess() {
    return AnimatedButton(
      text: 'Succes Dialog',
      color: Colors.green,
      pressEvent: () {
        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            title: 'Succes',
            desc:
                'Dialog description here..................................................',
            btnOkOnPress: () {
              debugPrint('OnClick');
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.instance..dismissOnTap = true;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);

    setState(() {
      data = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Color(0xfff2f2f0),
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          title: Text('${widget.title}',
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
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buttonAcceptable(),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text("Dibuat oleh"),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProfileImage(
                                              fullname: data['fullname'],
                                              image: data['photo'])));
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: data['photo'] != null || data['photo'] == ''
                                  ? Image.memory(base64
                                          .decode(data['photo'].toString()))
                                      .image
                                  : AssetImage('assets/img/default.jpg'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text("Disetujui oleh"),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProfileImage(
                                              fullname: data['approval'],
                                              image: data['photo_approval'])));
                            },
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: data['photo_approval'] != ''
                                  ? Image.memory(base64.decode(
                                          data['photo_approval'].toString()))
                                      .image
                                  : AssetImage('assets/img/default.jpg'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nama lengkap",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text(data['fullname']),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NPK",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text(data['request_user_empid']),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Divisi/Dept",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['divisi']} / ${data['department']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Jenis Izin",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['request_type']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Meninggalkan pekerjaan jam",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['request_time_leaving']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kembali ke-perusahaan jam",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['request_time_returning']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dicek security pada saat keluar:",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['security_check_leave']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dicek security pada saat kembali:",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['security_check_return']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dibuat tanggal",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['request_date']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Disetujui Oleh",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['approval']}"),
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        "Alasan :",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      Text("${data['request_reason']}"),
                      SizedBox(
                        height: 30.0,
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
