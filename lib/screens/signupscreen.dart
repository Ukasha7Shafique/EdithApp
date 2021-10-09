import 'package:edith/widget/background_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../provider/google_sign_in.dart';
import '../screens/home_page.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/Signupscreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name;
  String? email;
  String? password;
  Icon passIcon = Icon(Icons.visibility_off);
  Icon passIcon1 = Icon(Icons.visibility_off);
  bool _obscureText = true;
  bool _obscureConfirmText = true;
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
                          obscureText: _obscureConfirmText,
                          decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(
                                Icons.lock,
                                color: Color(0xFF6F35A5),
                              ),
                              suffixIcon: IconButton(
                                icon: passIcon1,
                                onPressed: () {
                                  setState(
                                    () {
                                      _obscureConfirmText =
                                          !_obscureConfirmText;
                                      //below is the  conditional statement changing the suffix icon based on the value of _obscureText
                                      _obscureConfirmText
                                          ? passIcon1 =
                                              Icon(Icons.visibility_off)
                                          : passIcon1 = Icon(Icons.visibility);
                                    },
                                  );
                                },
                                color: Color(0xFF6F35A5),
                              ),
                              border: InputBorder.none,
                              labelText: "Confirm Password"),
                          validator: (val) {
                            if (val!.isEmpty) return 'This field is required';
                            if (val != password) return 'Password must be same';
                            if (val.length < 6) {
                              return 'Password must be same';
                            }
                            return null;
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
              SizedBox(
                height: 5.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
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
