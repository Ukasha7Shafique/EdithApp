import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

// a simple sialog to be visible everytime some error occurs
showErrDialog(BuildContext context, String err) {
  // to hide the keyboard, if it is still p
  FocusScope.of(context).requestFocus(new FocusNode());
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Error"),
      content: Text(err),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    ),
  );
}

// many unhandled google error exist
// will push them soon
Future googleSignIn() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  // pref.setString('mail', user!.email.toString());
  GoogleSignInAccount? googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    await auth.signInWithCredential(credential);

    final user = auth.currentUser;
    print(user!.uid);
    pref.setString('mail', user.email.toString());

    return Future.value(true);
  }
}

// returning user to directly access UserID
Future signin(String email, String password, BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  try {
    final auth = FirebaseAuth.instance;
    final result =
        await auth.signInWithEmailAndPassword(email: email, password: email);
    final user = result.user;
    // return Future.value(true);
    if (user!.emailVerified) {
      pref.setString('mail', user.email.toString());
      return Future.value(user);
    }
    return Future.value(null);
  } catch (e) {
    // simply passing error code as a message
    print(e.toString());
    switch (e.toString()) {
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_WRONG_PASSWORD':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_USER_NOT_FOUND':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_USER_DISABLED':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        showErrDialog(context, e.toString());
        break;
    }
    return Future.value(null);
  }
}

// change to Future<FirebaseUser> for returning a user
Future signUp(
    String name, String email, String password, BuildContext context) async {
  try {
    final result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;
    user!.updateDisplayName(name);
    user.sendEmailVerification();
    return Future.value(user);
    // return Future.value(true);
  } catch (error) {
    switch (error.toString()) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        showErrDialog(context, "Email Already Exists");
        break;
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, "Invalid Email Address");
        break;
      case 'ERROR_WEAK_PASSWORD':
        showErrDialog(context, "Please Choose a stronger password");
        break;
    }
    return Future.value(null);
  }
}

Future signOutUser() async {
  await gooleSignIn.disconnect();
  FirebaseAuth.instance.signOut();
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove('mail');
  return Future.value(true);
}
