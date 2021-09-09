import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:genius/apps/PageError/PageNotFound.dart';
import 'package:genius/apps/module/request/RequestLeave.dart';

dynamic router = [
  {
    'routeName' : 'leave',
    'app' : RequestLeave()
  },
  {
    'routeName' : 'correction',
    'app' : RequestLeave()
  },
];

navigate(routeName,context){
  dynamic data = router.firstWhere((list) => list['routeName'] == routeName); 
  if(data.length > 0){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => data['app']));
  }
  else{
    Navigator.push(
    context,
    MaterialPageRoute(
        builder: (BuildContext context) => PageNotFound()));
  }
  
}