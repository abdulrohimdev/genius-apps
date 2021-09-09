import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:genius/apps/welcome/signin_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Network{
  final String _url = '147.139.175.101';
  // final String _url = '192.168.43.70';
  Future signin(data, apiUrl) async {
    http.Response response = await http.post(
        Uri.http(_url,"api/v1/"+apiUrl),
        body: jsonEncode(data),
        headers: _setHeaders()
    );
    return response;
  }

  Future logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
        Navigator.push(
        context, MaterialPageRoute(builder: (context) => SigninScreen()));

  }

   Future post(data, apiUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apikey = prefs.getString("apikey");
    String secretkey = prefs.getString("secretkey");
    http.Response response = await http.post(
        Uri.http(_url,"api/v1/"+apiUrl),
        body: jsonEncode(data),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'apikey' : apikey,
          'secretkey': secretkey
        }
    );
    return response;
  }

  Future getData(apiUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apikey = prefs.getString("apikey");
    String secretkey = prefs.getString("secretkey");

    return await http.get(
        Uri.http(_url,"api/v1/"+apiUrl),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
          'apikey' : apikey,
          'secretkey': secretkey
        }
    );
  }
 
  Future getOriginal(host,apiUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return await http.get(
        Uri.http(host,apiUrl),
        headers: {
          'Content-type' : 'application/json',
          'Accept' : 'application/json',
        }
    );
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };
}