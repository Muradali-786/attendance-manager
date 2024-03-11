import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/view_model/add_students/add_students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../model/student_model.dart';
import '../../../../utils/component/custom_shimmer_effect.dart';
import '../../../home/home_page.dart';

class StudentAttendanceHistory extends StatefulWidget {
  dynamic data;
  StudentAttendanceHistory({super.key, required this.data});

  @override
  State<StudentAttendanceHistory> createState() =>
      _StudentAttendanceHistoryState();
}

class _StudentAttendanceHistoryState extends State<StudentAttendanceHistory> {
  final StudentController _studentController = StudentController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String date = widget.data['data']['selectedDate'];
    String time = widget.data['data']['currentTime'];
    String classId = widget.data['data']['classId'];
    Map attendanceStatus = widget.data['data']['attendanceList'];

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                date,
                style: AppStyles().defaultStyleWithHt(getProportionalHeight(45),
                    AppColor.kPrimaryTextColor, FontWeight.w400, 1.6),
              ),
            ),
            Center(
              child: Text(
                time,
                style: AppStyles().defaultStyleWithHt(getProportionalHeight(42),
                    AppColor.kPrimaryTextColor, FontWeight.w400, 1.2),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _studentController.getAllStudentData(classId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: ShimmerLoadingEffect(),
                  );
                } else if (snapshot.hasError) {
                  return const ErrorClass();
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No student has been added in the class.'),
                  );
                } else {
                  List<StudentModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return StudentModel.fromMap(data);
                  }).toList();
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        if (attendanceStatus
                            .containsKey(snap[index].studentId)) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 20),
                              width: double.infinity,
                              height: getProportionalHeight(88),
                              decoration: BoxDecoration(
                                color: AppColor.kWhite,
                                borderRadius: BorderRadius.circular(2),
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
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snap[index].studentName,
                                        style: AppStyles().defaultStyle(
                                          22,
                                          AppColor.kTextBlackColor,
                                          FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        snap[index].studentRollNo,
                                        style: AppStyles().defaultStyleWithHt(
                                          17,
                                          AppColor.kTextGreyColor,
                                          FontWeight.normal,
                                          1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 53,
                                        width: 65,
                                        decoration: BoxDecoration(
                                          color: getStatusColor(
                                              attendanceStatus[
                                                  snap[index].studentId]),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        child: Center(
                                          child: Text(
                                            attendanceStatus[
                                                snap[index].studentId],
                                            style: AppStyles().defaultStyle(
                                              32,
                                              AppColor.kTextWhiteColor,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
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

  Color getStatusColor(String status) {
    switch (status) {
      case 'A':
        return AppColor.kSecondaryColor;
      case 'L':
        return AppColor.kSecondary54Color;
      default:
        return AppColor.kPrimaryTextColor;
    }
  }
}
