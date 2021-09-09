import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:genius/apps/module/request/QrCodeGenerate.dart';
import 'package:genius/apps/module/request/RequestLeaveEdit.dart';
import 'package:genius/services/Network.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class RequestLeaveDetail extends StatefulWidget {
  RequestLeaveDetail({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _RequestLeaveDetailState createState() => _RequestLeaveDetailState();
}

class _RequestLeaveDetailState extends State<RequestLeaveDetail> {
  dynamic data = [];
  bool loading = false;
  String image;
  bool loadImage = true;
  Uint8List photo;
  bool isImage = false;
  String id;
  String fullname;
  String approver;
  Future<void> cameraConnect(source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    final isFile = await compress(File(pickedFile.path));
    String base64 = base64Encode(isFile);
    return imageUpdate(base64);
  }

  Future<dynamic> imageUpdate(String source) async {
    setState(() {
      loading = true;
    });
    var response = await Network().post(
        {"request_hash_id": this.id, 'image': source, 'status': 'Approved'},
        'hr/leave/leave-denied-accepted');
    var result = json.decode(response.body);
    if (result['status'] == true) {
      setState(() {
        getData();
        loading = false;
      });
    }
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

  Widget shimmer(widget) {
    return Shimmer.fromColors(
        child: widget,
        baseColor: Color(0xffd4d2d2),
        highlightColor: Colors.white);
  }

  void getData() async {
    setState(() {
      loading = true;
    });
    var response = await Network()
        .post({"request_hash_id": this.id}, 'hr/leave/leave-detail');
    var result = json.decode(response.body);
    if (result['status'] == true) {
      setState(() {
        data = result['data'];
        this.fullname = data['user_fullname'];
        this.approver = data['request_approval'];
        print(data);
        loading = false;
      });
    }
  }

  String empid;
  getEmpid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empid = prefs.getString('empid');
    });
  }

  void deniedOrAccepted(status) async {
    if (status == 'Rejected') {
      setState(() {
        loading = true;
      });

      var response = await Network().post(
          {"request_hash_id": this.id, 'image': '', 'status': status},
          'hr/leave/leave-denied-accepted');
      var result = json.decode(response.body);
      if (result['status'] == true) {
        setState(() {
          getData();
          loading = false;
        });
      }
    } else {
      return cameraConnect(ImageSource.camera);
    }
  }

  canceledLeave() async {
    EasyLoading.show(status: "Send cancel leave...");
    EasyLoading.dismiss();
    var response = await Network().post({
      "request_hash_id": this.id,
      "fullname": this.fullname,
      "approver_id": this.approver,
    }, 'hr/leave/leave-canceled');
    var result = json.decode(response.body);
    if (response.statusCode == 200) {
      if (result['status'] == true) {
        AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            dismissOnTouchOutside: false,
            title: 'Berhasil!',
            desc: result['message'],
            btnOkOnPress: () {
              Navigator.pop(context);
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
      } else {
        AwesomeDialog(
            context: context,
            animType: AnimType.TOPSLIDE,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            showCloseIcon: true,
            dismissOnTouchOutside: false,
            title: 'Failed!',
            desc: result['message'],
            btnOkOnPress: () {},
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            })
          ..show();
      }
    } else {
      AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          headerAnimationLoop: true,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          dismissOnTouchOutside: false,
          title: 'Failed!',
          desc: 'Error networking...',
          btnCancelOnPress: () {},
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    }
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.instance..dismissOnTap = false;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);

    if (widget.id != '') {
      setState(() {
        this.id = widget.id;
      });
    }
    getData();
    getEmpid();
  }

  confirmButton() {
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.WARNING,
        showCloseIcon: true,
        btnCancelText: "Tidak",
        btnOkText: "Iya",
        btnCancelIcon: Icons.cancel_outlined,
        dismissOnTouchOutside: false,
        title: 'Mohon konfirmasikan!',
        desc: 'anda ingin membatalkan izin?',
        btnOkOnPress: () {
          canceledLeave();
        },
        btnCancelOnPress: () {},
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        })
      ..show();
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
          title: Text('Izin',
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
            data.length > 0 && data['status'].toString() == 'Approved'
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  QrCodeGenearate(code: data['number_unix'])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.qr_code,
                      ),
                    ),
                  )
                : data.length > 0 && data['status'].toString() == 'Pending'
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RequestLeaveEdit(
                                            data: this.data,
                                          ))).then((value) => getData());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              confirmButton();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Text(''),
          ],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Column(children: [
              Container(
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nama",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['user_fullname']),
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
                        "No. Unix",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['number_unix']),
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
                        "Tanggal",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['request_date']),
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
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['request_type']),
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
                        "Rencana meninggalkan kerja",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['request_time_leaving']),
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
                        "Rencana kembali ke perusahaan",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['request_time_returning']),
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
                        "Aktual meninggalkan pekerjaan",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text("${data['security_check_leave']}"),
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
                        "Aktual kembali ke perusahaan",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text("${data['security_check_return']}"),
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
                        "Status",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['status']),
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
                        "Penandatanganan oleh",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                      loading
                          ? shimmer(Card(child: Text("Loading...")))
                          : Text(data['approval']),
                    ],
                  )),
              Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Alasan",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'calibri'),
                      ),
                    ],
                  )),
              loading
                  ? shimmer(Card(child: Text("Loading...")))
                  : Text(data['request_reason'].toString(),),
              Divider(),
              SizedBox(
                height: 20,
              ),
              loading
                  ? CircularProgressIndicator()
                  : (empid == data['request_approval']) &&
                          (data['status'] == 'Pending')
                      ? Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blueAccent)),
                                  onPressed: () {
                                    deniedOrAccepted('Approved');
                                  },
                                ),
                                SizedBox(width: 20.0),
                                TextButton(
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.redAccent)),
                                  onPressed: () {
                                    deniedOrAccepted('Rejected');
                                  },
                                ),
                              ],
                            ),
                          ))
                      : Text(""),
            ]),
          ),
        ));
  }
}
