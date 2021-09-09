import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:genius/apps/module/profile/profile_zoom.dart';
import 'package:genius/apps/module/request/SecurityApproval.dart';
import 'package:genius/services/Network.dart';

class ByInputNumber extends StatefulWidget {
  const ByInputNumber({Key key}) : super(key: key);

  @override
  _ByInputNumberState createState() => _ByInputNumberState();
}

class _ByInputNumberState extends State<ByInputNumber> {
  TextEditingController unix_number = new TextEditingController();
  bool loading = false;
  dynamic data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    search('');
  }

  void search(value) async {
    setState(() {
      loading = true;
    });
    var response = await Network()
        .post({"employee_id": value}, "hr/leave/leave-search-empid");
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
        ? Center(child: CircularProgressIndicator())
        : Expanded(
            child: ListView.builder(
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
                          .then((value) => {search(unix_number.text)});
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
      controller: unix_number,
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
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _searching(),
            SizedBox(
              height: 20.0,
            ),
            _listTile(),
          ],
        ));
  }
}
