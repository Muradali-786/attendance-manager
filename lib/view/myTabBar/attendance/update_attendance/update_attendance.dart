import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/time_picker.dart';
import 'package:attendance_manager/view_model/attendance/attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/component/custom_shimmer_effect.dart';

class UpdateAttendance extends StatefulWidget {
  dynamic data;
  UpdateAttendance({super.key, required this.data});

  @override
  State<UpdateAttendance> createState() => _UpdateAttendanceState();
}

class _UpdateAttendanceState extends State<UpdateAttendance> {
  late Stream<QuerySnapshot> fireStoreSubCollectRef;
  List<String> studentStatusList = [];
  List<String> studentIdList = [];

  @override
  void initState() {
    super.initState();
    // Create a reference to the specific attendance record document
    final attendanceRecordRef = FirebaseFirestore.instance
        .collection('Class')
        .doc(widget.data['classId'])
        .collection('AttendanceRecords')
        .doc(widget.data['attendanceRecordId']);

    // Listen to changes in the "Attendance" subCollection of the attendance record
    fireStoreSubCollectRef =
        attendanceRecordRef.collection('Attendance').snapshots();

    fireStoreSubCollectRef.listen((QuerySnapshot querySnapshot) {
      if (studentIdList.isEmpty) {
        // Populate rollNumbers and studentNames from the query result
        studentIdList =
            querySnapshot.docs.map((doc) => doc.id.toString()).toList();
      }

      setState(() {
        // Your other setState logic
      });
    });
  }

  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePickerDialog(context);

    if (pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentTime = selectedTime != null
        ? selectedTime!.format(context)
        : '${widget.data['time']}';

    return Scaffold(
      backgroundColor: AppColors.kAppBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 15),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    _selectTime(context);
                  },
                  child: Text(
                    currentTime,
                    style: AppStyles().defaultStyle(
                        43,
                        AppColors.kTextGreenColor.withOpacity(0.8),
                        FontWeight.w500),
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: fireStoreSubCollectRef,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                      child: ShimmerLoadingEffect(height: 45));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.kAlertColor,
                          size: 45,
                        ),
                        Text(
                          'Oops..!',
                          style: AppStyles().defaultStyle(
                              23, AppColors.kTextBlackColor, FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Sorry, Something went wrong',
                          style: AppStyles().defaultStyle(
                              16, AppColors.kTextBlackColor, FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];

                        if (studentStatusList.length <= index) {
                          studentStatusList.add(data['Status']);
                        }

                        return Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: kPadding20,
                            top: kPadding15,
                            bottom: 12,
                          ),
                          margin: const EdgeInsets.only(
                            left: 11,
                            right: 11,
                            top: 14,
                          ),
                          width: double.infinity,
                          height: 84,
                          decoration: BoxDecoration(
                            color: AppColors.kWhite,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kBlack.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 1.5,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['studentName'],
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: AppColors.kTextBlackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    data['rollNumber'].toString(),
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: AppColors.kTextBlackColor
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 1),
                                  GestureDetector(
                                    onTap: () {
                                      if (studentStatusList[index] == 'L') {
                                        studentStatusList[index] = 'P';
                                      } else if (studentStatusList[index] ==
                                          'P') {
                                        studentStatusList[index] = 'A';
                                      } else {
                                        studentStatusList[index] = 'L';
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 53,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                            studentStatusList[index]),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Center(
                                        child: Text(
                                          studentStatusList[index],
                                          style: const TextStyle(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                      child: Text('Click on the button to add student '));
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
        child: CustomRoundButton(
          title: 'UPDATE ATTENDANCE',
          gradient: false,
          width: 155,
          height: 40,
          textStyle: AppStyles()
              .defaultStyle(15, AppColors.kTextWhiteColor, FontWeight.bold),
          borderRaduis: kBorderRadius5,
          color: AppColors.kThemePinkColor,
          onPress: () {
            StdAttendanceController()
                .updateAttendanceRecord(
                    widget.data['classId'],
                    widget.data['attendanceRecordId'],
                    currentTime,
                    studentIdList,
                    studentStatusList)
                .then((value) {
              Navigator.pop(context);
            });
          },
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'P':
        return AppColors.kGreenColor;
      case 'A':
        return AppColors.kThemePinkColor;
      case 'L':
        return AppColors.kThemePinkColor
            .withOpacity(0.8); // Use your preferred color for Leave
      default:
        return Colors.grey; // Fallback color
    }
  }
}
