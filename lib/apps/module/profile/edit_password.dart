import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/services/Network.dart';

class EditPassword extends StatefulWidget {
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController oldpassword = new TextEditingController();
  TextEditingController newpassword = new TextEditingController();

  Future<dynamic> update() async {
    if (_formKey.currentState.validate()) {
      EasyLoading.show(status: "Updating...");
      final response = await Network().post(
          {"oldpassword": oldpassword.text, "newpassword": newpassword.text},
          "change-password");
      dynamic data = json.decode(response.body);
      if (data['status'] == true) {
        EasyLoading.showSuccess(data['message']);
      } else {
        EasyLoading.showError(data['message']);
      }
    }
  }

  @override
  void initState() {
    EasyLoading.instance..dismissOnTap = true;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 30.0,
                margin: EdgeInsets.only(top: 3),
                height: 5,
                alignment: Alignment.topCenter,
                color: Color(0xffbbbbbb),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Ubah Kata sandi",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            TextFormField(
              obscureText: true,
              controller: oldpassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan kata sandi lama';
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Kata sandi lama"),
            ),
            TextFormField(
              obscureText: true,
              controller: newpassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan kata sandi baru';
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Kata sandi baru"),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                update();
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff999999)),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.all(13),
                alignment: Alignment.center,
                child: Text(
                  "Perbarui",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
