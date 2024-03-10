import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/size_config.dart';

import 'package:attendance_manager/view/home/home_page.dart';
import 'package:attendance_manager/view_model/add_students/add_students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/component/dialoge_boxes/update_std_dialog.dart';

class StudentProfile extends StatefulWidget {
  Map data;
  StudentProfile({super.key, required this.data});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final StudentController _studentController = StudentController();
  @override
  Widget build(BuildContext context) {
    String studentId = widget.data['data']['studentId'];
    String subjectId = widget.data['subjectId'];

    return Scaffold(
      backgroundColor: AppColor.kBgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: _studentController.getSingleStudentData(
                subjectId,
                studentId,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColor.kPrimaryColor,
                  ));
                } else if (snapshot.hasError) {
                  return const ErrorClass();
                } else {
                  dynamic data = snapshot.data!.data() as Map<String, dynamic>;

                  StudentModel stdInfo = StudentModel.fromMap(data);
                  return SizedBox(
                    height: SizeConfig.screenHeight! * 0.26,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: SizeConfig.screenHeight! * 0.26 -
                              SizeConfig.screenHeight! * 0.06,
                          decoration: const BoxDecoration(
                            color: AppColor.kPrimaryColor,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: SizeConfig.screenHeight! * 0.013),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ReUsableText(
                                      title: 'Present',
                                      value:
                                          stdInfo.totalPresent.toString()),
                                  ReUsableText(
                                      title: 'Absent',
                                      value:
                                          stdInfo.totalAbsent.toString()),
                                  ReUsableText(
                                      title: 'Leaves',
                                      value:
                                          stdInfo.totalLeaves.toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: SizeConfig.screenHeight! * 0.01,
                          right: SizeConfig.screenWidth! * 0.025,
                          child: IconButton(
                            onPressed: () async {
                              await updateStudentDialog(
                                context,
                                subjectId,
                                stdInfo.toMap(),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: AppColor.kWhite,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String title, double size) {
    return Text(title,
        style: AppStyles().defaultStyleWithHt(
          getProportionalHeight(size),
          AppColor.kTextWhiteColor,
          FontWeight.bold,
          1.5,
        ));
  }
}

class ReUsableText extends StatelessWidget {
  final String title, value;
  const ReUsableText({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppStyles().defaultStyle(
            32,
            AppColor.kPrimaryTextColor,
            FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: AppStyles().defaultStyleWithHt(
              18, AppColor.kTextGreyColor, FontWeight.w400, 1.5),
        ),
      ],
    );
  }
}
