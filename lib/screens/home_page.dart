import 'package:edith/screens/signupscreen.dart';
import 'package:edith/widget/background_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../provider/google_sign_in.dart';
import 'main_page_screen.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? forgetMail;
  String? password;
  int counter = 3;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  Icon passIcon = Icon(Icons.visibility_off);
  void login() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      signin(email.toString(), password.toString(), context).then(
        (value) async {
          if (value != null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DownloadScreen(),
                ));
          } else {
            if (counter <= 1) {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: new Text("You can not login again"),
                    content: Container(
                      height: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kindly try again after sometime",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Text("Ok"),
                      ),
                    ],
                  );
                },
              );
              counter = 3;
            } else {
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
                          Text('2) Verify user'),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'You have $counter tries left',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                },
              );
              counter--;
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "LOGIN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.30,
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 7),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Color(0xFFF1E6FF),
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Color(0xFF6F35A5),
                              ),
                              border: InputBorder.none,
                              labelText: "Email"),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This Field Is Required"),
                            EmailValidator(errorText: "Invalid Email Address"),
                          ]),
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 7),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Color(0xFFF1E6FF),
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(
                                Icons.lock,
                                color: Color(0xFF6F35A5),
                              ),
                              suffixIcon: IconButton(
                                icon: passIcon,
                                onPressed: () {
                                  setState(
                                    () {
                                      _obscureText = !_obscureText;
                                      //below is the  conditional statement changing the suffix icon based on the value of _obscureText
                                      _obscureText
                                          ? passIcon =
                                              Icon(Icons.visibility_off)
                                          : passIcon = Icon(Icons.visibility);
                                    },
                                  );
                                },
                                color: Color(0xFF6F35A5),
                              ),
                              border: InputBorder.none,
                              labelText: "Password"),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Password Is Required"),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required"),
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      InkWell(
                        onTap: forgetPass,
                        child: Container(
                          margin: EdgeInsets.only(left: 150),
                          child: Text(
                            "Forget Password?",
                            style: TextStyle(
                              color: Color(0xFF6F35A5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40)),
                            ),
                            // passing an additional context parameter to show dialog boxs
                            onPressed: login,
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context)
                      .pushReplacementNamed(SignUpScreen.routeName);
                },
                child: Text(
                  "Sign Up Here",
                  style: TextStyle(color: Color(0xFF6F35A5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void forgetPass() async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: new Text("Please provide your email"),
            content: Container(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          color: Color(0xFF6F35A5),
                        ),
                        // border: InputBorder.none,
                        labelText: "Email"),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "This Field Is Required"),
                      EmailValidator(errorText: "Invalid Email Address"),
                    ]),
                    onChanged: (val) {
                      forgetMail = val;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: forgetMail.toString());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email Send Successfully')));
                  } on Exception catch (e) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text('Invalid Email'),
                            actions: [
                              OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Ok'))
                            ],
                          );
                        });
                  }
                },
                child: Text("Send mail"),
              ),
            ],
          );
        });
  }
}
