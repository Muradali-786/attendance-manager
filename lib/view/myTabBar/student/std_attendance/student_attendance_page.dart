import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/time_picker.dart';
import 'package:attendance_manager/view_model/add_students/add_students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/student_model.dart';
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String currentTime = selectedTime.format(context).toString();
    String subjectId = widget.data['data'].toString();

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
                    SizeConfig.screenHeight! * 0.059,
                    AppColors.kGreenColor,
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
                  return const Center(
                    child: Text('No student has been added in the class.'),
                  );
                } else {
                  List<StudentModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return StudentModel.fromMap(data);
                  }).toList();

                  return Consumer<AttendanceProvider>(
                      builder: (context, provider, child) {
                    if (provider.attendanceStatus.isEmpty) {
                      provider.attendanceStatusProvider(snap.length);
                    }

                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snap.length,
                        itemBuilder: (context, index) {
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
                                      GestureDetector(
                                        onTap: () {
                                          provider.updateStatus(index);
                                        },
                                        child: Container(
                                          height: 53,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            color: provider.getStatusColor(
                                                provider
                                                    .attendanceStatus[index]),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Center(
                                            child: Text(
                                              provider.attendanceStatus[index],
                                              style: AppStyles().defaultStyle(
                                                32,
                                                AppColor.kTextWhiteColor,
                                                FontWeight.w500,
                                              ),
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
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
        child: CustomRoundButton2(
          height: getProportionalHeight(38),
          title: 'SAVE ATTENDANCE',
          onPress: () {},
          buttonColor: AppColor.kSecondaryColor,
        ),
      ),
    );
  }
}
