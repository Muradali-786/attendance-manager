import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/app_style/app_styles.dart';
import '../../../utils/component/custom_shimmer_effect.dart';
import '../../../view_model/attendance/attendance_controller.dart';
import '../../home/home_page.dart';

class HistoryTab extends StatefulWidget {
  final String subjectId;

  const HistoryTab({super.key, this.subjectId = ''});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final AttendanceController _controller = AttendanceController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: AppColor.kBgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _controller.getAllStudentAttendance(widget.subjectId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: ShimmerLoadingEffect(height: 45),
                );
              } else if (snapshot.hasError) {
                return const ErrorClass();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No attendance has been taken of this class.',
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteName.studentAttendanceHistoryPage,
                              arguments: {'data': snap[index].toMap()});
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                          child: Container(
                            height: 45,
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: AppColor.kWhite,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.kBlack.withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 1.5,
                                    offset: const Offset(
                                      0,
                                      1,
                                    ), // controls the shadow position
                                  )
                                ]),
                            child: Row(
                              children: [
                                Container(
                                  height: 17,
                                  width: 17,
                                  decoration: BoxDecoration(
                                    color:
                                        AppColor.kPrimaryColor.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: SizeConfig.screenWidth! * 0.05),
                                Text(
                                  "${snap[index].selectedDate}\t\t${snap[index].currentTime}",
                                  style: AppStyles().defaultStyle(
                                      getProportionalWidth(24),
                                      AppColor.kTextBlackColor,
                                      FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar:
          Consumer<AttendanceController>(builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(95, 0, 95, 16),
          child: CustomRoundButton(
            height: getProportionalHeight(38),
            title: 'EXPORT ATTENDANCE',
            loading: provider.loading,
            onPress: () async {},
            buttonColor: AppColor.kSecondaryColor,
          ),
        );
      }),
    );
  }
}
