import 'package:attendance_manager/constant/app_colors.dart';
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
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Container(
        width: w,
        height: h,
        decoration:  BoxDecoration(
          // gradient: AppColors.kPrimaryLinearGradient,
          color: AppColors.kWhite.withOpacity(0.5)
        ),
        child: Center(
          child: Text('Splash Screen',style: TextStyle(color: AppColor.kBlack,fontSize: 24),),
        ),
      ),
    );
  }
}
