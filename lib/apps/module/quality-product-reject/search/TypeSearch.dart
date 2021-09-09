import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genius/services/Network.dart';

class TypeSearch extends StatefulWidget {
  TypeSearch({Key key, this.location,this.process}) : super(key: key);

  final String location;
  final String process;

  @override
  _TypeSearchState createState() => _TypeSearchState();
}

class _TypeSearchState extends State<TypeSearch> {
  var dataType = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    getData('');
    // print(location);
    super.initState();
  }

  var searchData = [];
  searching(name){
    this.setState(() {
      searchData = dataType.where((list) => list['type'].toLowerCase().contains(name.toLowerCase())).toList();
    });
  }

  Future<dynamic> getData(String search) async{
    setState(() {
      loading = true;
    });
    if(search == ''){
      var response = await Network().post({
        "search" : search,
        "location": widget.location,
        "process": widget.process,
      },"problem-management/get-type");
      var data = json.decode(response.body);
        if(data['status'] == true){
          setState(() {
            dataType = data['data'];
            searchData = dataType;
            loading = false;
          });
        }
    }
    else{
      var response = await Network().post({
        "search" : search,
        "location": widget.location,
        "process": widget.process,
      },"problem-management/get-type");
      var data = json.decode(response.body);
        if(data['status'] == true){
          setState(() {
            dataType = data['data'];
            searchData = dataType;
            loading = false;
          });
        }
    }
  }

  Widget _loading(){
    return Center(child: CircularProgressIndicator(),);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
              onChanged: (value)=>{
                searching(value)   
              },

              decoration: InputDecoration(
                hintText: 'Search Type',
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
                        title: Text(searchData[index]['type'], style: TextStyle(fontSize: 13)),
                        onTap: () {
                          Navigator.pop(context, searchData[index]['type']);
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
    );
  }
}
