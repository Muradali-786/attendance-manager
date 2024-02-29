import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/component/time_line_widget.dart';
import 'package:attendance_manager/utils/component/input_text_filed/input_text_filed.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view_model/class_input/class_input_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassInputPage extends StatefulWidget {
  const ClassInputPage({super.key});

  @override
  State<ClassInputPage> createState() => _ClassInputPageState();
}

class _ClassInputPageState extends State<ClassInputPage> {
  TextEditingController subjectController = TextEditingController();
  FocusNode subjectFocus = FocusNode();
  TextEditingController batchController = TextEditingController();
  FocusNode batchFocus = FocusNode();
  TextEditingController departmentController = TextEditingController();
  FocusNode departmentFocus = FocusNode();
  TextEditingController percentageController = TextEditingController();
  FocusNode percentageFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
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

   bool loading =false;

  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
        backgroundColor: AppColors.kAppBackgroundColor,
        body: Container(
          height: h,
          width: w,
          decoration:
          const BoxDecoration(gradient: AppColors.kPrimaryLinearGradient),
          child: SafeArea(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.kWhite),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding15),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        height: 92,
                        width: double.infinity,
                        child: TimeLineWidget(isFirstPage: false),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputTextField(
                                  myController: subjectController,
                                  focusNode: subjectFocus,
                                  onFieldSubmittedValue: (val) {
                                    Utils.onFocusChange(
                                        context, subjectFocus, departmentFocus);
                                  },
                                  hint: 'Subject',
                                  onValidator: (val) {
                                    return null;
                                  },
                                  keyBoardType: TextInputType.text),
                              InputTextField(
                                  myController: departmentController,
                                  focusNode: departmentFocus,
                                  onFieldSubmittedValue: (val) {
                                    Utils.onFocusChange(
                                        context, departmentFocus, batchFocus);
                                  },
                                  hint: 'Department',
                                  onValidator: (val) {
                                    return null;
                                  },
                                  keyBoardType: TextInputType.text),
                              InputTextField(
                                  myController: batchController,
                                  focusNode: batchFocus,
                                  onFieldSubmittedValue: (val) {
                                    Utils.onFocusChange(
                                        context, batchFocus, percentageFocus);
                                  },
                                  hint: 'Semester/Batch',
                                  onValidator: (val) {
                                    return null;
                                  },
                                  keyBoardType: TextInputType.text),
                              InputTextField(
                                  myController: percentageController,
                                  focusNode: percentageFocus,
                                  onFieldSubmittedValue: (val) {},
                                  hint: 'Attendance Requirement (%)',
                                  onValidator: (val) {
                                    return null;
                                  },
                                  keyBoardType: TextInputType.number),
                              // SizedBox(height: 10,),
                              // CustomTextField2(controller:departmentController,
                              //     focusNode:departmentFocus,
                              //     keyboardType: TextInputType.text,
                              //     hintText: 'Class'
                              // )


                            ],
                          ),


                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomRoundButton(
            height: 53,
            loading: loading,
            width: w,
            borderRaduis: 0,
            title: 'Next',
            textStyle:
            AppStyles().defaultStyle(20, Colors.white, FontWeight.bold),

            onPress: (){
              setState(() {
                loading=true;
              });
              int percentage = int.parse(percentageController.text);
              String classId = DateTime.now().millisecondsSinceEpoch.toString();

              ClassInputController().addClass(classId,subjectController.text,
                  departmentController.text, batchController.text, percentage).then((value) {
                Navigator.pushReplacementNamed(context, RouteName.addStudentPage,
                    arguments: {
                      'subject':subjectController.text,
                      'classId':classId.toString(),
                    }

                );
                subjectController.clear();
                departmentController.clear();
                batchController.clear();
                percentageController.clear();
                setState(() {
                  loading=false;
                });
              }).onError((error, stackTrace){

                Utils.toastMessage(error.toString());
                setState(() {
                  loading=false;
                });
              });



            })
    );
  }
}

