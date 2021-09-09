import 'package:flutter/material.dart';

class PageNotFound extends StatefulWidget {
  @override
  _PageNotFoundState createState() => _PageNotFoundState();
}

class _PageNotFoundState extends State<PageNotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        // title: Text("Back",
        //     style: TextStyle(fontFamily: "calibri", color: Colors.black)),
        elevation: 0.0,
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
        child: Center(child: Text("Page Not Found OR On Progress"),),
      ),
    );
  }
}