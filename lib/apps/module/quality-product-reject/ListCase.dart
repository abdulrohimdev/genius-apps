import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/module/quality-product-reject/FormAddCase.dart';
import 'package:genius/apps/module/quality-product-reject/ShowImageSingle.dart';
import 'package:genius/model/MgtProblem/ParentProblem.dart';
import 'package:genius/services/Network.dart';

class ListCase extends StatefulWidget {
  ListCase({Key key, this.problemId}) : super(key: key);
  final int problemId;

  @override
  _ListCaseState createState() => _ListCaseState();
}

class _ListCaseState extends State<ListCase> {
  int problemId;

  dynamic parent;
  dynamic child;
  String title = "Loading...";
  String location = 'Loading...';
  String process = 'Loading...';
  String product = 'Loading...';
  String type = 'Loading...';
  String line = 'Loading...';
  bool loading = false;
  String created_at = "Loading...";
  Future<ParentProblem> getData(int id) async {
    setState(() {
      loading = true;
    });
    var response =
        await Network().post({"id": id}, "problem-management/get-data");
    dynamic data = json.decode(response.body);
    if (data['status'] == true) {
      setState(() {
        created_at = data['created_at'];
        parent = data['parent'];
        child = data['child'];
        title = data['parent']['location'] + '-' + data['parent']['product'];
        location = data['parent']['location'];
        process = data['parent']['process'];
        type = data['parent']['type'];
        line = data['parent']['line'];
        product = data['parent']['product'];
        loading = false;
      });
    }
  }

  void _save(mydata) async {
      EasyLoading.show(
        status: "Saving...",
      );
      dynamic response = await Network().post({
        "case": mydata,
      }, "problem-management/case/create");
      dynamic data = json.decode(response.body);
      if (data['status'] == true) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(data['message']);
        getData(problemId);
      } else {
        EasyLoading.showError(data['message']);
      }
  }


  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      problemId = widget.problemId;
      getData(problemId);
    });
    super.initState();
  }

  void delete(int id) async {
    EasyLoading.show(status: 'Deleting...');
    var response =
        await Network().post({"id": id}, "problem-management/case/delete");
    dynamic data = json.decode(response.body);
    if (data['status'] == true) {
      EasyLoading.showSuccess(data['message']);
      getData(problemId);
    } else {
      EasyLoading.showError(data['message']);
    }
  }

  Widget alertModal(dynamic data) {
    AlertDialog alert = AlertDialog(
      title: Text("You want to delete the following data? "),
      content: Container(
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Case : ${data['case']}"),
            Text("Case Type : ${data['case_type']}"),
            Text("Quantity : ${data['quantity']}"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            delete(data['id']);
            Navigator.of(context).pop();
          },
          child: Text("Yes Delete it.", style: TextStyle(color: Colors.red)),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Widget buildCard(index) {
    Uint8List bytes = base64.decode(child[index]['image'].toString());
    var data = Uint8List.fromList(bytes);
    return ListTile(
      onLongPress: () {
        alertModal(child[index]);
      },
      onTap: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ShowImageSingle(image: data, title: child[index]['case'])));
      },
      contentPadding: EdgeInsets.all(1.0),
      title: Text(child[index]["case"]),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(child[index]["case_type"] +
              " - " +
              child[index]["quantity"].toString()),
          Text('Decision: ' + (child[index]["decision"] ?? '')),
          Text('Note: ' + (child[index]["note"] ?? '')),
        ],
      ),
      leading: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: Image.memory(data).image),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        size: 15,
      ),
    );
  }

  Widget _loading() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Center(
        child: CircularProgressIndicator(),
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
        title: Text(title,
            style: TextStyle(fontFamily: "calibri", color: Colors.black)),
        elevation: 0.5,
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
        // actions: [
        //   Padding(
        //       padding: EdgeInsets.only(right: 10.0),
        //       child: GestureDetector(
        //         onTap: () {},
        //         child: Icon(Icons.edit_outlined),
        //       )),
        // ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Color(0xffdddddd)))),
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LOCATION",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    Text(location),
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
                      "PROCESS",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    Text(process),
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
                      "TYPE",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    Text(type),
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
                      "PRODUCT",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    Text(product),
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
                      "LINE",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    Text(line),
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
                      "CREATED AT",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'calibri'),
                    ),
                    Text(created_at),
                  ],
                )),
            Container(
                // padding: EdgeInsets.all(12),
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                    onPressed: () async{
                      dynamic data = await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.95,
                          child: FormAddCase(
                            location: location,
                            type: type,
                            product: product,
                            process: process,
                          )),
                    );
                    if (data.length > 0) {
                      // print(dataTile);
                      return _save({
                          "problem_id" : problemId,
                          "case_type": data['case_type'],
                          "case": data['problem'],
                          "quantity": data['quantity'],
                          "decision": data['decision'],
                          "note": data['note'],
                          "image": data['image'],
                        });
                    }

                    },
                    icon: Icon(Icons.add),
                    label: Text("Add Case"))),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: loading
                    ? _loading()
                    : ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                              thickness: 0,
                            ),
                        itemBuilder: (BuildContext context, int index) {
                          return buildCard(index);
                        },
                        itemCount: child.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
