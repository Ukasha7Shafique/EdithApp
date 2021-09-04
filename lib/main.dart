import 'package:edith/screens/connect_screen.dart';
import 'package:edith/screens/connected_screen.dart';
import 'package:edith/screens/files_screen.dart';
import 'package:edith/screens/home_page.dart';
import 'package:edith/screens/main_page_screen.dart';
import 'package:edith/screens/request_screen.dart';
import 'package:edith/screens/view_connect_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:edith/screens/onboard/onboard.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edith',
      debugShowCheckedModeBanner: false,
      home: Onboard(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        FilePage.routeName: (ctx) => FilePage(),
        DownloadScreen.routeName: (ctx) => DownloadScreen(),
        ConnectScreen.routeName: (ctx) => ConnectScreen(),
        ConnectedFileScreen.routeName: (ctx) => ConnectedFileScreen(),
        ViewConnection.routeName: (ctx) => ViewConnection(),
        RequestScreen.routeName: (ctx) => RequestScreen(),
      },
    );
  }
}
