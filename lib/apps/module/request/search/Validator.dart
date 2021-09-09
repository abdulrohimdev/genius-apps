import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/services/Network.dart';

class Validator extends StatefulWidget {
  @override 
  _ValidatorState createState() => _ValidatorState();
}

class _ValidatorState extends State<Validator> {
  bool isSearching = false;
  TextEditingController request = new TextEditingController();

    bool loading = false;
    var dataFromServer = [];
    void getData() async {
      setState(() {
        loading = true;
      });
      var response = await Network().post({}, 'hr/leave/list-approval');
      var result = json.decode(response.body);
      if(result['status'] == true){
        setState(() {
            dataFromServer = result['data'];
            selectedData = dataFromServer;
            setState(() {
              loading = false;
            });
        });
      }
    }


  Widget _searching() {
    return TextFormField(
      controller: request,
      cursorColor: Colors.black,
      style: TextStyle(fontSize: 20.0),
      autofocus: true,
      autocorrect: true,
      onChanged: (value) {
        this.setState(() {
          selectedData = dataFromServer
              .where((list) =>
                  list['name'].toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
      decoration: new InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: "Cari Pimpinan/ Validator"),
    );
  }

  Widget _btnSearch() {
    return GestureDetector(
      onTap: () {
        this.setState(() {
          this.isSearching = true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(
          Icons.search,
        ),
      ),
    );
  }

  Widget _btnClose() {
    return GestureDetector(
      onTap: () {
        this.setState(() {
          this.isSearching = false;
          request.text = "";
          selectedData = dataFromServer;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(
          Icons.close,
        ),
      ),
    );
  }

  var selectedData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
          title: isSearching
              ? _searching()
              : Text('Daftar pimpinan/ validator',
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
            isSearching ? _btnClose() : _btnSearch(),
          ],
          backgroundColor: Colors.white,
        ),
        body: loading ? Center(child: CircularProgressIndicator()) : Container(
            child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(selectedData.length, (index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, selectedData[index]);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                      backgroundImage: 
                          Image.memory(base64.decode(selectedData[index]['image'].toString())).image),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${selectedData[index]['name']}",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width / 40, fontFamily: 'calibri'),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }),
        )));
  }
}
