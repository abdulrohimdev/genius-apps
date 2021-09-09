import 'package:genius/apps/welcome/home_screen_v2.dart';
import 'package:genius/apps/welcome/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class SplashScreenRev1 extends StatefulWidget {
  const SplashScreenRev1({Key key}) : super(key: key);
  @override
  _SplashScreenRev1State createState() => _SplashScreenRev1State();
}

class _SplashScreenRev1State extends State<SplashScreenRev1> {
  VideoPlayerController _controller;
  bool loading = true;
  bool loggedIn = false;

  Future _isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogedIn') != null) {
      setState(() {
        loggedIn = true;
      });
    }
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (c) => loggedIn ? HomeScreenV2() : SigninScreen()));
    });
  }


  Future video() {
    _controller = VideoPlayerController.asset('assets/img/hgu.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _isLogin();
        });
      });
  }

  @override
  void initState() {
    super.initState();
    video();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
