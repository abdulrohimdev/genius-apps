// import 'dart:html';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/module/quality-product-reject/search/ProblemSearch.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FormAddCase extends StatefulWidget {
  FormAddCase(
      {Key key,
      this.location,
      this.process,
      this.type,
      this.product,
      this.casetype,
      this.image,
      this.quantity,
      this.problem,
      this.note})
      : super(key: key);

  final String location;
  final String process;
  final String type;
  final String product;
  final String casetype;
  final String problem;
  final String quantity;
  final String note;
  final String image;

  @override
  _FormAddCaseState createState() => _FormAddCaseState();
}

class _FormAddCaseState extends State<FormAddCase> {
  final _formKey = GlobalKey<FormState>();

  String casetype = "";

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Dimensi',
      'label': 'Dimensi',
    },
    {
      'value': 'Visual',
      'label': 'Visual',
    },
    {
      'value': 'Fungsi',
      'label': 'Fungsi',
    },
  ];

  final List<Map<String, dynamic>> _decision = [
    {
      'value': 'Reject',
      'label': 'Reject',
    },
    {
      'value': 'Rework/Repair',
      'label': 'Rework/Repair',
    },
    {
      'value': 'TG',
      'label': 'TG',
    },
  ];

  TextEditingController problem = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController decision = TextEditingController();

  File image;
  String path;
  bool isImage = false;
  bool floating = false;
  String imageBase64;
  //connect camera
  Future<void> cameraConnect(source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    final isFile = await compress(File(pickedFile.path));
    String base64 = base64Encode(isFile);
    if (pickedFile.path != '') {
      setState(() {
        image = File(pickedFile.path);
        path = pickedFile.path;
        imageBase64 = base64;
        isImage = true;
        this.floating = false;
      });
    } else {
      setState(() {
        isImage = false;
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

  @override
  void initState() {
    // TODO: implement initState
    casetype = widget.casetype;
    problem.text = widget.problem;
    quantity.text = widget.quantity;
    note.text = widget.note;
    decision.text = "Reject";
    super.initState();
  }

  void save() {
    if (_formKey.currentState.validate()) {
      if (isImage) {
        return Navigator.pop(context, {
          "case_type": casetype,
          "problem": problem.text,
          "decision": decision.text,
          "quantity": quantity.text,
          "image": imageBase64,
          "path": path,
          "note": note.text
        });
      } else {
        alertModal("Please Add Image");
      }
    }
  }

  Widget alertModal(message) {
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(message),
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        centerTitle: false,
        title: Text("Add Case",
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
      floatingActionButton: floating
          ? Column(
              children: [
                SizedBox(
                  height: 50,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (this.floating) {
                        this.floating = false;
                      } else {
                        this.floating = true;
                      }
                    });
                  },
                  child: CircleAvatar(
                    maxRadius: 80,
                    minRadius: 80,
                    backgroundColor: Color(0xfff2f2f2),
                    backgroundImage: isImage
                        ? Image.memory(base64.decode(imageBase64)).image
                        : null,
                    child: isImage
                        ? null
                        : Icon(Icons.camera_alt_outlined,
                            size: 30, color: Colors.black54),
                  ),
                ),
                SizedBox(height: 20),
                SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  initialValue: casetype,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required!';
                    }
                    return null;
                  },

                  labelText: 'Case Type',
                  items: _items,
                  onChanged: (val) {
                    setState(() {
                      casetype = val;
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      casetype = val;
                    });
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: problem,
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
                          child: ProblemSearch(
                              location: widget.location,
                              process: widget.process,
                              type: widget.type,
                              product: widget.product,
                              casetype: casetype)),
                    );
                    setState(() {
                      problem.text = type;
                    });
                  },
                  decoration: InputDecoration(labelText: "Problem"),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: quantity,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required!';
                    }
                    return null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: InputDecoration(labelText: "Quantity"),
                ),
                SelectFormField(
                  type: SelectFormFieldType.dropdown, // or can be dialog
                  initialValue: decision.text,
                  labelText: 'Decision',
                  items: _decision,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required!';
                    }
                    return null;
                  },

                  onChanged: (val) {
                    setState(() {
                      decision.text = val;
                    });
                  },
                  onSaved: (val) {
                    setState(() {
                      decision.text = val;
                    });
                  },
                ),
                TextFormField(
                  controller: note,
                  decoration: InputDecoration(labelText: "Note"),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    return save();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff999999)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
