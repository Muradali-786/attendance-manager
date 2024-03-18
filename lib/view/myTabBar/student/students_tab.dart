import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_list_tile.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/add_student_dialog.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/delete_confirmations.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/update_std_dialog.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/component/common.dart';
import '../../../utils/component/custom_shimmer_effect.dart';

class StudentTab extends StatefulWidget {
  final String subjectId;
  const StudentTab({super.key, this.subjectId = ''});

  @override
  State<StudentTab> createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  final StudentController _studentController = StudentController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _studentController.getAllStudentData(widget.subjectId),
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
                    'No student has been added in the class.',
                    style: TextStyle(
                      color: AppColor.kTextGreyColor,
                    ),
                  ),
                );
              } else {
                List<StudentModel> snap = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return StudentModel.fromMap(data);
                }).toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: snap.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        title: snap[index].studentName.toString(),
                        keyValue: snap[index].studentId.toString(),
                        subtitle: snap[index].studentRollNo.toString(),
                        trailingFirstText:
                            "${snap[index].attendancePercentage.toString()}%",
                        trailingSecondText: 'Attendance',
                        onPress: () {
                          Navigator.pushNamed(context, RouteName.studentProfile,
                              arguments: {
                                'data': snap[index].toMap(),
                                'subjectId': widget.subjectId,
                              });
                        },
                        onLongPress: () async {
                          await updateStudentDialog(
                            context,
                            widget.subjectId,
                            snap[index],
                          );
                        },
                        onDismiss: () async {
                          showDeleteStudentConfirmationDialog(
                              context, snap[index], widget.subjectId);

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
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 120, right: 120, bottom: kPadding16),
        child: CustomRoundButton(
          height: getProportionalHeight(38),
          title: 'ADD STUDENT',
          onPress: () {
            addStudentDialog(context, widget.subjectId);
          },
          buttonColor: AppColor.kSecondaryColor,
        ),
      ),
    );
  }
}
