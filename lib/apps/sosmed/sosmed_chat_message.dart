// import 'dart:async';
// import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:dash_chat/dash_chat.dart';

// class SosmedChatMessage extends StatefulWidget {
//   const SosmedChatMessage({ Key key }) : super(key: key);

//   @override
//   _SosmedChatMessageState createState() => _SosmedChatMessageState();
// }

// class _SosmedChatMessageState extends State<SosmedChatMessage> {
//   final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
//   final ChatUser user = ChatUser(
//     name: "Fayeed",
//     uid: "123456789",
//     avatar: "https://randomuser.me/api/portraits/men/31.jpg",
//   );

//   final ChatUser otherUser = ChatUser(
//     name: "Mrfatty",
//     uid: "25649654",
//   );

//   List<ChatMessage> messages = <ChatMessage>[];
//   var m = <ChatMessage>[];

//   var i = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void systemMessage() {
//     Timer(Duration(milliseconds: 300), () {
//       if (i < 6) {
//         setState(() {
//           messages = [...messages, m[i]];
//         });
//         i++;
//       }
//       Timer(Duration(milliseconds: 300), () {
//         _chatViewKey.currentState.scrollController
//           ..animateTo(
//             _chatViewKey
//                 .currentState.scrollController.position.maxScrollExtent,
//             curve: Curves.easeOut,
//             duration: const Duration(milliseconds: 300),
//           );
//       });
//     });
//   }

//   void onSend(ChatMessage message) {
//     print(message.toJson());
//     FirebaseFirestore.instance
//         .collection('messages')
//         .doc(DateTime.now().millisecondsSinceEpoch.toString())
//         .set(message.toJson());
//   }


// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Chat App"),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('messages')
//               .orderBy("createdAt")
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Theme.of(context).primaryColor,
//                   ),
//                 ),
//               );
//             } else {
//               List<DocumentSnapshot> items = snapshot.data.docs;
//               var messages =
//                   items.map((i) => ChatMessage.fromJson(i.data())).toList();
//               return DashChat(
//                 key: _chatViewKey,
//                 inverted: false,
//                 onSend: onSend,
//                 sendOnEnter: true,
//                 textInputAction: TextInputAction.send,
//                 user: user,
//                 inputDecoration:
//                     InputDecoration.collapsed(hintText: "Add message here..."),
//                 dateFormat: DateFormat('yyyy-MMM-dd'),
//                 timeFormat: DateFormat('HH:mm'),
//                 messages: messages,
//                 showUserAvatar: true,
//                 showAvatarForEveryMessage: true,
//                 scrollToBottom: true,
//                 onPressAvatar: (ChatUser user) {
//                   print("OnPressAvatar: ${user.name}");
//                 },
//                 onLongPressAvatar: (ChatUser user) {
//                   print("OnLongPressAvatar: ${user.name}");
//                 },
//                 inputMaxLines: 5,
//                 messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
//                 alwaysShowSend: true,
//                 inputTextStyle: TextStyle(fontSize: 16.0),
//                 inputContainerStyle: BoxDecoration(
//                   border: Border.all(width: 0.0),
//                   color: Colors.white,
//                 ),
//                 onQuickReply: (Reply reply) {
//                   setState(() {
//                     messages.add(ChatMessage(
//                         text: reply.value,
//                         createdAt: DateTime.now(),
//                         user: user));

//                     messages = [...messages];
//                   });

//                   Timer(Duration(milliseconds: 300), () {
//                     _chatViewKey.currentState.scrollController
//                       ..animateTo(
//                         _chatViewKey.currentState.scrollController.position
//                             .maxScrollExtent,
//                         curve: Curves.easeOut,
//                         duration: const Duration(milliseconds: 300),
//                       );

//                     if (i == 0) {
//                       systemMessage();
//                       Timer(Duration(milliseconds: 600), () {
//                         systemMessage();
//                       });
//                     } else {
//                       systemMessage();
//                     }
//                   });
//                 },
//                 onLoadEarlier: () {
//                   print("laoding...");
//                 },
//                 shouldShowLoadEarlier: false,
//                 showTraillingBeforeSend: true,
//                 trailing: <Widget>[
//                   IconButton(
//                     icon: Icon(Icons.photo),
//                     onPressed: () async {
//                       final picker = ImagePicker();
//                       PickedFile result = await picker.pickImage(
//                         source: ImageSource.gallery,
//                         imageQuality: 80,
//                         maxHeight: 400,
//                         maxWidth: 400,
//                       );

//                       if (result != null) {
//                         final Reference storageRef =
//                             FirebaseStorage.instance.ref().child("chat_images");

//                         final taskSnapshot = await storageRef.putFile(
//                           File(result.path),
//                           SettableMetadata(
//                             contentType: 'image/jpg',
//                           ),
//                         );

//                         String url = await taskSnapshot.ref.getDownloadURL();

//                         ChatMessage message =
//                             ChatMessage(text: "", user: user, image: url);

//                         FirebaseFirestore.instance
//                             .collection('messages')
//                             .add(message.toJson());
//                       }
//                     },
//                   )
//                 ],
//               );
//             }
//           }),
//     );
//   }

// }