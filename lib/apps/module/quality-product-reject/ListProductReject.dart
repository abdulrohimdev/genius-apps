import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:genius/apps/module/quality-product-reject/ListCase.dart';
import 'package:genius/model/MgtProblem/Problem.dart';
import 'package:genius/services/Network.dart';
import 'package:genius/apps/module/quality-product-reject/FilterDateCase.dart';
import 'package:intl/intl.dart';

class ListProductReject extends StatefulWidget {
  ListProductReject({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListProductRejectState createState() => _ListProductRejectState();
}

class _ListProductRejectState extends State<ListProductReject> {
  final format = DateFormat("yyyy-MM-dd");

  dynamic dataTile = [];
  bool isLoad = false;
  String date;

  Future<Problem> getProblem(String search) async{
    setState(() {
      isLoad = true;
    });
    final response = await Network().post({
      "search": search,
      "date" : date
    },'problem-management/have-problem');
    dynamic data = json.decode(response.body);
    if(data['status'] == true){
      setState(() {
        dataTile = data['data'];
        isLoad = false;
      });
    }
  }

  void delete(int id) async{
    EasyLoading.show(status: 'Deleting...');
    var response = await Network().post({"id" : id}, "problem-management/delete");
    dynamic data = json.decode(response.body);
    if(data['status'] == true){
      getProblem("");
      EasyLoading.showSuccess(data['message']);
    }
    else{
      EasyLoading.showError(data['message']);      
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    EasyLoading.instance..dismissOnTap = true;
    EasyLoading.instance..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.instance..maskType = EasyLoadingMaskType.black;
    EasyLoading.instance..maskColor = Colors.blue.withOpacity(0.5);
    setState(() {
      date = format.format(DateTime.now());
      getProblem("");
    });
    super.initState();
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
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
            Text("Location : ${data['location']}"),
            Text("Type : ${data['type']}"),
            Text("Product : ${data['product']}"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
            delete(data['id']);
          },
          child: Text("Yes Delete it.", style:TextStyle(color: Colors.red)),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f0),
      appBar: AppBar(
        centerTitle: false,
        title: Text("List Product Reject",
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
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () async {
                    // print(date);
                    String mydate = await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          child: FilterDateCase(date: date)
                      ),
                    );
                  if(mydate != null){
                    setState(() {
                      date = mydate;
                    });
                  }
                  getProblem("");

                },
                child: Icon(Icons.filter_list),
              )),
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, top: 5, right: 10),
              child: TextFormField(
                autofocus: false,
                onChanged: (value)=>{
                  getProblem(value)
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  isDense: true,
                  filled: false,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(13, 13, 13, 13),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 10.0),
                child: isLoad ? _loading() : ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ListCase(problemId: dataTile[index]['id'],)));
                          },
                          onLongPress: (){
                            return alertModal(dataTile[index]);
                          },
                          title: Text(dataTile[index]['location']+' - '+dataTile[index]['process']),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(dataTile[index]['type']+ " - " + dataTile[index]['product'] ),
                              Text(dataTile[index]['created_at']),
                            ]
                          ),
                          trailing:
                              Icon(Icons.arrow_forward_ios_outlined, size: 18));
                    },
                    separatorBuilder: (context, index) => const Divider(
                          thickness: 0.5,
                        ),
                    itemCount: dataTile.length),
              ),
            )
          ],
        ),
      ),
    );
  }
}
