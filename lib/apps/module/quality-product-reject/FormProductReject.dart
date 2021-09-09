import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/module/profile/profile_zoom.dart';
import 'package:genius/apps/module/quality-product-reject/FormAddCase.dart';
import 'package:genius/apps/module/quality-product-reject/ListProductReject.dart';
import 'package:genius/apps/module/quality-product-reject/search/ProductSearch.dart';
import 'package:genius/apps/module/quality-product-reject/search/QualityLocationSearch.dart';
import 'package:genius/apps/module/quality-product-reject/search/TypeSearch.dart';
import 'package:genius/services/Network.dart';
import 'package:genius/apps/module/quality-product-reject/search/ProcessSearch.dart';
import 'package:select_form_field/select_form_field.dart';

class FormProductReject extends StatefulWidget {
  FormProductReject({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FormProductRejectState createState() => _FormProductRejectState();
}

class _FormProductRejectState extends State<FormProductReject> {
  final _formKey = GlobalKey<FormState>();

  bool longpress = false;

  dynamic dataTile = [];
  int indexSelected;

  Widget buildCard(index) {
    return ListTile(
      onLongPress: () {
        setState(() {
          longpress = true;
          indexSelected = index;
        });
      },
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileImage(
                      fullname: dataTile[index]['problem'],
                      image: dataTile[index]['image'],
                    )));
      },
      contentPadding: EdgeInsets.all(1.0),
      title: Text(dataTile[index]["problem"]),
      subtitle: Text(dataTile[index]["case_type"] +
          " - " +
          dataTile[index]["quantity"].toString()),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        backgroundImage:
            Image.memory(base64.decode(dataTile[index]['image'])).image,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 15,
      ),
    );
  }

  TextEditingController locationField = TextEditingController();
  TextEditingController processField = TextEditingController();
  TextEditingController typeField = TextEditingController();
  TextEditingController productField = TextEditingController();
  TextEditingController lineField = TextEditingController();

  final List<Map<String, dynamic>> _line = [
    {
      'value': 'No Line',
      'label': 'No Line',
    },
    {
      'value': 'Line 1',
      'label': 'Line 1',
    },
    {
      'value': 'Line 2',
      'label': 'Line 2',
    },
  ];

  Widget alertModal(message) {
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(message.toString()),
      actions: [
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          child: Text("Oke"),
        )
      ],
      elevation: 24.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  void initState() {
    EasyLoading.instance..dismissOnTap = true;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);
    setState(() {
      lineField.text = "No Line";
    });
    super.initState();
  }

  void _save() async {
    if (_formKey.currentState.validate()) {
      if (dataTile.length > 0) {
        EasyLoading.show(
          status: "Saving...",
        );
        dynamic response = await Network().post({
          "case": dataTile,
          "location": locationField.text,
          "process": processField.text,
          "type": typeField.text,
          "product": productField.text,
          "line": lineField.text,
        }, "problem-management/create");
        dynamic data = json.decode(response.body);
        if (data['status'] == true) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess(data['message']);
          setState(() {
            dataTile = [];
            locationField.text = "";
            processField.text = "";
            typeField.text = "";
            productField.text = "";
            lineField.text = "";
          });
        } else {
          EasyLoading.showError(data['message']);
        }
      } else {
        EasyLoading.showError("Please add Case!");
      }
    }
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                  onPressed: () {
                    return _save();
                  },
                  icon: Icon(Icons.save_alt_outlined),
                  label: Text("Save")),
            ),
            TextFormField(
              controller: locationField,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required!';
                }
                return null;
              },
              onTap: () async {
                String location = await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: QualityLocationSearch()),
                );
                setState(() {
                  locationField.text = location;
                });
              },
              enableSuggestions: false,
              autocorrect: false,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Location',
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.2, color: Color(0xff333333)))),
            ),
            TextFormField(
              controller: processField,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required!';
                }
                return null;
              },
              onTap: () async {
                String process = await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ProcessSearch(
                        location: locationField.text,
                      )),
                );
                setState(() {
                  processField.text = process;
                });
              },
              enableSuggestions: false,
              autocorrect: false,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Process',
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.2, color: Color(0xff333333)))),
            ),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              readOnly: true,
              controller: typeField,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required!';
                }
                return null;
              },
              onTap: () async {
                String type = await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: TypeSearch(
                        location: locationField.text,
                        process: processField.text,
                      )),
                );
                setState(() {
                  typeField.text = type;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Type',
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.2, color: Color(0xff333333)))),
            ),
            TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              readOnly: true,
              controller: productField,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required!';
                }
                return null;
              },
              onTap: () async {
                String product = await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ProductSearch(
                        location: locationField.text,
                        type: typeField.text,
                        process: processField.text,
                      )),
                );
                setState(() {
                  productField.text = product;
                });
              },
              decoration: InputDecoration(
                  labelText: 'Product',
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0.2, color: Color(0xff333333)))),
            ),
            SelectFormField(
              type: SelectFormFieldType.dropdown, // or can be dialog
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Field is required!';
                }
                return null;
              },
              initialValue: lineField.text,
              // icon: Icon(Icons.format_shapes),
              labelText: 'Line',
              items: _line,
              onChanged: (val) {
                setState(() {
                  lineField.text = val;
                });
              },
              onSaved: (val) {
                setState(() {
                  lineField.text = val;
                });
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget listOrDelete() {
    if (longpress == true) {
      return GestureDetector(
        onTap: () {
          setState(() {
            dataTile.removeAt(indexSelected);
            longpress = false;
          });
        },
        child: Icon(Icons.delete, color: Color(0xffb81004)),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ListProductReject()));
        },
        child: Icon(Icons.list_alt),
      );
    }
  }

  Widget cancel() {
    if (longpress == true) {
      return GestureDetector(
        onTap: () {
          setState(() {
            longpress = false;
          });
        },
        child: Icon(Icons.cancel_outlined),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xfff2f2f0),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        title: longpress
            ? null
            : Text("Reject Monitoring (Process)",
                style: TextStyle(fontFamily: "calibri", color: Colors.black)),
        elevation: 1.0,
        iconTheme: IconThemeData(color: Color(0xff333333)),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            if (longpress) {
              setState(() {
                longpress = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(
            Icons.arrow_back_ios_outlined, // add custom icons also
          ),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 10.0), child: listOrDelete()),
          // Padding(padding: EdgeInsets.only(right: 10.0), child: cancel()),
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildForm(context),
            TextButton.icon(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic data = await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.95,
                          child: FormAddCase(
                            location: locationField.text,
                            type: typeField.text,
                            product: productField.text,
                            process: processField.text,
                          )),
                    );
                    if (data.length > 0) {
                      setState(() {
                        dataTile.add({
                          "case_type": data['case_type'],
                          "problem": data['problem'],
                          "quantity": data['quantity'],
                          "image": data['image'],
                          "path": data['path'],
                          "decision": data['decision'],
                          "note": data['note'],
                        });
                      });
                    }
                  } 
                },
                icon: Icon(Icons.add),
                label: Text("Add Case")),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                  child: ListView.separated(
                      itemCount: dataTile.length,
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 0.5,
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        return buildCard(index);
                      })),
            ),
          ],
        ),
      ),
    );
  }
}
