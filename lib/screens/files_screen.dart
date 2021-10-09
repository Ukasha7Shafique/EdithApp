import 'dart:io';
import 'package:edith/provider/firebase_api.dart';
import 'package:edith/screens/main_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import '../Widget/app_drawer.dart';

class FilePage extends StatefulWidget {
  static const routeName = '/filePage';
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final user = FirebaseAuth.instance.currentUser;
  UploadTask? task;
  File? file;
  String? userId;
  @override
  void initState() {
    super.initState();
    userId = user!.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        title: Text('Edith',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0)),
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
                Text('Upload Page',
                    style: TextStyle(
                        fontFamily: 'Horizonn',
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
                    child: Container(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple[300],
                                minimumSize: Size.fromHeight(50),
                              ),
                              child: Text('Select File'),
                              onPressed: selectFile,
                            ),
                            SizedBox(height: 8),
                            Text(
                              fileName,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 150),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple[300],
                                minimumSize: Size.fromHeight(50),
                              ),
                              child: Text('Upload File'),
                              onPressed: uploadFile,
                            ),
                            SizedBox(height: 20),
                            task != null
                                ? buildUploadStatus(task!)
                                : Container(),
                          ],
                        ),
                      ),
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file!.path);
    print(userId);
    final destination = 'files/$userId/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
