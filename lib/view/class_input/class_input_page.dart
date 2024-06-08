import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/custom_stepper.dart';
import 'package:attendance_manager/utils/component/input_text_filed/custom_input_text_filed.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  TextEditingController cHourController = TextEditingController();
  FocusNode cHourFocus = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    cHourController.dispose();
    cHourFocus.dispose();
    super.dispose();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    String teacherId = _auth.currentUser!.uid.toString();

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
                          if (val.trim().isEmpty) {
                            return 'Please enter a subject';
                          } else if (val.trim().length < 3) {
                            return 'Subject cannot contain special characters';
                          } else if (!RegExp(r'^[a-zA-Z0-9 ]+$')
                              .hasMatch(val)) {
                            return 'Subject cannot contain special characters';
                          }
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
                            if (val.trim().isEmpty) {
                              return 'Please enter a department';
                            } else if (val.trim().length < 2) {
                              return 'Subject must be at least 2 characters long';
                            } else if (!RegExp(r'^[a-zA-Z0-9 ]+$')
                                .hasMatch(val)) {
                              return 'Department cannot contain special characters';
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.emailAddress),
                      CustomInputTextField(
                          myController: batchController,
                          focusNode: batchFocus,
                          onFieldSubmittedValue: (val) {
                            Utils.onFocusChange(
                                context, batchFocus, cHourFocus);
                          },
                          labelText: 'Semester/Batch',
                          onValidator: (val) {
                            if (val.trim().isEmpty) {
                              return 'Please enter a Semester/Batch';
                            } else if (val.trim().length < 4) {
                              return 'Semester/Batch must be at least 4 characters long';
                            } else if (!RegExp(r'^[a-zA-Z0-9 ]+$')
                                .hasMatch(val)) {
                              return 'Semester/Batch cannot contain special characters';
                            }

                            return null;
                          },
                          keyBoardType: TextInputType.streetAddress),
                      CustomInputTextField(
                          myController: cHourController,
                          focusNode: cHourFocus,
                          onFieldSubmittedValue: (val) {
                            Utils.onFocusChange(
                                context,cHourFocus,percentageFocus);
                          },
                          labelText: 'Credit Hour',
                          onValidator: (val) {
                            if (val.isEmpty) {
                              return 'Please enter a credit Hour';
                            } else if (val.length != 1 || !(val == '1' || val == '2' || val == '3' || val == '4')) {
                              return 'Please Enter 1,2, 3, or 4';
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.number),
                      CustomInputTextField(
                          myController: percentageController,
                          focusNode: percentageFocus,
                          onFieldSubmittedValue: (val) {},
                          labelText: 'Attendance Requirement (%)',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Consumer<ClassController>(
        builder: (context, provider, child) {
          return CustomRoundButton(
            height: getProportionalHeight(55),
            loading: provider.loading,
            width: double.infinity,
            buttonColor: AppColor.kPrimaryColor,
            title: 'Next',
            onPress: () async {
              if (_formKey.currentState!.validate()) {
                ClassInputModel classInputModel = ClassInputModel(
                  subjectName: subjectController.text.trim(),
                  departmentName: departmentController.text.trim(),
                  teacherId: teacherId,
                  batchName: batchController.text.trim(),
                  creditHour: cHourController.text,
                  percentage: int.tryParse(percentageController.text),
                );
                provider.createNewClass(classInputModel).then(
                  (value) {
                    subjectController.clear();
                    batchController.clear();
                    departmentController.clear();
                    cHourController.clear();
                    batchController.clear();
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
