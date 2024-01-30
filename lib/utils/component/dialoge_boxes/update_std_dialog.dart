import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/input_text_filed/dialog_text_field.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/add_students/add_students_controller.dart';
import 'package:flutter/material.dart';

Future<void> updateStudentDialog(BuildContext context,String studentId,String studentName,String studentRollNumber,String classId,String subject,String title,String firstButton,String secondButton,) async {
  TextEditingController student=TextEditingController(text: studentName);
  FocusNode studentFocus=FocusNode();
  TextEditingController registration=TextEditingController(text: studentRollNumber.toString());
  FocusNode registrationFocus=FocusNode();
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return OrientationBuilder(builder: (BuildContext context,Orientation orientation){
        if (orientation == Orientation.landscape) {
          Navigator.pop(context);// Close the dialog on landscape orientation
          return const SizedBox.shrink(); // Return an empty widget
        }


        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius15),
          ),
          child: SizedBox(
            width: 320,
            height: 260,
            // height: MediaQuery.of(context).size.height*0.340,
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
                          title,
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
                      left: 12,right: 12, top: kPadding4,bottom: kPadding16),
                  child: Column(
                    children: [
                      DialogInputTextField(
                          labelText: 'Student Name',
                          myController: student,
                          focusNode: studentFocus,
                          onFieldSubmittedValue: (val){
                            Utils.onFocusChange(context, studentFocus, registrationFocus);
                          }
                          ,
                          hint: 'Student Name',
                          onValidator: (val){
                            return null;
                          },
                          keyBoardType: TextInputType.text

                      ),
                      DialogInputTextField(
                          labelText: 'Roll Number/Registration#',
                          myController: registration,
                          focusNode: registrationFocus,
                          onFieldSubmittedValue: (val){


                          }
                          ,
                          hint: 'Roll Number/Registration#',
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
                        title: firstButton,
                        height: 40,
                        textStyle: AppStyles().defaultStyle(14,
                            AppColors.kTextWhiteColor, FontWeight.bold),
                        borderRaduis: 6,
                        width: MediaQuery.of(context).size.width * 0.35,
                        gradient: false,
                        color: AppColors.kThemePinkColor,
                        onPress: () {


                          AddStudentsController().updateStudentInClass(classId, subject, studentId, student.text, registration.text).then((value) {

                            Utils.toastMessage('student updated');
                            Navigator.pop(context);
                          }).onError((error, stackTrace) {
                            Utils.toastMessage('error while update student ${error.toString()}');
                            Navigator.pop(context);
                          });

                        }),
                    CustomRoundButton(
                        title: secondButton,
                        height: 40,
                        textStyle: AppStyles().defaultStyle(14,
                            AppColors.kTextWhiteColor, FontWeight.bold),
                        borderRaduis: 6,
                        width: MediaQuery.of(context).size.width * 0.35,
                        gradient: false,
                        color: AppColors.kThemePinkColor,
                        onPress: () {
                              Navigator.pop(context);

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
