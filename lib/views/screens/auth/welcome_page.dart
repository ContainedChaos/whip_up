import 'package:flutter/material.dart';
import 'package:whip_up/Screens/Login/login_screen.dart';
import 'package:whip_up/Screens/Signup/signup_screen.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/immunity-boosting-food-healthy-lifestyle.jpg'),
                      fit: BoxFit.cover),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.grey.shade900,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 400),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            'WhipUp',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontWeight: FontWeight.w700,
                              fontSize: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text("Cook, Savor, Delight!", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: ElevatedButton(
                            child: Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                isScrollControlled: true,
                                builder: (context) {
                                  return const SignupScreen();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              primary: Colors.black38,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: OutlinedButton(
                            child: Text('Log In', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter')),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                isScrollControlled: true,
                                builder: (context) {
                                  return LoginScreen();
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
                              primary: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.only(top: 32),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'By joining WhipUp, you agree to our ',
                              style: TextStyle(color: Colors.white.withOpacity(0.6), height: 150 / 100),
                              children: [
                                TextSpan(
                                  text: 'Terms of service ',
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w700, height: 150 / 100),
                                ),
                                TextSpan(
                                  text: 'and ',
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), height: 150 / 100),
                                ),
                                TextSpan(
                                  text: 'Privacy policy.',
                                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w700, height: 150 / 100),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
