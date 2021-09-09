import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class FilterDateCase extends StatefulWidget {
  FilterDateCase({Key key, this.date}) : super(key: key);
  final String date;
 
  @override
  _FilterDateCaseState createState() => _FilterDateCaseState();
}

class _FilterDateCaseState extends State<FilterDateCase> {
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController dates = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    print(widget.date);
    setState(() {
      if(widget.date != null){
        dates.text = widget.date;
      }
      else{
          dates.text = format.format(DateTime.now());
      }
    });
    super.initState();
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
          DateTimeField(
            controller: dates,
            keyboardType: TextInputType.text,
            format: format,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFf7f5f5),
              hintText: "Date",
              border: InputBorder.none,
            ),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context,dates.text);
              // print(dates.text);
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(14),
              width: MediaQuery.of(context).size.width,
              child: Text("OKE",style: TextStyle(fontWeight: FontWeight.bold),),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffaaaaaa)),
                borderRadius: BorderRadius.circular(5)
              ),
            ),
          )
        ],
      ),
    );
  }
}
