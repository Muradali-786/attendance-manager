import 'dart:async';

import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void isLogin(BuildContext context) {
    if (_auth.currentUser != null) {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, RouteName.homePage));
    } else {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, RouteName.login));
    }
  }
}
