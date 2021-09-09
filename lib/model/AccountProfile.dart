import 'package:flutter/cupertino.dart';

class AccountProfileModel{
  String company;
  String employeeid;
  String fullname;

  AccountProfileModel({
    this.company,
    this.employeeid,
    this.fullname
  });

  factory AccountProfileModel.fromJson(Map<String, dynamic> json) {
    return AccountProfileModel(
        company : json['company'] as String,
        employeeid : json['employeeid'] as String,
        fullname: json['fullname'] as String,
    );
  }


}