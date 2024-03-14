import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/custom_stepper.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/add_student_dialog.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/import_dialog_box.dart';

import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/student_model.dart';
import '../../utils/component/common.dart';
import '../../utils/component/custom_list_tile.dart';
import '../../utils/component/custom_shimmer_effect.dart';

class AddStudentPage extends StatefulWidget {
  dynamic data;
  AddStudentPage({super.key, required this.data});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final StudentController _controller = StudentController();
  @override
  Widget build(BuildContext context) {
    final String classId = widget.data['classId'].toString();

    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: SizeConfig.screenHeight! * 0.03,
              right: 0,
              left: 0,
              child: const CustomStepper(),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _controller.getAllStudentData(classId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Positioned(
                    top: SizeConfig.screenHeight! * 0.1,
                    right: 0,
                    left: 0,
                    child: SizedBox(
                      height: SizeConfig.screenHeight! * 0.6,
                      child: const ShimmerLoadingEffect(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const ErrorClass();
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Stack(
                    children: [
                      Positioned(
                        top: SizeConfig.screenHeight! * 0.5,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: CustomRoundButton(
                              title: 'IMPORT STUDENTS',
                              height: getProportionalHeight(40),
                              onPress: () {
                                showImportDialog(context);
                              },
                              buttonColor: AppColor.kSecondaryColor),
                        ),
                      ),
                      Positioned(
                        top: SizeConfig.screenHeight! * 0.56,
                        left: 0,
                        right: 0,
                        child: Text(
                          'Click on the + button to add students in this class',
                          style: AppStyles().defaultStyleWithHt(
                            16,
                            AppColor.kTextGreyColor,
                            FontWeight.normal,
                            3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                } else {
                  List<StudentModel> snap = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    return StudentModel.fromMap(data);
                  }).toList();

                  return Positioned(
                    top: SizeConfig.screenHeight! * 0.1,
                    right: 0,
                    left: 0,
                    child: SizedBox(
                      height: SizeConfig.screenHeight! * 0.83,
                      child: ListView.builder(
                        itemCount: snap.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CustomListTile(
                            title: snap[index].studentName.toString(),
                            subtitle: snap[index].studentRollNo.toString(),
                            trailingFirstText:
                                "${snap[index].attendancePercentage.toString()}%",
                            trailingSecondText: 'Attendance',
                            onPress: () {},
                            onLongPress: () async {},
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                width: double.infinity,
                height: getProportionalHeight(50),
                decoration: const BoxDecoration(color: AppColor.kPrimaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: _text('PREVIOUS')),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RouteName.homePage);
                        },
                        child: _text('FINISH')),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: SizeConfig.screenHeight! * 0.03,
              right: 0,
              left: 0,
              child: AddStudentButton(
                onTap: () async {
                  await addStudentDialog(context, classId);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _text(String title) {
    return Text(
      title,
      style: AppStyles().defaultStyle(18, Colors.white, FontWeight.normal),
    );
  }
}
