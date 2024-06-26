import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/time_picker.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/attendance/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../../../../model/student_model.dart';
import '../../../../utils/component/common.dart';
import '../../../../utils/component/custom_attendance_lists.dart';
import '../../../../utils/component/custom_shimmer_effect.dart';

class UpdateAttendance extends StatefulWidget {
  dynamic data;
  UpdateAttendance({super.key, required this.data});

  @override
  State<UpdateAttendance> createState() => _UpdateAttendanceState();
}

class _UpdateAttendanceState extends State<UpdateAttendance> {
  List<dynamic> studentIdList = [];
  bool isChange = false;
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePickerDialog(context);

    if (pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  List<dynamic> stdIdsList = [];
  final StudentController _studentController = StudentController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    DateTime date = widget.data['data']['selectedDate'];
    DateTime attendanceDate = widget.data['data']['createdAtDate'];
    String time = widget.data['data']['currentTime'];
    String classId = widget.data['data']['classId'];
    String attendanceId = widget.data['data']['attendanceId'];
    Map attendanceStatus = widget.data['data']['attendanceList'];
    stdIdsList = attendanceStatus.keys.toList();

    String period =
        selectedTime != null && selectedTime!.hour < 12 ? 'AM' : 'PM';
    String hour = selectedTime?.hourOfPeriod.toString().padLeft(2, '0') ?? '00';
    String minute = selectedTime?.minute.toString().padLeft(2, '0') ?? '00';
    String formattedTime = '$hour:$minute $period';
    String currentTime = selectedTime != null ? formattedTime : time;

    return Scaffold(
      backgroundColor: AppColor.kBgColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text(
                  currentTime,
                  style: AppStyles().defaultStyleWithHt(
                      getProportionalHeight(42),
                      AppColor.kPrimaryTextColor.withOpacity(0.8),
                      FontWeight.w500,
                      1.5),
                ),
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
                    child: Text(
                      'Nothing to update.',
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
                      builder: (context, value, child) {
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
                              onTap: () {
                                if (!isChange) {
                                  value.setStatusMap(attendanceStatus);
                                  isChange = true;
                                }

                                value.updateStatusListBasedOnKey(
                                  snap[index].studentId!,
                                );
                              },
                            );
                          } else {
                            return Container();
                          }
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
      bottomNavigationBar: Consumer<AttendanceController>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(90, 0, 90, 16),
            child: CustomRoundButton(
              height: getProportionalHeight(38),
              loading: provider.loading,
              title: 'UPDATE ATTENDANCE',
              onPress: () async {
                DateTime currentDate = DateTime.now();

                int differenceInDays =
                    currentDate.difference(attendanceDate).inDays;

                if (isChange) {
                  if (differenceInDays <= 29) {
                    AttendanceModel model = AttendanceModel(
                      classId: classId,
                      attendanceId: attendanceId,
                      selectedDate: date,
                      createdAtDate: attendanceDate,
                      currentTime: currentTime,
                      attendanceList: provider.updatedStatusMap!,
                    );

                    await provider.updateStudentAttendance(model).then((value) {
                      Navigator.pop(context);
                    });

                    await _studentController.calculateStudentAttendance(
                        classId, stdIdsList);
                  } else {
                    EasyLoading.showInfo(
                      'Attendance records can only be updated within 30 days of creation. This record can no longer be modified',
                      duration: const Duration(seconds: 2),
                    );
                  }
                } else {
                  Utils.toastMessage('you did not Update any thing');
                }
              },
              buttonColor: AppColor.kSecondaryColor,
            ),
          );
        },
      ),
    );
  }
}
