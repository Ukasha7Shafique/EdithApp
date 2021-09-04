import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:edith/models/firebase_file.dart';
import 'package:edith/provider/firebase_api.dart';
import 'package:edith/widget/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    final sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll();

    ///register a send port for the other isolates
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      print(progress);
    });

    FlutterDownloader.registerCallback(downloadingCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edith',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0)),
        centerTitle: true,
        backgroundColor: Color(0xFF21BFBD),
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
        shadowColor: Color(0xFF21BFBD),
      ),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF21BFBD),
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
                Text('Main',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0)),
                SizedBox(width: 10.0),
                Text('Page',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 25.0))
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

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: files!.length,
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
                                            'Downloading ${file.name}.......'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar1);
                                    // store to trusted user table
                                    // delete from request table
                                    Reference ref = file.ref;
                                    final String url =
                                        await ref.getDownloadURL();
                                    final status =
                                        await Permission.storage.request();

                                    if (status.isGranted) {
                                      final externalDir =
                                          await getExternalStorageDirectory();

                                      final id =
                                          await FlutterDownloader.enqueue(
                                        url: url,
                                        savedDir: externalDir!.path,
                                        fileName: file.name,
                                        showNotification: true,
                                        openFileFromNotification: true,
                                      );
                                    } else {
                                      print("Permission deined");
                                    }
                                    // await FirebaseApi.downloadjFile(file.ref);

                                    final snackBar = SnackBar(
                                        content:
                                            Text('Downloaded ${file.name}'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
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
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
