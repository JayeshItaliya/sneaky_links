import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sneaky_links/Pages/AuthScreen/signIn.dart';
import 'package:sneaky_links/Pages/permissionPage.dart';
import 'package:sneaky_links/flutter_flow/flutter_flow_theme.dart';


class OnBoardingView extends StatefulWidget {
  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int pageIndex = 0;
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: PageView(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index) {
                        setState(() {
                          // set page index to current index of page
                          pageIndex = index;
                        });
                      },
                      children: [
                        // Here I'm calling my image with text method for rendering

                        _centerImageWithText(
                          image: 'assets/images/partner.png',
                          text: "Join the Party",
                          text1:
                              "Gain exclusive access to private online parties",
                        ),
                        _centerImageWithText(
                            image: 'assets/images/nearby.png',
                            text: "Match",
                            text1:
                                "Get matched with others nearby that meet\nyour preferences"),
                        _centerImageWithText(
                            image: 'assets/images/msg.png',
                            text: "Stay Safe",
                            text1:
                                "Create and join real time chats\nthat disappear when you are\nfinished with them"),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.all(8.0),

                          // Here I'm calling my dot indicator method for redering dot
                          // Also I wrote a ternary condition for changing dots color and its size
                          child: _indicatorDotsWidget(
                            color: pageIndex == i
                                ? FlutterFlowTheme.primaryColor
                                : FlutterFlowTheme.secondaryColor,
                            width: pageIndex == i ? 24 : 24,
                          ),
                        ),
                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  //This is our get started button
                  if (pageIndex == 2)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 0, bottom: 10),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: FlutterFlowTheme.primaryColor,
                        height: 48,
                        minWidth: MediaQuery.of(context).size.width,
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 1,
                              fontSize: 18),
                        ),
                        onPressed: () => {Get.offAll(PermissionPage())},
                      ),
                    ),
                ],
              ),
              Positioned(
                top: 8,
                right: 10,
                child: TextButton(
                    onPressed: () {
                      if (pageIndex != 2) {
                        setState(() {
                          pageIndex = 2;
                        });
                      } else {
                        Get.offAll(PermissionPage());
                      }
                    },
                    child: Text(
                      pageIndex != 2 ? "Skip" : "Continue",
                      style: TextStyle(color: Colors.black),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Method for showing image and it's description

  Column _centerImageWithText(
      {required String text, required String text1, required String image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: Image.asset(image)),
        Expanded(
          flex: 0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 24),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: pageIndex == 2 ? 1 : 2,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(
              text1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  // Method for dots
  Container _indicatorDotsWidget(
      {required Color color, required double width}) {
    return Container(
      height: 4,
      width: width,
      decoration: new BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10)),
    );
  }
}
