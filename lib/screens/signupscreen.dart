import 'package:edith/screens/main_page_screen.dart';
import 'package:edith/widget/background_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/google_sign_in.dart';
import '../screens/home_page.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name;
  String? email;
  String? password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void handleSignup() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      signUp(name.toString(), email!.trim(), password.toString(), context)
          .then((value) {
        if (value != null) {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: new Text("User Registered Successfully."),
                content: Container(
                  height: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Instructions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('1- An Email is sent to you.'),
                      SizedBox(
                        height: 5,
                      ),
                      Text('2- Verify Your email and login'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                    child: Text("Login Page"),
                  ),
                ],
              );
            },
          );
        }
      });
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
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),
              SvgPicture.asset(
                "assets/icons/signup.svg",
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
                              labelText: "Name"),
                          validator: (_val) {
                            if (_val!.isEmpty) {
                              return "Can't be empty";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            name = val;
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
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.mail,
                                color: Color(0xFF6F35A5),
                              ),
                              border: InputBorder.none,
                              labelText: "Email"),
                          validator: (_val) {
                            if (_val!.isEmpty) {
                              return "Can't be empty";
                            } else {
                              return null;
                            }
                          },
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
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(
                                Icons.lock,
                                color: Color(0xFF6F35A5),
                              ),
                              suffixIcon: Icon(
                                Icons.visibility,
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
                            onPressed: handleSignup,
                            child: Text(
                              "Sign Up",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => googleSignIn().whenComplete(() async {
                      final user = FirebaseAuth.instance.currentUser;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => DownloadScreen()));
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('mail', user!.email.toString());
                    }),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color(0xFFF1E6FF),
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/google-plus.svg",
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Login Here",
                  style: TextStyle(color: Color(0xFF6F35A5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
