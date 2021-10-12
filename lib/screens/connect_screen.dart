import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edith/screens/connected_screen.dart';
import 'package:edith/widget/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'main_page_screen.dart';

class ConnectScreen extends StatefulWidget {
  static const routeName = '/Connect';
  static Map<String, String> _data = {'email': ''};

  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
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
                  Text('Connect to other devices',
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
              child: Container(
                padding: EdgeInsets.only(top: 40, left: 15, right: 2),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'This Screen Enable you to Connect to other device by taking a valid Email address',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                              fontSize: 18.0)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'E-Mail',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || value.contains('@')) {
                                return 'Invalid email!';
                              }
                            },
                            onSaved: (value) {
                              ConnectScreen._data['email'] = value.toString();

                              store(ConnectScreen._data['email'].toString());
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    child: Text('Connect'),
                                    onPressed: check,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 8.0),
                                    color: Colors.deepPurple[300],
                                    textColor: Theme.of(context)
                                        .primaryTextTheme
                                        .button!
                                        .color,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                FlatButton(
                                  child: Text('Request Connection'),
                                  onPressed: submit,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 8.0),
                                  color: Colors.deepPurple[300],
                                  textColor: Theme.of(context)
                                      .primaryTextTheme
                                      .button!
                                      .color,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void check() async {
    _formKey.currentState!.save();
    print('check called');

    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.email;
    final qn = await FirebaseFirestore.instance
        .collection('trusteduser')
        .doc('users')
        .collection(uid.toString())
        .where('email', isEqualTo: ConnectScreen._data['email'].toString())
        .get();
    qn.docs;
    print(qn.docs);
    if (qn.docs.isEmpty) {
      print('Empty value');
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: new Text("An Error Occured..."),
              content: Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reasons",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('1) User is not registered.'),
                    SizedBox(
                      height: 5,
                    ),
                    Text('2) user is not verified as trusted user'),
                  ],
                ),
              ),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          });
    } else {
      print('goto connection page ');
      Navigator.of(context).pushReplacementNamed(ConnectedFileScreen.routeName);
    }
  }

  void submit() async {
    _formKey.currentState!.save();
    print('Submit called');
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.email;
    final qn = await FirebaseFirestore.instance
        .collection('registeredUsers')
        .doc('users')
        .collection(ConnectScreen._data['email'].toString())
        .get();
    qn.docs;
    if (qn.docs.isEmpty) {
      print('Empty value');
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: new Text("An Error Occured..."),
              content: Container(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reasons",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('1) User is not registered.'),
                  ],
                ),
              ),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          });
    } else {
      String id = Uuid().v4();
      FirebaseFirestore.instance
          .collection('request')
          .doc('users')
          .collection(ConnectScreen._data['email'].toString())
          .doc(id)
          .set({"id": id, "name": user.displayName, "email": uid.toString()});
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: new Text("Request sent successfully"),
              content: Container(
                height: 20,
              ),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ConnectScreen.routeName);
                  },
                  child: Text("Ok"),
                ),
              ],
            );
          });
    }
  }

  void store(String email) async {
    SharedPreferences pref2 = await SharedPreferences.getInstance();
    final id = pref2.getString('email');
    id != null ? pref2.remove('email') : pref2.setString('email', email);
  }
}
