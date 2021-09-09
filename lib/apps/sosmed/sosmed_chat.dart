import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:genius/apps/sosmed/sosmed_chat_message.dart';
import 'package:genius/apps/sosmed/sosmed_story_view.dart';

class SosmedChat extends StatefulWidget {
  const SosmedChat({Key key,this.photo}) : super(key: key);
  final Uint8List photo;
  @override
  _SosmedChatState createState() => _SosmedChatState();
}

class _SosmedChatState extends State<SosmedChat> {
  TextEditingController _searchController = new TextEditingController();
  List storyList = [
    {
      "name": "Novac",
      "imageUrl": "https://randomuser.me/api/portraits/men/31.jpg",
      "isOnline": true,
      "hasStory": true,
    },
    {
      "name": "Derick",
      "imageUrl": "https://randomuser.me/api/portraits/men/81.jpg",
      "isOnline": false,
      "hasStory": false,
    },
    {
      "name": "Mevis",
      "imageUrl": "https://randomuser.me/api/portraits/women/49.jpg",
      "isOnline": true,
      "hasStory": false,
    },
    {
      "name": "Emannual",
      "imageUrl": "https://randomuser.me/api/portraits/men/35.jpg",
      "isOnline": true,
      "hasStory": true,
    },
    {
      "name": "Gracy",
      "imageUrl": "https://randomuser.me/api/portraits/women/56.jpg",
      "isOnline": false,
      "hasStory": false,
    },
    {
      "name": "Robert",
      "imageUrl": "https://randomuser.me/api/portraits/men/36.jpg",
      "isOnline": false,
      "hasStory": true,
    }
  ];

  List conversationList = [
    {
      "name": "Novac",
      "imageUrl": "https://randomuser.me/api/portraits/men/31.jpg",
      "isOnline": true,
      "isOpened": false,
      "hasStory": true,
      "message":
          "Where are you asak sdkjgja aksjfa aksjgkasg gakjssfkas ckajsfkja skjasgjhasjkfh caksjgkashg?",
      "time": "5:00 pm"
    },
    {
      "name": "Derick",
      "imageUrl": "https://randomuser.me/api/portraits/men/81.jpg",
      "isOnline": false,
      "isOpened": true,
      "hasStory": false,
      "message": "It's good!!",
      "time": "7:00 am"
    },
    {
      "name": "Mevis",
      "imageUrl": "https://randomuser.me/api/portraits/women/49.jpg",
      "isOnline": true,
      "isOpened": true,
      "hasStory": false,
      "message": "I love You too!",
      "time": "6:50 am"
    },
    {
      "name": "Emannual",
      "imageUrl": "https://randomuser.me/api/portraits/men/35.jpg",
      "isOnline": true,
      "hasStory": true,
      "message": "Got to go!! Bye!!",
      "time": "yesterday"
    },
    {
      "name": "Gracy",
      "imageUrl": "https://randomuser.me/api/portraits/women/56.jpg",
      "isOnline": false,
      "isOpened": true,
      "hasStory": false,
      "message": "Sorry, I forgot!",
      "time": "2nd Feb"
    },
    {
      "name": "Robert",
      "imageUrl": "https://randomuser.me/api/portraits/men/36.jpg",
      "isOnline": false,
      "hasStory": true,
      "message": "No, I won't go!",
      "time": "28th Jan"
    },
    {
      "name": "Lucy",
      "imageUrl": "https://randomuser.me/api/portraits/women/56.jpg",
      "isOnline": false,
      "isOpened": true,
      "hasStory": false,
      "message": "Hahahahahaha",
      "time": "25th Jan"
    },
    {
      "name": "Emma",
      "imageUrl": "https://randomuser.me/api/portraits/women/56.jpg",
      "isOnline": false,
      "isOpened": true,
      "hasStory": false,
      "message": "Been a while!",
      "time": "15th Jan"
    }
  ];

  _conversations(BuildContext context) {
    return Column(
      children: List.generate(conversationList.length, (index) {
        return InkWell(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>StoryViewPage()));
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Stack(
                      children: <Widget>[
                        conversationList[index]['hasStory']
                            ? Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.blueAccent, width: 3)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                conversationList[index]
                                                    ['imageUrl']),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              )
                            : Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            conversationList[index]['imageUrl']),
                                        fit: BoxFit.cover)),
                              ),
                        conversationList[index]['isOnline']
                            ? Positioned(
                                top: 38,
                                left: 42,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF66BB6A),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Color(0xFFFFFFFF), width: 3)),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (BuildContext context)=> SosmedChatMessage()
                    // ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        conversationList[index]['name'],
                        style:
                            TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 135,
                        child: Text(
                          conversationList[index]['time'] +
                              " - " +
                              conversationList[index]['message'],
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: conversationList[index]['isOpened'] == true ? FontWeight.normal : FontWeight.bold,
                              color: Color(0xFF000000).withOpacity(0.7)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  _stories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFe9eaec)),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 33,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 75,
                  child: Align(
                      child: Text(
                    'Your Story',
                    overflow: TextOverflow.ellipsis,
                  )),
                )
              ],
            ),
          ),
          Row(
              children: List.generate(storyList.length, (index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> StoryViewPage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      child: Stack(
                        children: <Widget>[
                          storyList[index]['hasStory']
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.blueAccent, width: 3)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      width: 75,
                                      height: 75,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  storyList[index]['imageUrl']),
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              storyList[index]['imageUrl']),
                                          fit: BoxFit.cover)),
                                ),
                          storyList[index]['isOnline']
                              ? Positioned(
                                  top: 38,
                                  left: 42,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF66BB6A),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color(0xFFFFFFFF), width: 3)),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 75,
                      child: Align(
                          child: Text(
                        storyList[index]['name'],
                        overflow: TextOverflow.ellipsis,
                      )),
                    )
                  ],
                ),
              ),
            );
          }))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        title: Text('Chats & Story',
            style: TextStyle(
                fontFamily: "calibri", color: Colors.black, fontSize: 25)),
        elevation: 0.0,
        titleSpacing: 0.0,
        leadingWidth: 80,
        iconTheme: IconThemeData(color: Color(0xff333333)),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(7.0),
            child: CircleAvatar(
              backgroundImage: widget.photo != '' ? Image.memory(widget.photo).image : AssetImage('assets/img/default.jpg'),
            ),
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 15.0, top: 15),
              child: GestureDetector(
                  onTap: () {},
                  child: Stack(children: [
                    Icon(
                      Icons.add_comment_outlined,
                      size: 30,
                    )
                  ]))),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xFFe9eaec),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                cursorColor: Color(0xFF000000),
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF000000).withOpacity(0.5),
                    ),
                    hintText: "Search",
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            _stories(),

            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  _conversations(context),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
