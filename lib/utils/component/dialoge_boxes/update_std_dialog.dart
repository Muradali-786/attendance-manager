import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/model/student_model.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/input_text_filed/dialog_text_field.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/services/media/media_services.dart';
import 'package:flutter/material.dart';

Future<void> updateStudentDialog(
  BuildContext context,
  String classId,
  StudentModel model,
) async {
  TextEditingController stdNameController =
      TextEditingController(text: model.studentName);
  FocusNode stdNameFocus = FocusNode();
  TextEditingController rollNController =
      TextEditingController(text: model.studentRollNo);
  FocusNode rollNoFocus = FocusNode();

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                color: AppColor.kSecondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Text(
                    'Edit Student',
                    style: AppStyles().defaultStyle(
                        24, AppColor.kTextWhiteColor, FontWeight.w400),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: AppColor.kWhite,
                        size: 30,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  DialogInputTextField(
                    labelText: 'Student Name',
                    myController: stdNameController,
                    focusNode: stdNameFocus,
                    onFieldSubmittedValue: (val) {
                      Utils.onFocusChange(context, stdNameFocus, rollNoFocus);
                    },
                    hint: 'Student Name',
                    onValidator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter Student Name';
                      } else if (val.length < 3) {
                        return 'Student Name  at least 3 characters long';
                      } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                        return 'Student Name cannot contain special characters';
                      }
                      return null;
                    },
                    keyBoardType: TextInputType.text,
                  ),
                  DialogInputTextField(
                    labelText: 'Roll Number / Registration#',
                    myController: rollNController,
                    focusNode: rollNoFocus,
                    onFieldSubmittedValue: (val) {},
                    hint: 'Roll Number / Registration#',
                    onValidator: (val) {
                      if (val.isEmpty) {
                        return 'Please enter Roll No';
                      } else if (val.length < 2) {
                        return 'Roll No  at least 2 characters long';
                      } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                        return 'Roll No cannot contain special characters';
                      }
                      return null;
                    },
                    keyBoardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomRoundButton(
                        title: 'CLOSE',
                        height: 35,
                        onPress: () {
                          Navigator.pop(context);
                        },
                        buttonColor: AppColor.kSecondaryColor),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomRoundButton(
                      title: 'SAVE',
                      height: 35,
                      onPress: () async {
                        Navigator.pop(context);
                        StudentModel studentModel = StudentModel(
                          studentId: model.studentId,
                          studentName: stdNameController.text,
                          studentRollNo: rollNController.text,
                        );
                        await StudentController().updateStudentData(
                          studentModel,
                          classId,
                        );
                      },
                      buttonColor: AppColor.kSecondaryColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> importExcelSheetDialog(
  BuildContext context,
) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: const BoxDecoration(
                color: AppColor.kSecondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Text(
                    'Import From Excel',
                    style: AppStyles().defaultStyle(
                        21, AppColor.kTextWhiteColor, FontWeight.w400),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: AppColor.kWhite,
                        size: 30,
                      ))
                ],
              ),
            ),
            const Padding(
              padding:  EdgeInsets.fromLTRB(25, 8, 25, 15),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '-> Expected format of Excel is Roll#, Student Name',
                    style: TextStyle(color: AppColor.kTextGreyColor,height: 1.5),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '-> First row is consider as header',
                    style: TextStyle(color: AppColor.kTextGreyColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomRoundButton(
                        title: 'SELECT FILE',
                        height: 35,
                        onPress: () {
                         MediaServices().getStudentDataFromExcel().then((value) {
                           print('e pehli ha ');
                           print(value[0]);
                           print(' enter e dowe ha');
                           print(value[1]);
                         });

                        },
                        buttonColor: AppColor.kSecondaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
