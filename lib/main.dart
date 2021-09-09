import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:genius/apps/PageError/PageNotFound.dart';
import 'package:genius/apps/chating/Chating.dart';
import 'package:genius/apps/module/request/CheckPermitForm.dart';
import 'package:genius/apps/module/request/Request.dart';
import 'package:genius/apps/module/quality-product-reject/FormProductReject.dart';
import 'package:genius/apps/module/request/RequestLeaveDetail.dart';
import 'package:genius/apps/welcome/home_screen_v2.dart';
import 'package:genius/apps/welcome/welcome_first.dart';
import 'package:genius/apps/module/profile/profile_account.dart';
import 'package:genius/apps/welcome/welcome_first_rev.dart';
import 'package:new_version/new_version.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
    print(message);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    final newVersion = NewVersion(
      iOSId: 'com.hgu.id',
      androidId: 'com.hgu.id',
    );

     const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      print(message);
    });
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    debugPrint(status.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: 'Update',
      dialogText: 'with new version please!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genius ESS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      builder: EasyLoading.init(),
      routes: {
        '/': (context) => SplashScreenRev1(),
        '/home-screen': (context) => HomeScreenV2(),
        '/profile': (context) => AccountProfile(),
        '/product-reject': (context) => FormProductReject(),
        '/leave-request': (context) => Request(),
        '/error': (context) => PageNotFound(),
        '/notification': (context) => Chating(),
        '/request_leave_detail': (context) => RequestLeaveDetail(
              id: null,
            ),
        '/checkout-permit-form': (context) => CheckPermitForm(),
      },
    );
  }
}
