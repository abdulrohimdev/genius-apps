import 'dart:convert';

import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/module/profile/profile_zoom.dart';
import 'package:genius/apps/module/request/SecurityApproval.dart';
import 'package:genius/services/Network.dart';

class ListRequest extends StatefulWidget {
  const ListRequest({Key key}) : super(key: key);

  @override
  _ListRequestState createState() => _ListRequestState();
}

class _ListRequestState extends State<ListRequest> {
  TextEditingController from_date = new TextEditingController();
  TextEditingController to_date = new TextEditingController();
  TextEditingController fullname = new TextEditingController();
  bool loading = false;
  dynamic data = [];


  void search(value) async {
    setState(() {
      loading = true;
    });
    var response = await Network()
        .post({
          "search": value,
          "from" : from_date.text,
          "end" : to_date.text
          }, "hr/leave/leave-search-by-date");
    var result = json.decode(response.body);
    if (result['status'] == true) {
      setState(() {
        loading = false;
        data = result['data'];
      });
    }
  }

  Widget _listTile() {
    return loading
        ? Center(
          child: Container(
            padding: EdgeInsets.only(top:20),
            child: SizedBox(child:CircularProgressIndicator(),
          )),
        )
        : Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SecurityApproval(
                                        title:
                                            "${data[index]['fullname']} /  (${data[index]['request_user_empid']})",
                                        data: data[index],
                                      )))
                          .then((value) => {search(fullname.text)});
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ProfileImage(
                                                    fullname: data[index]
                                                        ['fullname'],
                                                    image: data[index]
                                                        ['photo'])));
                                  },
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: data[index]['photo'] != ''
                                        ? Image.memory(base64.decode(data[index]
                                                    ['photo']
                                                .toString()))
                                            .image
                                        : AssetImage('assets/img/default.jpg'),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nama / NPK",
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12.0),
                                    ),
                                    Text(
                                      "${data[index]['fullname']}",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    Text(
                                      "${data[index]['request_user_empid'].toString()}",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                    Text(
                                      "Divisi / Department",
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12.0),
                                    ),
                                    Text(
                                      "${data[index]['divisi']} / ${data[index]['department']}",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                    Text(
                                      "Meninggalkan Pekerjaan jam: ",
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12.0),
                                    ),
                                    Text(
                                      "${data[index]['request_time_leaving']}",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                    Text(
                                      "Kembali ke perusahaan jam: ",
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12.0),
                                    ),
                                    Text(
                                      "${data[index]['request_time_returning']}",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    SizedBox(
                                      height: 3.0,
                                    ),
                                    Text(
                                      "Dibuat tanggal: ",
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 12.0),
                                    ),
                                    Text(
                                      "${data[index]['request_date']}",
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(),
                            SizedBox(height: 10,),
                            Text(
                              "Tujuan/Alasan: ",
                              style: TextStyle(
                                  color: Color(0xff999999), fontSize: 12.0),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              "${data[index]['request_reason']}",
                              style: TextStyle(fontSize: 13.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: data.length));
  }



  Widget _searching() {
    return TextFormField(
      enableSuggestions: false,
      autocorrect: false,
      controller: fullname,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan NPK atau NAMA Karyawan';
        }
        return null;
      },
      onChanged: (value) => {search(value)},
      decoration: InputDecoration(
        labelText: 'Masukkan NPK atau NAMA Karyawan',
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(13, 13, 13, 13),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black26, //this has no effect
          ),
          borderRadius: BorderRadius.circular(3.0),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        title: Text('Rekaman data Izin dinas/pribadi',
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
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: from_date,
                    readOnly: true,
                    onTap: () => showCupertinoModalPopup(
                        context: context,
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
                                            from_date.text = DateFormat.yMd()
                                                .format(val)
                                                .toString();
                                          });
                                        }),
                                  ),
                                  CupertinoButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      if (from_date.text == '') {
                                        from_date.text = DateFormat.yMd()
                                            .format(DateTime.now())
                                            .toString();
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal wajib di isi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Dari tanggal"),
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: to_date,
                    readOnly: true,
                    onTap: () => showCupertinoModalPopup(
                        context: context,
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
                                            to_date.text = DateFormat.yMd()
                                                .format(val)
                                                .toString();
                                          });
                                        }),
                                  ),
                                  CupertinoButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      if (to_date.text == '') {
                                        to_date.text = DateFormat.yMd()
                                            .format(DateTime.now())
                                            .toString();
                                      }
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ),
                            )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal wajib di isi';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Sampai tanggal"),
                  ),
                ),
                Flexible(
                    child: OutlinedButton(
                  child: Text('Filter'),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(20.0)
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    search('');
                  },
                )),
              ],
            ),
            SizedBox(height: 20,),
            _searching(),
            SizedBox(height: 20,),
            _listTile(),
          ],
        ),
      ),
    );
  }
}
