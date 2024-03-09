import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/custom_stepper.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/add_student_dialog.dart';

import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view_model/add_students/add_students_controller.dart';
import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  dynamic data;
  AddStudentPage({super.key, required this.data});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
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
            Positioned(
              top: SizeConfig.screenHeight! * 0.5,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: CustomRoundButton2(
                    title: 'IMPORT STUDENTS',
                    height: getProportionalHeight(40),
                    onPress: () {},
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
                          Navigator.pushNamed(context, RouteName.homePage);
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
                child: AddStudentButton(onPress: () {
                  addStudentDialog100(context, classId);
                }))
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

class AddStudentButton extends StatelessWidget {
  final VoidCallback onPress;

  const AddStudentButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: getProportionalHeight(60),
        width: getProportionalHeight(60),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.kSecondaryColor,
        ),
        child: const Icon(
          Icons.add,
          size: 30,
          color: AppColor.kWhite,
        ),
      ),
    );
  }
}
