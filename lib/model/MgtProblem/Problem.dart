import 'package:flutter/cupertino.dart';

class Problem{
  String company_code;
  String management_area;
  String location;
  String type;
  String product;
  String create_by;
  DateTime created_at;
  DateTime updated_at;

  Problem({
    this.company_code, this.management_area, this.location,
    this.type,this.product,this.create_by,
    this.created_at,
    this.updated_at
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
        company_code: json['company_code'] as String,
        management_area: json['management_area'] as String,
        location: json['location'] as String,
        type: json['type'] as String,
        product: json['product'] as String,
        create_by: json['create_by'] as String,
        created_at: json['created_at'] as DateTime,
        updated_at: json['updated_at'] as DateTime,
    );
  }


}