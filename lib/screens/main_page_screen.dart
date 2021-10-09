import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:edith/models/firebase_file.dart';
import 'package:edith/provider/firebase_api.dart';
import 'package:edith/widget/app_drawer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Widget/voice_button.dart';

// import '../models/firebase_file.dart';
// import 'package:open_file/open_file.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);
  static const routeName = '/downloadScreen';
  static void startVOiceInput(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: VoiceButton(),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final Dio dio = Dio();
  bool loading = false;
  double progress = 0;
  final user = FirebaseAuth.instance.currentUser;
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edith',
            style: TextStyle(
                fontFamily: 'Horizonn', color: Colors.white, fontSize: 25.0)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.mic),
            color: Colors.white,
            onPressed: () => DownloadScreen.startVOiceInput(context),
          ),
        ],
        shadowColor: Colors.deepPurple[200],
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => DownloadScreen.startVOiceInput(context),
        child: const Icon(Icons.mic),
        backgroundColor: Colors.deepPurple[300],
      ),
      backgroundColor: Colors.deepPurple[200],
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('Home Page',
                    style: TextStyle(
                        fontFamily: 'Horizonn',
                        color: Colors.white,
                        fontSize: 25.0)),
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 300.0,
                    child: FutureBuilder<List<FirebaseFile>>(
                      future: futureFiles,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Some error occurred!'));
                            } else {
                              final files = snapshot.data;

                              if (files!.isEmpty) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const SizedBox(width: 20.0, height: 100.0),
                                    const Text(
                                      'Start',
                                      style: TextStyle(
                                        fontSize: 32.0,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Horizon',
                                      ),
                                    ),
                                    const SizedBox(width: 20.0, height: 100.0),
                                    DefaultTextStyle(
                                      style: const TextStyle(
                                        fontSize: 40.0,
                                        color: Colors.deepPurple,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Horizon',
                                      ),
                                      child: AnimatedTextKit(
                                          repeatForever: true,
                                          isRepeatingAnimation: true,
                                          animatedTexts: [
                                            RotateAnimatedText('Connecting'),
                                            RotateAnimatedText('Sending'),
                                            RotateAnimatedText('Receiving'),
                                          ]),
                                    ),
                                  ],
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: files.length,
                                      itemBuilder: (context, index) {
                                        final file = files[index];
                                        Size size = MediaQuery.of(context).size;
                                        return buildFile(context, file, size);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file, Size size) =>
      GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Container(
              width: size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 5),
                        child: Icon(Icons.folder),
                      ),
                      Container(
                        child: Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 5, right: 10),
                            child: Text(
                              file.name,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Are you sure?'),
                              content:
                                  new Text('Do you want to delete the file?'),
                              actions: <Widget>[
                                new TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: new Text('No',
                                      style: TextStyle(color: Colors.red)),
                                ),
                                new TextButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    );
                                    // store to trusted user table
                                    // delete from request table

                                    await FirebaseApi.deleteFile(file);

                                    final snackBar = SnackBar(
                                        content: Text('Deleted ${file.name}'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.of(context).pushReplacementNamed(
                                        DownloadScreen.routeName);
                                  },
                                  child: new Text('Yes',
                                      style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('Delete file',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Are you sure?'),
                              content:
                                  new Text('Do you want to download the file?'),
                              actions: <Widget>[
                                new TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: new Text('No',
                                      style: TextStyle(color: Colors.red)),
                                ),
                                new TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();

                                    final snackBar1 = SnackBar(
                                        content: Text(
                                            'Downloaded ${file.name}.......'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar1);
                                    // store to trusted user table

                                    await FirebaseApi.downloadFile(file.ref);
                                  },
                                  child: new Text('Yes',
                                      style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('Download file',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
