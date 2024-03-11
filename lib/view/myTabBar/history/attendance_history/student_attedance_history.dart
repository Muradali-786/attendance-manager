import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';

import 'package:attendance_manager/size_config.dart';

import 'package:flutter/material.dart';

class StudentAttendanceHistory extends StatefulWidget {
  dynamic data;
  StudentAttendanceHistory({super.key, required this.data});

  @override
  State<StudentAttendanceHistory> createState() =>
      _StudentAttendanceHistoryState();
}

class _StudentAttendanceHistoryState extends State<StudentAttendanceHistory> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            Center(
              child: Text(
                '2024-08-08',
                style: AppStyles().defaultStyle(getProportionalHeight(45),
                    AppColor.kPrimaryTextColor, FontWeight.w400),
              ),
            ),
            Center(
              child: Text(
                "12:06 PM",
                style: AppStyles().defaultStyleWithHt(getProportionalHeight(42),
                    AppColor.kPrimaryTextColor, FontWeight.w400, 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
