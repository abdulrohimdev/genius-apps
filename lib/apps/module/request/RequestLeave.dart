import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/module/request/RequestLeaveList.dart';
import 'package:genius/apps/module/request/search/Validator.dart';
import 'package:genius/services/Network.dart';
import 'package:select_form_field/select_form_field.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RequestLeave extends StatefulWidget {
  @override
  _RequestLeaveState createState() => _RequestLeaveState();
}

class _RequestLeaveState extends State<RequestLeave> {
  TextEditingController leaveType = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController leaving = new TextEditingController();
  TextEditingController returning = new TextEditingController();
  TextEditingController reason = new TextEditingController();
  TextEditingController requestApproval = new TextEditingController();
  static SharedPreferences prefs;

  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Dinas',
      'label': 'Dinas',
    },
    {
      'value': 'Pribadi',
      'label': 'Pribadi',
    },
  ];

  String leaves = "";
  String approval;

  DateTime _chosenDateTime;
  // Show the modal that contains the CupertinoDatePicker
  void _showDatePicker(ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 400,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                            date.text = DateFormat.yMd()
                                .format(_chosenDateTime)
                                .toString();
                          });
                        }),
                  ),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      if (date.text == '') {
                        date.text =
                            DateFormat.yMd().format(DateTime.now()).toString();
                      }
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  void _showTimePickerIn(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 400,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (val) {
                          setState(() {
                            returning.text =
                                DateFormat.Hm().format(val).toString();
                          });
                        }),
                  ),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      if (returning.text == '') {
                        returning.text =
                            DateFormat.Hm().format(DateTime.now()).toString();
                      }
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  void _showTimePickerOut(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 400,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (val) {
                          setState(() {
                            leaving.text =
                                DateFormat.Hm().format(val).toString();
                          });
                        }),
                  ),
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: () {
                      if (leaving.text == '') {
                        leaving.text =
                            DateFormat.Hm().format(DateTime.now()).toString();
                      }
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            ));
  }

  Future<dynamic> submit() async {
    if (_formKey.currentState.validate()) {
      EasyLoading.show(status: "Send request...");
      final response = await Network().post({
        "leave_type": leaves,
        "date": date.text,
        "leaving": leaving.text,
        "returning": returning.text,
        "approval": approval,
        "reason": reason.text,
      }, "hr/leave/create-leave-v2");
      var data = json.decode(response.body);
      if (data['status'] == true) {
        EasyLoading.dismiss();
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: true,
          dialogType: DialogType.SUCCES,
          showCloseIcon: true,
          dismissOnTouchOutside: false,
          title: 'Successfully',
          desc: data['message'],
          btnOkOnPress: () {

          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();

      } else {
        EasyLoading.dismiss();
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: true,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          dismissOnTouchOutside: false,
          title: 'Failed',
          desc: data['message'],
          btnOkOnPress: () {

          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();

      }
    }
  }

  String empidData;
  void getEmpid() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        empidData = prefs.getString('empid');              
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.instance..dismissOnTap = false;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);
    getEmpid();
    print(empidData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          title: Text("Form Izin",
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
                        builder: (BuildContext context) => RequestLeaveList()));
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
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SelectFormField(
                    type: SelectFormFieldType.dropdown, // or can be dialog
                    initialValue: leaves,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib di isi!';
                      }
                      return null;
                    },
                    labelText: 'Jenis Izin',
                    items: _items,
                    onChanged: (val) {
                      setState(() {
                        leaves = val;
                      });
                    },
                    onSaved: (val) {
                      setState(() {
                        leaves = val;
                      });
                    },
                  ),
                  TextFormField(
                    controller: date,
                    readOnly: true,
                    onTap: () => _showDatePicker(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal wajib di isi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Tanggal"),
                  ),
                  TextFormField(
                    controller: leaving,
                    readOnly: true,
                    onTap: () => {_showTimePickerOut(context)},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib di isi!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Rencana meninggalkan pekerjaan jam?"),
                  ),
                  TextFormField(
                    controller: returning,
                    readOnly: true,
                    onTap: () => {_showTimePickerIn(context)},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib di isi!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Rencana kembali ke-Perusahaan jam?"),
                  ),
                  TextFormField(
                    controller: requestApproval,
                    readOnly: true,
                    onTap: () async {
                      dynamic data = await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.55,
                            child: Validator()),
                      );
                      if (data.length > 0) {
                        requestApproval.text = data['name'];
                        setState(() {
                          approval = data['empid'];                                                  
                          print(data);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib di isi!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Pilih pimpinan untuk menandatangani"),
                  ),
                  TextFormField(
                    controller: reason,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 1000,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wajib diisi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Tujuan & Alasan"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    height: 50.0,
                    minWidth: MediaQuery.of(context).size.width,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: new Text("Kirim"),
                    onPressed: () => {
                      if (_formKey.currentState.validate()) {submit()}
                    },
                    splashColor: Colors.purpleAccent,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
