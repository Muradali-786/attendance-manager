import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/time_picker.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/student_model.dart';
import '../../../../utils/component/custom_attendance_lists.dart';
import '../../../../utils/component/custom_shimmer_effect.dart';
import '../../../../view_model/attendance/attendance_controller.dart';

class StudentAttendancePage extends StatefulWidget {
  dynamic data;
  StudentAttendancePage({super.key, required this.data});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePickerDialog(context);

    if (pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  final StudentController _studentController = StudentController();
  List<String> stdIdList = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String period = selectedTime.hour < 12 ? 'AM' : 'PM';
    String hour = selectedTime.hourOfPeriod.toString().padLeft(2, '0');
    String minute = selectedTime.minute.toString().padLeft(2, '0');
    String currentTime = '$hour:$minute $period';
    String subjectId = widget.data['classId'].toString();
    DateTime selectedDate = widget.data['selectedDate'];

    return Scaffold(
      backgroundColor: AppColor.kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                _selectTime(context);
              },
              child: Center(
                child: Text(
                  currentTime.toString(),
                  style: AppStyles().defaultStyle(
                    SizeConfig.screenHeight! * 0.057,
                    AppColor.kPrimaryColor,
                    FontWeight.w400,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _studentController.getAllStudentData(subjectId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: ShimmerLoadingEffect(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return  Padding(
                    padding: EdgeInsets.only(top:SizeConfig.screenHeight!*0.35),
                    child: const Text(
                      'No student has been added in the class.',
                      style: TextStyle(color: AppColor.kTextGreyColor),
                    ),
                  );
                } else {
                  List<StudentModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return StudentModel.fromMap(data);
                  }).toList();

                  return Consumer<AttendanceController>(
                      builder: (context, provider, child) {
                    if (provider.attendanceStatus.length != snap.length) {
                      provider.attendanceStatusProvider(snap.length);
                    }
                    if (stdIdList.length != snap.length) {
                      for (var std in snap) {
                        stdIdList.add(std.studentId!);
                      }
                    }

                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
                          if (stdIdList.length != snap.length) {
                            stdIdList.add(snap[index].studentId!);
                          }

                          return CustomAttendanceList(
                              stdName: snap[index].studentName,
                              stdRollNo: snap[index].studentRollNo,
                              attendanceStatus:
                                  provider.attendanceStatus[index],
                              onTap: () {
                                provider.updateStatusList(index);
                              });
                        },
                      ),
                    );
                  });
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Consumer<AttendanceController>(builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(100, 0, 100, 16),
          child: CustomRoundButton(
            height: getProportionalHeight(38),
            title: 'SAVE ATTENDANCE',
            loading: provider.loading,
            onPress: () async {
              if (stdIdList.isNotEmpty) {
                AttendanceModel attendanceModel = AttendanceModel(
                  classId: subjectId,
                  selectedDate: selectedDate,
                  currentTime: currentTime,
                  attendanceList: Map.fromIterables(
                    stdIdList,
                    provider.attendanceStatus,
                  ),
                );

                await provider
                    .saveAllStudentAttendance(attendanceModel)
                    .then((value) {
                  Navigator.pop(context);
                });

                await StudentController().calculateStudentAttendance(
                  subjectId,
                  stdIdList,
                );
              } else {
                Utils.toastMessage('Please add students for attendance.');
              }
            },
            buttonColor: AppColor.kSecondaryColor,
          ),
        );
      }),
    );
  }
}
