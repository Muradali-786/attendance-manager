import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/update_std_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentProfile extends StatefulWidget {
  dynamic data;

 StudentProfile({super.key,required this.data});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {


  @override
  Widget build(BuildContext context) {


    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.kAppBackgroundColor,
      body: Container(
        height: h,
        width: w,
        decoration:
        const BoxDecoration(gradient: AppColors.kPrimaryLinearGradient),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(color: AppColors.kWhite),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: kPadding16),
                  height: h * 0.22,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: AppColors.kPrimaryLinearGradient),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.data['studentName'].toUpperCase(),
                        style: AppStyles().defaultStyle(32,
                            AppColors.kTextWhiteColor, FontWeight.bold),
                      ),
                      Text(
                        widget.data['studentRollNumber'],
                        style: AppStyles().defaultStyleWithHt(
                            32,
                            AppColors.kTextWhiteColor,
                            FontWeight.bold,
                            1.5),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 120, left: kPadding16, right: kPadding16),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: kPadding16),
                      height: h * 0.120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kBlack.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 1.5,
                            offset: const Offset(
                                0, 1), // controls the shadow position
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '0',
                                style: AppStyles().defaultStyle(
                                    32,
                                    AppColors.kTextSkyColor,
                                    FontWeight.bold),
                              ),
                              Text(
                                'Present',
                                style: AppStyles().defaultStyle(
                                    18,
                                    AppColors.kTextBlackColor
                                        .withOpacity(0.6),
                                    FontWeight.normal),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '0',
                                style: AppStyles().defaultStyle(
                                    32,
                                    AppColors.kTextSkyColor,
                                    FontWeight.bold),
                              ),
                              Text(
                                'Absent',
                                style: AppStyles().defaultStyle(
                                    18,
                                    AppColors.kTextBlackColor
                                        .withOpacity(0.6),
                                    FontWeight.normal),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '0',
                                style: AppStyles().defaultStyle(
                                    32,
                                    AppColors.kTextSkyColor,
                                    FontWeight.bold),
                              ),
                              Text(
                                'Leaves',
                                style: AppStyles().defaultStyle(
                                    18,
                                    AppColors.kTextBlackColor
                                        .withOpacity(0.6),
                                    FontWeight.normal),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        String titleVal = 'Edit Student';
                        String firstButton = 'SAVE';
                        String secondButton = 'CLOSE';
                        updateStudentDialog(
                            context,
                            widget.data['studentId'].toString(),
                            widget.data['studentName'],
                            widget.data['studentRollNumber'].toString(),
                            widget.data['classId'],
                            widget.data['subject'],
                            titleVal,
                            firstButton,
                            secondButton

                        );
                      },
                      child: const Padding(
                        padding:
                        EdgeInsets.only(top: kPadding20, right: kPadding20),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.kWhite,
                          size: 32,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
