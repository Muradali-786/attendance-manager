import 'package:attendance_manager/size_config.dart';
import 'package:flutter/material.dart';

import '../../constant/app_style/app_colors.dart';
import '../../constant/app_style/app_styles.dart';
import '../../model/student_model.dart';
import 'common.dart';

class StdProfile extends StatelessWidget {
  StudentModel stdInfo;

  final VoidCallback onPressEdit;
  StdProfile({super.key, required this.stdInfo, required this.onPressEdit});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height:
          SizeConfig.screenHeight! * 0.26 - SizeConfig.screenHeight! * 0.06,
          decoration: const BoxDecoration(
            color: AppColor.kPrimaryColor,
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight! * 0.013),
              _text(stdInfo.studentName, 32),
              _text(stdInfo.studentRollNo, 28),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! * 0.06),
            child: Container(
              height: SizeConfig.screenHeight! * 0.120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.kBlack.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 1.5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReUsableText(
                      title: 'Present', value: stdInfo.totalPresent.toString()),
                  ReUsableText(
                      title: 'Absent', value: stdInfo.totalAbsent.toString()),
                  ReUsableText(
                      title: 'Leaves', value: stdInfo.totalLeaves.toString()),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.screenHeight! * 0.01,
          right: SizeConfig.screenWidth! * 0.025,
          child: IconButton(
            onPressed: onPressEdit,
            icon: const Icon(
              Icons.edit,
              color: AppColor.kWhite,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _text(String title, double size) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppStyles().defaultStyleWithHt(
        getProportionalHeight(size),
        AppColor.kTextWhiteColor,
        FontWeight.bold,
        1.5,
      ),
    );
  }
}