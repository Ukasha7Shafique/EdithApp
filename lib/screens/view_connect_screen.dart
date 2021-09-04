import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edith/screens/main_page_screen.dart';
import 'package:edith/widget/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewConnection extends StatefulWidget {
  const ViewConnection({Key? key}) : super(key: key);
  static const routeName = '/view';

  @override
  _ViewConnectionState createState() => _ViewConnectionState();
}

class _ViewConnectionState extends State<ViewConnection> {
  Future getDocs() async {
    final uid = FirebaseAuth.instance.currentUser!.email;
    final fr = FirebaseFirestore.instance;
    final qn = await fr
        .collection('trusteduser')
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
        backgroundColor: Color(0xFF69F0AE),
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
        shadowColor: Color(0xFF69F0AE),
      ),
      drawer: AppDrawer(),
      backgroundColor: Color(0xFF69F0AE),
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
                SizedBox(width: 10.0),
                Text(' devices',
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
                          color: Color(0xFF69F0AE),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return userCard(
                              context,
                              snapshot.data[index]['id'],
                              snapshot.data[index]['name'],
                              snapshot.data[index]['email']);
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

Widget userCard(BuildContext context, String id, String name, String email) {
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
                          content: new Text('Do you want to delete the user?'),
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
                                String? uid =
                                    FirebaseAuth.instance.currentUser!.email;
                                FirebaseFirestore.instance
                                    .collection('trusteduser')
                                    .doc('users')
                                    .collection(uid.toString())
                                    .doc(id)
                                    .delete();
                                Navigator.of(context).pushReplacementNamed(
                                    ViewConnection.routeName);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('User Deleted')));
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
                        child: Text('Delete User',
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
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
