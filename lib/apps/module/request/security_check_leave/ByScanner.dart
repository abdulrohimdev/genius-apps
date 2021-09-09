import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/module/request/SecurityApproval.dart';
import 'package:genius/services/Network.dart';
import 'package:qrscan/qrscan.dart' as myscanner;
import 'package:permission_handler/permission_handler.dart';

class ByScanner extends StatefulWidget {
  const ByScanner({Key key}) : super(key: key);

  @override
  _ByScannerState createState() => _ByScannerState();
}

class _ByScannerState extends State<ByScanner> {
  String cameraScanResult;

  @override
  initState() {
    super.initState();
    EasyLoading.instance..dismissOnTap = true;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);
    scanner();
  }

  Future scanner() async {
    await Permission.camera.request();
    cameraScanResult = await myscanner.scan();
    if (cameraScanResult == null) {
      Navigator.pop(context);
    } else {
      EasyLoading.show(status: "Loading...");
      var response = await Network().post(
          {"number_unix": cameraScanResult}, "hr/leave/leave-search-unix");
      dynamic result = json.decode(response.body);
      print(result['data'].length);
      if (response.statusCode == 200) {
        if (result['data'].length > 0 &&
            result['data'][0]['status'] == 'Approved') {
          EasyLoading.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => SecurityApproval(
                        title:
                            "${result['data'][0]['fullname']} (${result['data'][0]['request_user_empid']})",
                        data: result['data'][0],
                      )));
        } else {
          EasyLoading.dismiss();
          AwesomeDialog(
              context: context,
              animType: AnimType.TOPSLIDE,
              headerAnimationLoop: true,
              dialogType: DialogType.ERROR,
              showCloseIcon: false,
              dismissOnTouchOutside: false,
              title: 'Maaf!',
              desc:
                  'Mungkin data tersebut belum di setujui pimpinan atau memang datanya tidak ada!',
              btnOkOnPress: () {},
              btnCancelIcon: Icons.cancel_outlined,
              onDissmissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              })
            ..show();
        }
      } else {
        EasyLoading.dismiss();
        AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            headerAnimationLoop: true,
            dialogType: DialogType.ERROR,
            showCloseIcon: false,
            dismissOnTouchOutside: false,
            title: 'Maaf!',
            desc: 'Mungkin terjadi error!',
            btnOkOnPress: () {},
            btnCancelIcon: Icons.cancel_outlined,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: GestureDetector(
        onTap: () {
          scanner();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/scann_img.png'),
            SizedBox(
              height: 10,
            ),
            Text("Tap gambar scanner untuk melakukan scan"),
          ],
        ),
      ),
    ));
  }
}
