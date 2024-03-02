import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/custom_stepper.dart';
import 'package:attendance_manager/utils/component/input_text_filed/custom_input_text_filed.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/class_input/class_input_controller.dart';
import 'package:flutter/material.dart';

import '../../model/class_model.dart';

class ClassInputPage extends StatefulWidget {
  const ClassInputPage({super.key});

  @override
  State<ClassInputPage> createState() => _ClassInputPageState();
}

class _ClassInputPageState extends State<ClassInputPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController subjectController = TextEditingController();
  FocusNode subjectFocus = FocusNode();
  TextEditingController batchController = TextEditingController();
  FocusNode batchFocus = FocusNode();
  TextEditingController departmentController = TextEditingController();
  FocusNode departmentFocus = FocusNode();
  TextEditingController percentageController = TextEditingController();
  FocusNode percentageFocus = FocusNode();

  @override
  void dispose() {
    subjectController.dispose();
    subjectFocus.dispose();
    batchController.dispose();
    batchFocus.dispose();
    departmentController.dispose();
    departmentFocus.dispose();
    percentageController.dispose();
    percentageFocus.dispose();
    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: AppColor.kWhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding15),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight! * 0.03),
                const CustomStepper(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInputTextField(
                        myController: subjectController,
                        focusNode: subjectFocus,
                        onFieldSubmittedValue: (val) {
                          Utils.onFocusChange(
                              context, subjectFocus, departmentFocus);
                        },
                        labelText: 'Subject',
                        onValidator: (val) {
                          return null;
                        },
                        keyBoardType: TextInputType.text,
                      ),
                      CustomInputTextField(
                          myController: departmentController,
                          focusNode: departmentFocus,
                          onFieldSubmittedValue: (val) {
                            Utils.onFocusChange(
                                context, departmentFocus, batchFocus);
                          },
                          labelText: 'Department',
                          onValidator: (val) {
                            return null;
                          },
                          keyBoardType: TextInputType.emailAddress),
                      CustomInputTextField(
                          myController: batchController,
                          focusNode: batchFocus,
                          onFieldSubmittedValue: (val) {
                            Utils.onFocusChange(
                                context, batchFocus, percentageFocus);
                          },
                          labelText: 'Semester/Batch',
                          onValidator: (val) {
                            return null;
                          },
                          keyBoardType: TextInputType.streetAddress),
                      CustomInputTextField(
                          myController: percentageController,
                          focusNode: percentageFocus,
                          onFieldSubmittedValue: (val) {},
                          labelText: 'Attendance Requirement (%)',
                          onValidator: (val) {
                            return null;
                          },
                          keyBoardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomSheet: CustomRoundButton(
      //     height: getProportionalHeight(55),
      //     loading: loading,
      //     width: double.infinity,
      //     borderRaduis: 0,
      //     title: 'Next',
      //     textStyle:
      //         AppStyles().defaultStyle(20, Colors.white, FontWeight.w500),
      //     onPress: () {
      //       setState(() {
      //         loading = true;
      //       });
      //       int percentage = int.parse(percentageController.text);
      //       String classId = DateTime.now().millisecondsSinceEpoch.toString();
      //
      //       ClassInputController()
      //           .addClass(
      //               classId,
      //               subjectController.text,
      //               departmentController.text,
      //               batchController.text,
      //               percentage)
      //           .then((value) {
      //         Navigator.pushReplacementNamed(
      //             context, RouteName.addStudentPage,
      //             arguments: {
      //               'subject': subjectController.text,
      //               'classId': classId.toString(),
      //             });
      //         subjectController.clear();
      //         departmentController.clear();
      //         batchController.clear();
      //         percentageController.clear();
      //         setState(() {
      //           loading = false;
      //         });
      //       }).onError((error, stackTrace) {
      //         Utils.toastMessage(error.toString());
      //         setState(() {
      //           loading = false;
      //         });
      //       });
      //     })
      bottomSheet: CustomRoundButton(
        height: getProportionalHeight(55),
        loading: loading,
        width: double.infinity,
        borderRaduis: 0,
        title: 'Next',
        textStyle: AppStyles().defaultStyle(20, Colors.white, FontWeight.w500),
        onPress: () async {
          ClassInputModel classInputModel = ClassInputModel(
            subjectName: subjectController.text,
            departmentName: departmentController.text,
            batchName: batchController.text,
            percentage: int.tryParse(percentageController.text),
          );
          await ClassController().createNewClass(classInputModel);
        },
      ),
    );
  }
}
