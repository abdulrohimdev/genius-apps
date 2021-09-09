import 'package:flutter/cupertino.dart';

class ApplicationModel{
  String app_code;
  String app_description;
  String app_icon_class;
  String app_icon_image;
  String app_name;
  dynamic app_route_frontend_mobile;
  String app_route_frontend_web;

  ApplicationModel({
    this.app_code, this.app_description, this.app_icon_class,
    this.app_icon_image,this.app_name,this.app_route_frontend_mobile,
    this.app_route_frontend_web
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
        app_code: json['app_code'] as String,
        app_description: json['app_description'] as String,
        app_icon_class: json['app_icon_class'] as String,
        app_icon_image: json['app_icon_image'] as String,
        app_name: json['app_name'] as String,
        app_route_frontend_mobile: json['app_route_frontend_mobile'] as Widget,
        app_route_frontend_web: json['app_route_frontend_web'] as String,
    );
  }


}