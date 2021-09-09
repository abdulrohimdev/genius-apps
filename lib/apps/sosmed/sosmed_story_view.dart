import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:story_view/story_view.dart';

class StoryViewPage extends StatefulWidget {
  const StoryViewPage({ Key key }) : super(key: key);

  @override
  _StoryViewPageState createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
      body: StoryView(
          storyItems: [
            StoryItem.text(
              title: "I guess you'd love to see more of our food. That's great.",
              backgroundColor: Colors.blue,
            ),
            StoryItem.text(
              title: "Nice!\n\nTap to continue.", 
              backgroundColor: Colors.red,
              textStyle: TextStyle(
                fontFamily: 'Dancing',
                fontSize: 40,
              ),
            ),
            StoryItem.pageImage(
              url:
                  "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
              caption: "Still sampling",
              controller: storyController,
            ),
            StoryItem.pageImage(
                url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                caption: "Working with gifs",
                controller: storyController),
            StoryItem.pageImage(
              url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
              caption: "Hello, from the other side",
              controller: storyController,
            ),
            StoryItem.pageImage(
              url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
              caption: "Hello, from the other side2",
              controller: storyController,
            ),
          ],
          onStoryShow: (s) {
            print("Showing a story");
          },
          onComplete: () {
            Navigator.pop(context);
          },
          progressPosition: ProgressPosition.top,
          repeat: false,
          controller: storyController,
        ),
      ),
    );
  }
}