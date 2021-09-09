import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius/apps/module/request/RequestLeaveDetail.dart';
import 'package:genius/services/Network.dart';
import 'package:shimmer/shimmer.dart';

class RequestLeaveList extends StatefulWidget {
  @override
  _RequestLeaveListState createState() => _RequestLeaveListState();
}

class _RequestLeaveListState extends State<RequestLeaveList> {
  bool isSearching = false;
  TextEditingController request = new TextEditingController();
  var data = [];
  bool loading = false;
  Future getData() async {
    setState(() {
      loading = true;
      selectedData = [];
    });
    try {
      var response = await Network().post({}, 'hr/leave/list-leave');
      var result = json.decode(response.body);
      if (result['status'] == true) {
        setState(() {
          data = result['data'];
          loading = false;
          selectedData = data;
        });
      }
    } catch (Exception) {
      loading = false;
      selectedData = [];
      AwesomeDialog(
          context: context,
          animType: AnimType.TOPSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          btnOkText: "Try again",
          btnCancelText: "Cancel",
          dismissOnTouchOutside: false,
          title: 'Error',
          desc: Exception.message,
          btnOkOnPress: () {
            getData();
          },
          btnCancelOnPress: () {
            loading = false;
            selectedData = [];
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: (type) {
            debugPrint('Dialog Dissmiss from callback $type');
          })
        ..show();
    }
  }

  Widget shimmer(widget) {
    return Shimmer.fromColors(
        child: widget,
        baseColor: Color(0xffd4d2d2),
        highlightColor: Colors.white);
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
          selectedData = data
              .where((list) => list['request_reason']
                  .toLowerCase()
                  .contains(value.toLowerCase()))
              .toList();
          print(selectedData.length);
          if (selectedData.length == 0) {
            selectedData = data
                .where((list) =>
                    list['status'].toLowerCase().contains(value.toLowerCase()))
                .toList();
          }
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
          hintText: "Search your request reason"),
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
          selectedData = data;
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

  Color color;

  void _status(String status) {
    if (status == 'Rejected') {
      color = Colors.red[900];
    } else if (status == 'Approved') {
      color = Colors.green[900];
    } else {
      color = Colors.yellow[900];
    }
  }

  var selectedData = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget fakeCard() {
    return Card(
      child: ListTile(
        leading: shimmer(CircleAvatar(
          child: Text(""),
        )),
        title: shimmer(Card(child: Text("Loading title"))),
        subtitle: shimmer(Card(
            child: Text("Loading subtitle subtitle data askjaksg aksjgag"))),
      ),
    );
  }

  Widget _shimmerLoad() {
    return ListView(
      children: [
        fakeCard(),
        fakeCard(),
        fakeCard(),
        fakeCard(),
        fakeCard(),
        fakeCard(),
        fakeCard(),
        fakeCard(),
        fakeCard(),
      ],
    );
  }

  Widget _icon(status){
    if(status == 'Pending'){
      return Icon(Icons.pending,color: Colors.orange,);
    }
    else if(status == 'Approved'){
      return Icon(Icons.done,color: Colors.green,);
    }
    else{
      return Icon(Icons.cancel,color: Colors.red,);
    }
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
              : Text('Daftar Izin',
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
        body: Container(
            child: loading
                ? _shimmerLoad()
                : RefreshIndicator(
                    onRefresh: getData,
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          _status(selectedData[index]['status']);
                          return ListTile(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RequestLeaveDetail(
                                            id: selectedData[index]
                                                ['request_hash_id'],
                                          ))).then((value) => getData())
                            },
                            title:
                                Text('${selectedData[index]['request_type']}'),
                            leading: Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _icon(selectedData[index]['status']),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${selectedData[index]['status']}',
                                  style:
                                      TextStyle(color: color, fontSize: 13.0),
                                ),
                              ],
                            )),
                            subtitle:
                                Text('${selectedData[index]['request_date']}'),
                            minLeadingWidth: 20,
                            isThreeLine: false,
                            trailing: Icon(Icons.keyboard_arrow_right),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: selectedData.length),
                  )));
  }
}
