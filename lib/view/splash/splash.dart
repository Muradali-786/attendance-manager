import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.120),
            Image(
                height: h * 0.290,
                width: w * 0.55,
                image: AssetImage(
                  ImageConstant.kAttendityLogo,
                )),
            SizedBox(
              height: h * 0.015,
            ),
            Text(
              'Loading...',
              textAlign: TextAlign.center,
              style: AppStyles().safeGoogleFont(
                'Ropa Sans',
                fontSize: h * 0.065,
                fontWeight: FontWeight.w400,
                height: 1.07,
                color: AppColors.kTextDarkColor,
              ),
            ),
            SizedBox(
              height: h * 0.070,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kPadding16),
              child: Text(
                'Mark your attendance at',
                textAlign: TextAlign.center,
                style: AppStyles().safeGoogleFont(
                  'Ropa Sans',
                  fontSize: h * 0.045,
                  fontWeight: FontWeight.w400,
                  height: 1.06,
                  color: AppColors.kTextDarkColor,
                ),
              ),
            ),
            Image(
                height: h * 0.075,
                width: w * 0.47,
                image: AssetImage(ImageConstant.kAttendityText)),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: h * 0.110),
              child: Column(
                children: [
                  Text(
                    'There is no time like the',
                    style: AppStyles().safeGoogleFont(
                      'Rubik',
                      fontSize: h * 0.028,
                      fontWeight: FontWeight.w400,
                      height: 1.185,
                      color: AppColors.kTextWhiteColor,
                    ),
                  ),
                  Text(
                    'PRESENT',
                    style: AppStyles().safeGoogleFont(
                      'Rubik',
                      fontSize: h * 0.028,
                      fontWeight: FontWeight.w400,
                      height: 1.180,
                      color: AppColors.kTextWhiteColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
