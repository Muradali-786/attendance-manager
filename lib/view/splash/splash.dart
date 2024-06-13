import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/image_constant/image_constant.dart';
import 'package:attendance_manager/view_model/services/splash_services.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kWhite,
      body: SafeArea(
        child: Center(
          child: Image(
            image: AssetImage(ImageConstant.kLogo),
          ),
        ),
      ),
    );
  }
}
