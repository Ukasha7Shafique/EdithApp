import 'package:edith/screens/connect_screen.dart';
import 'package:edith/screens/files_screen.dart';
import 'package:edith/screens/request_screen.dart';
import 'package:edith/screens/view_connect_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screens/main_page_screen.dart';
import '../provider/google_sign_in.dart';

class AppDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Info',
                  style: TextStyle(
                      fontSize: size.width * 0.07, color: Colors.black),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  user!.displayName.toString(),
                  style: TextStyle(
                      fontSize: size.width * 0.08,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, right: 7),
                      child: Icon(
                        FontAwesomeIcons.solidEnvelope,
                        size: size.width * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                    Text(user!.email.toString(),
                        style: TextStyle(
                            fontSize: size.width * 0.04, color: Colors.grey)),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.file_copy_rounded),
            title: Text('Main Files Page'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(DownloadScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.file_upload_rounded),
            title: Text('Upload a File'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(FilePage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.mobile_screen_share),
            title: Text('Connect to Other Device'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ConnectScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.mobile_screen_share),
            title: Text('View Connections'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed(ViewConnection.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.mobile_screen_share),
            title: Text('Incoming Requests'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed(RequestScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              signOutUser();
            },
          ),
        ],
      ),
    );
  }
}
