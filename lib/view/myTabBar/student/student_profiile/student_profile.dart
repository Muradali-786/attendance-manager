import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/attendance/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../model/attendance_model.dart';
import '../../../../utils/component/common.dart';
import '../../../../utils/component/custom_attendance_lists.dart';
import '../../../../utils/component/custom_shimmer_effect.dart';
import '../../../../utils/component/dialoge_boxes/update_std_dialog.dart';
import '../../../../utils/component/custom_std_profile.dart';

class StudentProfile extends StatefulWidget {
  Map data;
  StudentProfile({super.key, required this.data});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final StudentController _studentController = StudentController();
  final AttendanceController _controller = AttendanceController();

  String formatDate(DateTime dateTime) {
    final formatter = DateFormat('yMMMMd');
    return formatter.format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                if (snapshot.connectionState==ConnectionState.waiting) {
                  return const StdProfileShimmerEffect();
                } else if (snapshot.hasError) {
                  return const ErrorClass();
                } else {
                  dynamic data = snapshot.data!.data() as Map<String, dynamic>;
                  StudentModel stdInfo = StudentModel.fromMap(data);
                  return SizedBox(
                    height: SizeConfig.screenHeight! * 0.26,
                    child: StdProfile(
                      stdInfo: stdInfo,
                      onPressEdit: () async {
                        await updateStudentDialog(
                          context,
                          subjectId,
                            stdInfo,
                        );
                      },
                    ),
                  );
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _controller.getAllStudentAttendance(subjectId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child:
                        ShimmerLoadingEffect(height: getProportionalHeight(46)),
                  );
                } else if (snapshot.hasError) {
                  return const ErrorClass();
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.screenHeight!*0.2),
                    child: const  Text(
                      'No attendance has been taken.',
                      style: TextStyle(color: AppColor.kTextGreyColor),
                    ),
                  );
                } else {
                  List<AttendanceModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return AttendanceModel.fromMap(data);
                  }).toList();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        if (snap[index].attendanceList.containsKey(studentId)) {
                          return CustomAttendanceList3(
                            dateTime:
                                "${formatDate(snap[index].selectedDate)}\t\t${snap[index].currentTime}",
                            attendanceStatus:
                                snap[index].attendanceList[studentId],
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
}
