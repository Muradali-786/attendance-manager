import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/time_picker.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view/home/home_page.dart';
import 'package:attendance_manager/view_model/std_attendance/student_attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentAttendancePage extends StatefulWidget {
  dynamic data;
  StudentAttendancePage({super.key, required this.data});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  List<String> statusList = [];
  late final Stream<QuerySnapshot> fireStoreSubCollectRef;
  List<String> studentIdList = [];
  List<String> stdRollNumbersList = [];
  List<dynamic> studentNamesList = [];


  @override
  void initState() {
    super.initState();
    fireStoreSubCollectRef = FirebaseFirestore.instance
        .collection('Class')
        .doc(widget.data['classId'])
        .collection(widget.data['subject'])
        .snapshots();
    // Initialize statusList with 'P' (Present) for each student
    fireStoreSubCollectRef.listen((QuerySnapshot querySnapshot) {
      if (statusList.isEmpty) {
        // Initialize statusList with 'P' (Present) for each student
        statusList = List.generate(querySnapshot.size, (index) => 'P');
        // this is the list of student id
        studentIdList = querySnapshot.docs.map((doc) => doc.id.toString()).toList();
      }

      if (stdRollNumbersList.isEmpty && studentNamesList.isEmpty) {
        // Populate rollNumbers and studentNames from the query result
        stdRollNumbersList = querySnapshot.docs.map((doc) => doc['rollNumber'].toString()).toList();
        studentNamesList = querySnapshot.docs.map((doc) => doc['studentName']).toList();
      }

      setState(() {
        // Your other setState logic
      });
    }
    );

  }

  TimeOfDay selectedTime = TimeOfDay.now();

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
    double h = MediaQuery.of(context).size.height;
  String currentTime = selectedTime.format(context);


    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.kPrimaryLinearGradient,
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: kPadding24),
            decoration:
                const BoxDecoration(color: AppColors.kAppBackgroundColor),
            child: Column(
              children: [
                TextButton(
                  onPressed: (){
                    _selectTime(context);
                  },
                  child: Center(
                    child: Text(
                      currentTime.toString(),
                      style: AppStyles().defaultStyle(
                        h * 0.059,
                        AppColors.kGreenColor,
                        FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: fireStoreSubCollectRef,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Show shimmer loading effect while data is loading
                        return const Expanded(child: ShimmerLoadingEffect());
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 180),
                          child: Center(
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
                                      23,
                                      AppColors.kTextBlackColor,
                                      FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Sorry, Something went wrong',
                                  style: AppStyles().defaultStyle(
                                      16,
                                      AppColors.kTextBlackColor,
                                      FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data!.docs[index];



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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            if (statusList[index] == 'L') {
                                              statusList[index] =
                                                  'P'; // Change Leave to Present
                                            } else if (statusList[index] ==
                                                'P') {
                                              statusList[index] =
                                                  'A'; // Change Present to Absent
                                            } else {
                                              statusList[index] =
                                                  'L'; // Change Absent to Leave
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 53,
                                            width: 65,
                                            decoration: BoxDecoration(
                                              color: getStatusColor(
                                                  statusList[index]),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: Center(
                                              child: Text(
                                                statusList[
                                                    index], // Display the status (P, A, or L)
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
                                    )
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
                    }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
        child: CustomRoundButton(
            title: 'SAVE ATTENDANCE',
            gradient: false,
            width: 155,
            height: 40,
            textStyle: AppStyles()
                .defaultStyle(15, AppColors.kTextWhiteColor, FontWeight.bold),
            borderRaduis: kBorderRadius5,
            color: AppColors.kThemePinkColor,
            onPress: () {
              String selectedDate=widget.data['selectedDate'].substring(0,10).toString();

              StudentAttendanceController().recordAttendance(widget.data['classId'],widget.data['subject'], selectedDate,
                  currentTime,
                  studentIdList,
                  studentNamesList,
                  stdRollNumbersList,
                  statusList,
              ).then((value) {
                Utils.toastMessage('Attendance recorded successfully');
                Navigator.pop(context);
              });

            }),
      ),
    );
  }

  // Helper function to get the appropriate color based on status
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
