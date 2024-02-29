
import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/component/custom_shimmer_effect.dart';
import '../../home/home_page.dart';

class HistoryTab extends StatefulWidget {
  String classId, subject;

  HistoryTab({super.key, this.classId = '', this.subject = ''});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  late final Stream<QuerySnapshot> fireStoreSubCollectRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fireStoreSubCollectRef = FirebaseFirestore.instance
        .collection('Class')
        .doc(widget.classId)
        .collection('AttendanceRecords').orderBy('Date')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: fireStoreSubCollectRef,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show shimmer loading effect while data is loading
                  return const Expanded(child: ShimmerLoadingEffect(height: 45,));
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
                  return Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          final recordsId = snapshot.data!.docs[index].id;
                          return GestureDetector(
                            onTap: (){
                             Navigator.pushNamed(context, RouteName.studentAttendanceHistoryPage,
                             arguments: {
                               'classId':widget.classId,
                               'attendanceRecordId':recordsId.toString(),
                               'date':data['Date'],
                               'time':data['Time'],
                             }

                             );
                            },
                            child: Container(
                              height: 45,
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 10),
                              margin: const EdgeInsets.only(left: 10,right: 10,top: 14),
                              decoration: BoxDecoration(
                                  color: AppColors.kWhite,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.kBlack.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 1.5,
                                      offset: const Offset(
                                          0, 1), // controls the shadow position
                                    )
                                  ]),
                              child: Row(
                                children: [
                                  Container(
                                    height: 17,
                                    width: 17,
                                    decoration: BoxDecoration(
                                        color: AppColors.kGreenColor
                                            .withOpacity(0.5),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    data['Date'] + '  ' + data['Time'],
                                    style: AppStyles().defaultStyle(
                                        24,
                                        AppColors.kTextBlackColor,
                                        FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return const Center(
                      child: Text('Nothing to show '));
                }
              }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
        child: CustomRoundButton(
            title: 'EXPORT HISTORY',
            gradient: false,
            width: 155,
            height: 40,
            textStyle: AppStyles()
                .defaultStyle(15, AppColors.kTextWhiteColor, FontWeight.bold),
            borderRaduis: kBorderRadius5,
            color: AppColors.kThemePinkColor,
            onPress: () {}),
      ),
    );
  }
}
