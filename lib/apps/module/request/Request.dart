import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  bool isSearching = false;
  TextEditingController request = new TextEditingController();
  var data = [
    {
      "name": "Izin dinas/pribadi", 
      "icon": "login.png", 
      'route': 'leave'},
    // {
    //   "name": "Attd. Correction",
    //   "icon": "immigration.png",
    //   'route': 'correction'
    // },
  ];

  Widget _searching() {
    return TextFormField(
      controller: request,
      cursorColor: Colors.black,
      style: TextStyle(fontSize: 20.0),
      autofocus: true,
      autocorrect: true,
      onChanged: (value) {
        this.setState(() {
           selectedData = data.where((list) => list['name'].toLowerCase().contains(value.toLowerCase())).toList();
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
          hintText: "Cari menu izin"),
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

  var selectedData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.selectedData = data;
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
          title: isSearching
              ? _searching()
              : Text('Izin & Koreksi Absen',
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
            padding: EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(selectedData.length, (index) {
                return GestureDetector(
                  onTap: (){
                    navigate(selectedData[index]['route'],context);
                  },
                  child: Card(
                    child: Center(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/request/${selectedData[index]['icon']}',
                          fit: BoxFit.contain,
                          width: 30,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${selectedData[index]['name']}",
                          style:
                              TextStyle(fontSize: 10, fontFamily: 'calibri'),
                          textAlign: TextAlign.center,
                        )
                      ],
                    )),
                  ),
                );
              }),
            )));
  }
}
