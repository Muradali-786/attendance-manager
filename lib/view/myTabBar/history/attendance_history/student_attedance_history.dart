import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_list_tile.dart';
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
                          return CustomAttendanceList(
                            stdName: snap[index].studentName,
                            stdRollNo: snap[index].studentRollNo,
                            attendanceStatus:
                                attendanceStatus[snap[index].studentId],
                            onTap: () {},
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
