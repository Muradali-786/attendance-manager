import 'dart:async';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushNamed(context, RouteName.homePage)

    );
  }
}
