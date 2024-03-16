import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/model/attendance_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/component/common.dart';
import '../../../utils/component/custom_attendance_lists.dart';
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
                  child: ShimmerLoadingEffect(),
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
                      return CustomAttendanceList2(
                        title:
                            "${snap[index].selectedDate}\t\t${snap[index].currentTime} ",
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteName.studentAttendanceHistoryPage,
                            arguments: {
                              'data': snap[index].toMap(),
                            },
                          );
                        },
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
