import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/view/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../utils/component/custom_shimmer_effect.dart';


class StudentAttendanceHistory extends StatefulWidget {

dynamic data;
StudentAttendanceHistory({super.key,required this.data});

  @override
  State<StudentAttendanceHistory> createState() => _StudentAttendanceHistoryState();
}

class _StudentAttendanceHistoryState extends State<StudentAttendanceHistory> {
  late Stream<QuerySnapshot> fireStoreSubCollectRef;

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
    fireStoreSubCollectRef = attendanceRecordRef.collection('Attendance').snapshots();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.kAppBackgroundColor,

      body: SafeArea(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const SizedBox(height: 20),
            Center(child: Text(widget.data['date'],style: AppStyles().defaultStyle(47, AppColors.kTextGreenColor.withOpacity(0.8), FontWeight.w500),)),
            Center(child: Text(widget.data['time'],style: AppStyles().defaultStyle(43, AppColors.kTextGreenColor.withOpacity(0.8), FontWeight.w500))),

            StreamBuilder<QuerySnapshot>(
                stream: fireStoreSubCollectRef,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show shimmer loading effect while data is loading
                    return const Expanded(child: ShimmerLoadingEffect( height: 45,));
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
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return  Expanded(
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
                                    Container(
                                      height: 53,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        color: getStatusColor(data['Status']),
                                        borderRadius:
                                        BorderRadius.circular(3),
                                      ),
                                      child: Center(
                                        child: Text(
                                          data['Status']
                                        , // Display the status (P, A, or L)
                                          style: const TextStyle(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
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
