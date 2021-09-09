import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ShowImageSingle extends StatefulWidget {
  ShowImageSingle({Key key, this.title, this.image,this.casetype,this.quantity,this.note}) : super(key: key);
  final String title;
  final String casetype;
  final String quantity;
  final String note;
  final Uint8List image;

  @override
  _ShowImageSingleState createState() => _ShowImageSingleState();
}

class _ShowImageSingleState extends State<ShowImageSingle> {
  String title = "Loading...";
  Uint8List image;
  String casetype = "Loading...";
  String quantity = "Loading...";
  String note = "Loading...";


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      this.title = widget.title;
      this.image = widget.image;
      this.casetype = widget.casetype;
      this.quantity = widget.quantity;
      this.note = widget.note;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light),
        centerTitle: false,
        title: Text(title,
            style: TextStyle(fontFamily: "calibri", color: Colors.white)),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_outlined, // add custom icons also
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
          child: PinchZoom(
            image: Image.memory(image),
            zoomedBackgroundColor: Colors.black.withOpacity(0.5),
            resetDuration: const Duration(milliseconds: 100),
            maxScale: 2.5,
            onZoomStart: () {
              print('Start zooming');
            },
            onZoomEnd: () {
              print('Stop zooming');
            },
          )),
    );
  }
}
