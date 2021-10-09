import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edith/screens/main_page_screen.dart';
import 'package:edith/widget/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);
  static const routeName = '/view_request';

  @override
  _RequestScreen createState() => _RequestScreen();
}

class _RequestScreen extends State<RequestScreen> {
  Future getDocs() async {
    final uid = FirebaseAuth.instance.currentUser!.email;
    final fr = FirebaseFirestore.instance;
    final qn = await fr
        .collection('request')
        .doc('users')
        .collection(uid.toString())
        .get();
    return qn.docs;
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
                Text('Incoming Requests',
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
            child: Container(
              child: FutureBuilder<dynamic>(
                  future: getDocs(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple[300],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return requestCard(
                              context,
                              snapshot.data[index].data()['id'],
                              snapshot.data[index].data()['name'],
                              snapshot.data[index].data()['email']);
                        },
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

Widget requestCard(BuildContext context, String id, String name, String email) {
  Size size = MediaQuery.of(context).size;
  return GestureDetector(
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
                    child: Text(
                      'Name: ',
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5, right: 10),
                        child: Text(
                          name,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 5),
                    child: Text(
                      'Email: ',
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5, right: 10),
                        child: Text(
                          email,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                              new Text('Do you want to Decline the request?'),
                          actions: <Widget>[
                            new TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: new Text('No',
                                  style: TextStyle(color: Colors.red[900])),
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
                                String? uid =
                                    FirebaseAuth.instance.currentUser!.email;
                                await FirebaseFirestore.instance
                                    .collection('request')
                                    .doc('users')
                                    .collection(uid.toString())
                                    .doc(id)
                                    .delete();
                                Navigator.of(context).pushReplacementNamed(
                                    RequestScreen.routeName);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Request Declined')));
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
                        child: Text('Decline Request',
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
                              new Text('Do you want to accept the request?'),
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
                                final uid = FirebaseAuth.instance.currentUser;
                                String uuid = Uuid().v4();
                                // store to trusted user table
                                await FirebaseFirestore.instance
                                    .collection('trusteduser')
                                    .doc('users')
                                    .collection(email)
                                    .doc(uuid)
                                    .set({
                                      "id": uuid,
                                      "name": uid!.displayName.toString(),
                                      "email": uid.email.toString()
                                    })
                                    .then((_) => {
                                          FirebaseFirestore.instance
                                              .collection('request')
                                              .doc('users')
                                              .collection(uid.email.toString())
                                              .doc(id)
                                              .delete(),
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  RequestScreen.routeName),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Request Accepted'))),
                                        })
                                    .catchError((onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text(onError)));
                                      print('added to trusted user');
                                    });
                                // delete from request table
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
                        child: Text('Accept Request',
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
