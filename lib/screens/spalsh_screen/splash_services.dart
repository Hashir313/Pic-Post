import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pic_post/screens/get_started.dart';
import 'package:pic_post/screens/bottom_bar/bottom_bar.dart';

class SplashServices {
  User? user = FirebaseAuth.instance.currentUser;
  void isUserLoggedIn(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              user != null ? const BottomNavBar() : const GetStarted(),
        ),
      );
    });
  }
}
