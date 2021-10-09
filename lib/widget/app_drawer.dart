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
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  user!.displayName.toString(),
                  style: TextStyle(
                      fontSize: size.width * 0.08,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, right: 7),
                      child: Icon(
                        FontAwesomeIcons.solidEnvelope,
                        size: size.width * 0.04,
                        color: Colors.blueGrey[600],
                      ),
                    ),
                    Text(user!.email.toString(),
                        style: TextStyle(
                            fontSize: size.width * 0.04,
                            color: Colors.black87)),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple[200],
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
            title: Text('Trusted Users'),
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
              signOutUser(context);
            },
          ),
        ],
      ),
    );
  }
}
