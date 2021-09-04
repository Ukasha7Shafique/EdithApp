import 'package:edith/screens/main_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Widget/app_drawer.dart';
import '../provider/firebase_api.dart';
import '../models/firebase_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedFileScreen extends StatefulWidget {
  const ConnectedFileScreen({Key? key}) : super(key: key);
  static const routeName = '/connectedFileScreen';

  @override
  _ConnectedFileScreenState createState() => _ConnectedFileScreenState();
}

class _ConnectedFileScreenState extends State<ConnectedFileScreen> {
  late Future<List<FirebaseFile>> futureFiles;
  final user = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    futureFiles = listConnected();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  Text('Connected',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: files!.length,
                                        itemBuilder: (context, index) {
                                          final file = files[index];
                                          Size size =
                                              MediaQuery.of(context).size;
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

                                    await FirebaseApi.downloadFile(file.ref);

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

  static Future<List<FirebaseFile>> listConnected() async {
    SharedPreferences reference = await SharedPreferences.getInstance();
    String? path1 = reference.getString('email');
    String path = 'files/$path1/';
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await FirebaseApi.getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }
}
