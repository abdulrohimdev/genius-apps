import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/module/request/SecurityApproval.dart';
import 'package:genius/services/Network.dart';
import 'package:qrscan/qrscan.dart' as myscanner;

class QrCodeGenearate extends StatefulWidget {
  const QrCodeGenearate({ Key key,this.code}) : super(key: key);

  final String code;
  @override
  _QrCodeGenearateState createState() => _QrCodeGenearateState();
}

class _QrCodeGenearateState extends State<QrCodeGenearate> {
  Uint8List bytes = Uint8List(0);

  Future _generateBarCode(String inputCode) async {
    Uint8List result = await myscanner.generateBarCode(inputCode);
    this.setState(() => this.bytes = result);
  }

  @override
    void initState() {
      super.initState();
      this._generateBarCode(widget.code);
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
          title: Text('Your QR Code ',
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
        body: Container(
           padding: EdgeInsets.all(80.0),
            child : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.memory(Uint8List.fromList(bytes)),
                SizedBox(height:20.0),
                Text("Berikan QR ini di security untuk di scanning",textAlign: TextAlign.center,)
              ],
            )
          ),
      );
  }
}