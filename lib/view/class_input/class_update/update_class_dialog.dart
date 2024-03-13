import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/input_text_filed/dialog_text_field.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/class_input/class_input_controller.dart';
import 'package:flutter/material.dart';

Future<void> updateClassValueDialog(BuildContext context, Map data) async {
  final formKey = GlobalKey<FormState>();
  TextEditingController subjectController =
      TextEditingController(text: data['subjectName']);
  FocusNode subjectFocus = FocusNode();
  TextEditingController departmentController =
      TextEditingController(text: data['departmentName']);
  FocusNode departmentFocus = FocusNode();
  TextEditingController batchController =
      TextEditingController(text: data['batchName']);
  FocusNode batchFocus = FocusNode();
  TextEditingController attendancePercentageController =
      TextEditingController(text: data['percentage'].toString());
  FocusNode attendanceFocus = FocusNode();
  String teacherId = data['teacherId'];
  String subjectId = data['subjectId'];
  SizeConfig().init(context);
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
              height: getProportionalHeight(50),
              decoration: const BoxDecoration(
                  color: AppColor.kSecondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(kBorderRadius15),
                    topRight: Radius.circular(kBorderRadius15),
                  )),
              child: Row(
                children: [
                  const Spacer(
                    flex: 2,
                  ),
                  Text(
                    'Edit Class',
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
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Form(
                     key: formKey,
                     child: Column(children: [
                   DialogInputTextField(
                       labelText: 'Subject',
                       myController: subjectController,
                       focusNode: subjectFocus,
                       onFieldSubmittedValue: (val) {
                         Utils.onFocusChange(
                             context, subjectFocus, departmentFocus);
                       },
                       hint: 'Subject',
                       onValidator: (val) {
                         if (val.isEmpty) {
                           return 'Please enter a subject';
                         } else if (val.length < 3) {
                           return 'Subject cannot contain special characters';
                         } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                           return 'Subject cannot contain special characters';
                         }
                         return null;
                       },
                       keyBoardType: TextInputType.text),
                   DialogInputTextField(
                       labelText: 'Department',
                       myController: departmentController,
                       focusNode: departmentFocus,
                       onFieldSubmittedValue: (val) {
                         Utils.onFocusChange(
                             context, departmentFocus, batchFocus);
                       },
                       hint: 'Department',
                       onValidator: (val) {
                         if (val.isEmpty) {
                           return 'Please enter a department';
                         } else if (val.length < 2) {
                           return 'Subject must be at least 2 characters long';
                         } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                           return 'Department cannot contain special characters';
                         }
                         return null;
                       },
                       keyBoardType: TextInputType.text),
                   DialogInputTextField(
                       labelText: 'Standard/Batch',
                       myController: batchController,
                       focusNode: batchFocus,
                       onFieldSubmittedValue: (val) {
                         Utils.onFocusChange(
                             context, batchFocus, attendanceFocus);
                       },
                       hint: 'Standard/Batch',
                       onValidator: (val) {
                         if (val.isEmpty) {
                           return 'Please enter a Semester/Batch';
                         } else if (val.length < 4) {
                           return 'Semester/Batch must be at least 4 characters long';
                         } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                           return 'Semester/Batch cannot contain special characters';
                         }

                         return null;
                       },
                       keyBoardType: TextInputType.text),
                   DialogInputTextField(
                       labelText: 'Attendance Requirement(%)',
                       myController: attendancePercentageController,
                       focusNode: attendanceFocus,
                       onFieldSubmittedValue: (val) {},
                       hint: 'Attendance Requirement(%)',
                       onValidator: (val) {
                         if (val == null || val.isEmpty) {
                           return 'Please enter attendance percentage.';
                         } else if (double.tryParse(val) == null) {
                           return 'Please enter a valid number.';
                         } else if (double.parse(val) >= 100 ||
                             double.parse(val) < 10) {
                           return 'Enter attendance (10% - 100%)';
                         }
                         return null;
                       },
                       keyBoardType: TextInputType.number),
                 ],))
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
                        height: 38,
                        title: 'CLOSE',
                        onPress: () {
                          Navigator.pop(context);
                        },
                        buttonColor: AppColor.kSecondaryColor),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: CustomRoundButton(
                      height: 38,
                      title: 'UPDATE',
                      onPress: () async {

                        if (formKey.currentState!.validate()){
                          Navigator.pop(context);
                          ClassInputModel classInputModel = ClassInputModel(
                            subjectName: subjectController.text,
                            teacherId: teacherId,
                            subjectId: subjectId,
                            departmentName: departmentController.text,
                            batchName: batchController.text,
                            percentage:
                            int.tryParse(attendancePercentageController.text),
                          );

                          await ClassController()
                              .updateClassData(classInputModel);
                        }

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
