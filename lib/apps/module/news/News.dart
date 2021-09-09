import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class News extends StatefulWidget {
  const News({Key key, this.data}) : super(key: key);
  final dynamic data;
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        title: Text('${widget.data['title']}',
            style: TextStyle(
                fontFamily: "calibri", color: Colors.black, fontSize: 25)),
        elevation: 0.0,
        titleSpacing: 0.0,
        leadingWidth: 80,
        iconTheme: IconThemeData(color: Color(0xff333333)),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                  imageUrl: widget.data['image_uri'],
                  placeholder: (context, url) => Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 1000.0),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left:10,right:10),
                width: MediaQuery.of(context).size.width,
                color: Color(0xff000000),
                child: Text("Posted : ${widget.data['created_at']}",style: GoogleFonts.newsCycle(fontSize: 14,color:Colors.white,fontWeight: FontWeight.normal),),),
              Container(
                padding: EdgeInsets.only(left:10,top:1,right:10,bottom:5),
                width: MediaQuery.of(context).size.width,
                color: Color(0xfff5f5f5f5),
                child: Text(widget.data['title'],style: GoogleFonts.newsCycle(fontSize: 25,fontWeight: FontWeight.bold),),),
              Container(
                padding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Text(widget.data['subtitle'],
                style: GoogleFonts.newsCycle(fontSize: 23,wordSpacing: 0,letterSpacing: 0),),),
              Divider(),
              Container(
                padding: EdgeInsets.only(left:10,top:5,right:10,bottom:5),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Text(widget.data['description'],
                style: GoogleFonts.newsCycle(fontSize: 23,wordSpacing: 0,letterSpacing: 0),),),
            ],
          ),
        ),
      ),
    );
  }
}
