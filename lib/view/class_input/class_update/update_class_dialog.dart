import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/input_text_filed/dialog_text_field.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/class_input/class_input_controller.dart';
import 'package:flutter/material.dart';

Future<void> updateClassValueDialog(BuildContext context, String classId,String subject, String department,String batch, int percentage) async {

  TextEditingController subjectController = TextEditingController(text: subject);
  FocusNode subjectFocus = FocusNode();
  TextEditingController departmentController = TextEditingController(text: department);
  FocusNode departmentFocus = FocusNode();
  TextEditingController batchController = TextEditingController(text: batch);
  FocusNode batchFocus = FocusNode();
  TextEditingController attendanceController = TextEditingController(text: percentage.toString());
  FocusNode attendanceFocus = FocusNode();





  await showDialog(
    context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
    return OrientationBuilder(builder: (BuildContext context,Orientation orientation){
      if (orientation == Orientation.landscape) {
        Navigator.pop(context); // Close the dialog on landscape orientation
        return const SizedBox.shrink(); // Return an empty widget
      }

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius15),
        ),
        child: SizedBox(
          width: 320,
          height: MediaQuery.of(context).size.height*0.51,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                    color: AppColors.kThemePinkColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kBorderRadius15),
                      topRight: Radius.circular(kBorderRadius15),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: kPadding4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edits Class',
                        style: AppStyles().defaultStyle(24,
                            AppColors.kTextWhiteColor, FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: AppColors.kWhite,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 12,right: 12, bottom: kPadding16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   DialogInputTextField(
                     labelText: 'Subject',
                       myController: subjectController,
                       focusNode: subjectFocus,
                       onFieldSubmittedValue: (val){
                         Utils.onFocusChange(context,  subjectFocus,departmentFocus);
                       }
                       ,
                       hint: 'Subject',
                       onValidator: (val){
                         return null;
                       },
                       keyBoardType: TextInputType.text

                   ),
                    DialogInputTextField(
                        labelText: 'Department',
                        myController: departmentController,
                        focusNode: departmentFocus,
                        onFieldSubmittedValue: (val){
                          Utils.onFocusChange(context,  departmentFocus,batchFocus);
                        }
                        ,
                        hint: 'Department',
                        onValidator: (val){
                          return null;
                        },
                        keyBoardType: TextInputType.text

                    ),
                    DialogInputTextField(
                        labelText: 'Standard/Batch',
                        myController: batchController,
                        focusNode: batchFocus,
                        onFieldSubmittedValue: (val){}
                        ,
                        hint: 'Standard/Batch',
                        onValidator: (val){
                          Utils.onFocusChange(context,  batchFocus,attendanceFocus);
                          return null;
                        },
                        keyBoardType: TextInputType.text

                    ),
                    DialogInputTextField(
                        labelText: 'Attendance Requirement(%)',
                        myController: attendanceController,
                        focusNode: attendanceFocus,
                        onFieldSubmittedValue: (val){}
                        ,
                        hint: 'Attendance Requirement(%)',
                        onValidator: (val){
                          return null;
                        },
                        keyBoardType: TextInputType.number

                    ),

                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomRoundButton(
                      title: 'CLOSE',
                      height: 40,
                      textStyle: AppStyles().defaultStyle(14,
                          AppColors.kTextWhiteColor, FontWeight.bold),
                      borderRaduis: 6,
                      width: MediaQuery.of(context).size.width * 0.35,
                      gradient: false,
                      color: AppColors.kThemePinkColor,
                      onPress: () {

                       Navigator.pop(context);
                      }),
                  CustomRoundButton(
                      title: 'UPDATE',
                      height: 40,
                      textStyle: AppStyles().defaultStyle(14,
                          AppColors.kTextWhiteColor, FontWeight.bold),
                      borderRaduis: 6,
                      width: MediaQuery.of(context).size.width * 0.35,
                      gradient: false,
                      color: AppColors.kThemePinkColor,
                      onPress: () {

                      ClassInputController().updateClass(classId,
                          subjectController.text,
                          departmentController.text,
                          batchController.text,
                         int.parse(attendanceController.text)
                      ).then((value) => {
                        Navigator.pop(context)
                      });

                      })
                ],
              ),
            ],
          ),
        ),
      );
    });
    },
  );
}
