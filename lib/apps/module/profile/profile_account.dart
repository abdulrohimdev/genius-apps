// import 'dart:html';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:genius/apps/module/profile/profile_zoom.dart';
import 'package:genius/services/Network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:genius/apps/module/profile/edit_password.dart';

class AccountProfile extends StatefulWidget {
  @override
  _AccountProfileState createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile> {
  bool floating = false;

  String image;
  bool loadImage = true;
  bool loading = true;
  Uint8List photo;
  bool isImage = false;

  Future<void> cameraConnect(source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    final isFile = await compress(File(pickedFile.path));
    String base64 = base64Encode(isFile);
    return imageUpdate(base64);
  }

  Future<Uint8List> compress(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 10,
    );
    return result;
  }

  Future<dynamic> imageUpdate(String source) async {
    setState(() {
      loadImage = true;
    });
    final response =
        await Network().post({"image": source}, "update-photo-profile");
    dynamic data = json.decode(response.body);
    if (data['status'] == true) {
      setState(() {
        image = source;
        photo = base64.decode(data['photo'].toString());
        loadImage = false;
        isImage = true;
        floating = false;
      });
    } else {
      setState(() {
        loadImage = false;
        floating = false;
      });
    }
  }

  Widget shimmer(widget) {
    return Shimmer.fromColors(
        child: widget,
        baseColor: Color(0xffd4d2d2),
        highlightColor: Colors.white);
  }

  dynamic profile = [];

  Future<dynamic> getProfile() async {
    final response = await Network().post({}, "profile");
    dynamic data = json.decode(response.body);
    if (data['status'] == true) {
      setState(() {
        image = data['data']['photo'];
        profile = data['data'];
        photo = base64.decode(image);
        loadImage = false;
        loading = false;
      });
    } else {
      setState(() {
        loadImage = false;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      loadImage = true;
      getProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        title: Text("Akun saya",
            style: TextStyle(fontFamily: "calibri", color: Colors.black)),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Column(children: [
            loadImage
                ? shimmer(CircleAvatar(radius: 100))
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProfileImage(
                                  fullname: profile['fullname'],
                                  image: image)));
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: image != ''
                          ? Image.memory(photo).image
                          : AssetImage('assets/img/default.jpg'),
                    ),
                  ),
            TextButton(
                onPressed: () {
                  setState(() {
                    floating = true;
                  });
                },
                child: Text("Ubah poto profil")),
            SizedBox(
              height: 10,
              child: Divider(),
            ),
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
                    loading
                        ? shimmer(Text("Loading..."))
                        : Text(profile['fullname']),
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
                      "USER ID",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    loading
                        ? shimmer(Text("Loading..."))
                        : Text(profile['username']),
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
                      "Kata sandi",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    Text("******"),
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
                      "Email",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    loading
                        ? shimmer(Text("Loading..."))
                        : Text(profile['email']),
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
                      "No. HP",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    loading
                        ? shimmer(Text("Loading..."))
                        : Text(profile['phone']),
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
                      "Kode Perusahaan",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    loading
                        ? shimmer(Text("Loading..."))
                        : Text(profile['company_code']),
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
                      "ID Karyawan",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    loading
                        ? shimmer(Text("Loading..."))
                        : Text(profile['employee_id']),
                  ],
                )),
            Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () async {
                          dynamic data = await showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: EditPassword()),
                          );
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          onSurface: Colors.grey,
                        ),
                        icon: Icon(Icons.lock),
                        label: Text("Ubah Kata sandi")),
                    SizedBox(
                      width: 30,
                    ),
                    // TextButton.icon(
                    //     onPressed: () {},
                    //     style: TextButton.styleFrom(
                    //       primary: Colors.white,
                    //       backgroundColor: Colors.teal,
                    //       onSurface: Colors.grey,
                    //     ),
                    //     icon: Icon(Icons.face),
                    //     label: Text("Edit Profile")),
                  ],
                )),
          ]),
        ),
      ),
      floatingActionButton: floating
          ? Column(
              children: [
                SizedBox(
                  height: 110,
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (this.floating) {
                        this.floating = false;
                      } else {
                        this.floating = true;
                      }
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: 5,
                ),
                FloatingActionButton(
                  onPressed: () {
                    return cameraConnect(ImageSource.gallery);
                  },
                  child: Icon(Icons.image),
                  backgroundColor: Colors.red,
                ),
                SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    return cameraConnect(ImageSource.camera);
                  },
                  child: Icon(Icons.camera),
                  backgroundColor: Colors.black,
                ),
              ],
            )
          : Container(),
    );
  }
}
