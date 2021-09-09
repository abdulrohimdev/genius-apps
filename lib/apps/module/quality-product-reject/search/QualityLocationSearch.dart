import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genius/services/Network.dart';

class QualityLocationSearch extends StatefulWidget {
  @override
  _QualityLocationSearchState createState() => _QualityLocationSearchState();
}

class _QualityLocationSearchState extends State<QualityLocationSearch> {

  var dataLocationSearch = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    getLocation('');
    // print(location);
    super.initState();
  }

  Future<dynamic> getLocation(String search) async{
    setState(() {
      loading = true;
    });
    if(search == ''){
      var response = await Network().post({"search" : search},"problem-management/get-location");
      var data = json.decode(response.body);
        if(data['status'] == true){
          setState(() {
            dataLocationSearch = data['data'];
            searchData = dataLocationSearch;
            loading = false;
          });
        }
    }
    else{
      var response = await Network().post({"search" : search},"problem-management/get-location");
      var data = json.decode(response.body);
        if(data['status'] == true){
          setState(() {
            dataLocationSearch = data['data'];
            searchData = dataLocationSearch;
            loading = false;
          });
        }
    }
  }

  TextEditingController search = TextEditingController();

  Widget _loading(){
    return Center(child: CircularProgressIndicator(),);
  }

  var searchData = [];
  searching(name){
    this.setState(() {
      searchData = dataLocationSearch.where((list) => list['location'].toLowerCase().contains(name.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
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
            TextFormField(
              autofocus: true,
              controller: search,
              onChanged: (value)=>{
                searching(value)
              },
              decoration: InputDecoration(
                hintText: 'Search Location',
                isDense: false,
                filled: true,
                fillColor: Color(0xfff2f2f2),
                focusColor: Color(0xfff2f2f2),
                contentPadding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: loading ? _loading() : ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      child: ListTile(
                        title: Text(searchData[index]['location'], style: TextStyle(fontSize: 13)),
                        onTap: () {
                          Navigator.pop(context, searchData[index]['location']);
                        },
                        trailing:
                            Icon(Icons.arrow_forward_ios_outlined, size: 13),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                        thickness: 0.5,
                      ),
                  itemCount: searchData.length),
            )
          ],
        ),
      ),
    );
  }
}
