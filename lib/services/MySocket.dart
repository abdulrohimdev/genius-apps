// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:genius/services/Notification.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class MySocket {
//   List<String> messages;
//   int count = 1;
//   String key =
//       "broadcast:xkejhkakjgagsaksjgkajsgkajsgkasjkasdkassjgkasjgkajskcmsakjgkasjgakdksajfakj";

//   IO.Socket socket = IO.io('http://147.139.175.101:6001', <String, dynamic>{
//     'transports': ['websocket'],
//     'forceTrue': true,
//     'autoConnect': true
//   });

//   void connectToServer(){
//     try {
//       socket.connect();
//       socket.on('connect', (data) => print('Connected to socket server'));
//       socket.on(key, (data) async {
//         String empid;
//         String fullname;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         empid = prefs.getString('empid');
//         fullname = prefs.getString('fullname');
//         if(empid == data['data']['receiver']){
//           NotificationPush().initialization(context);
//           NotificationPush().showNotification(
//               count, "Hallo ${fullname}", "${data['data']['message']}", "Hello");
//           count++;
//         }
//         else{
//           print(empid);
//           print("and");
//           print(data['data']['receiver']);
//         }
//       });
//       socket.on('disconnect', (reason) => print('disconnected $reason'));
//       socket.on('error', (err) => print('Error: $err'));
//       socket.on("connect_error", (data) => print('connect_error: ' + data));
//     } on SocketException catch (e) {
//       print('error ${e.message}');
//     } catch (e) {
//       //for other errors
//       print('error ${e.toString()}');
//     }
//   }

//   void emit(data) {
//     socket.connect();
//     socket.emit(key, data);
//   }
// }
