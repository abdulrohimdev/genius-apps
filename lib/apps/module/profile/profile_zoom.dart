import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ProfileImage extends StatefulWidget {
    ProfileImage({Key key, this.fullname,this.image}) : super(key: key);
    final String fullname;
    final String image;
  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {

  String fullname = "Loading...";
  Uint8List image;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      fullname = widget.fullname;
      image = base64.decode(widget.image);
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
        title: Text(fullname,
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