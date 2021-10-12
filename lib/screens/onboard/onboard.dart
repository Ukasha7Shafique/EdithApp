import 'package:edith/screens/main_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:edith/models/onboard_page_item.dart';
import 'package:edith/widget/fading_sliding_widget.dart';
import 'package:edith/screens/onboard/welcome_page.dart';
import 'package:edith/screens/onboard/onboard_page.dart';
import 'package:edith/screens/home_page.dart';
import 'dart:io';

class Onboard extends StatefulWidget {
  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> with SingleTickerProviderStateMixin {
  List<OnboardPageItem> onboardPageItems = [
    OnboardPageItem(
      lottieAsset: 'assets/animations/group_working.json',
      text: 'Do all your office work in a lively manner',
      animationDuration: const Duration(milliseconds: 1100),
    ),
  ];

  late PageController _pageController;

  List<Widget> onboardItems = [];
  double? _activeIndex;
  bool onboardPage = false;
  late AnimationController _animationController;

  @override
  void initState() {
    initializePages(); //initialize pages to be shown
    _pageController = PageController();
    _pageController.addListener(() {
      _activeIndex = _pageController.page;
      print("Active Index: $_activeIndex");
      if (_activeIndex! >= 0.5 && onboardPage == false) {
        setState(() {
          onboardPage = true;
        });
      } else if (_activeIndex! < 0.5) {
        setState(() {
          onboardPage = false;
        });
      }
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..forward();
    super.initState();
  }

  initializePages() {
    onboardItems.add(WelcomePage()); // welcome page
    onboardPageItems.forEach((onboardPageItem) {
      //adding onboard pages
      onboardItems.add(OnboardPage(
        onboardPageItem: onboardPageItem,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: onboardItems,
            ),
          ),
          Positioned(
            bottom: height * 0.15,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardItems.length,
              effect: WormEffect(
                dotWidth: width * 0.03,
                dotHeight: width * 0.03,
                dotColor: onboardPage
                    ? const Color(0x11000000)
                    : const Color(0x566FFFFFF),
                activeDotColor: onboardPage
                    ? const Color(0xFF9544d0)
                    : const Color(0xFFFFFFFF),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: GestureDetector(
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                String? check = pref.getString('mail');
                if (check == null) {
                  try {
                    final result = await InternetAddress.lookup('example.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    }
                  } on SocketException catch (_) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: new Text("No Internet Connection"),
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
                                Text(
                                    'Check your internet connection and try again'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            OutlinedButton(
                              onPressed: () => SystemNavigator.pop(),
                              child: Text("Exit"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  try {
                    final result = await InternetAddress.lookup('example.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      Navigator.of(context)
                          .pushReplacementNamed(DownloadScreen.routeName);
                    }
                  } on SocketException catch (_) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: new Text("No Internet Connection"),
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
                                Text(
                                    'Check your internet connection and try again'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            OutlinedButton(
                              onPressed: () => SystemNavigator.pop(),
                              child: Text("Exit"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: FadingSlidingWidget(
                animationController: _animationController,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  alignment: Alignment.center,
                  width: width * 0.8,
                  height: height * 0.075,
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: onboardPage
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF220555),
                      fontSize: width * 0.05,
                      fontFamily: 'ProductSans',
                    ),
                  ),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.1),
                    ),
                    gradient: LinearGradient(
                      colors: onboardPage
                          ? [
                              const Color(0xFF8200FF),
                              const Color(0xFFFF3264),
                            ]
                          : [
                              const Color(0xFFFFFFFF),
                              const Color(0xFFFFFFFF),
                            ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
