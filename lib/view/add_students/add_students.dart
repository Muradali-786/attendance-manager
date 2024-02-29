import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/add_student_dialog.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/import_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class AddStudentPage extends StatefulWidget {
  dynamic data;
  AddStudentPage({super.key, required this.data});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [

            Positioned(
              top: h * 0.5,
              left: 0,
              right: 0,
              child: Center(
                child: CustomRoundButton(
                  title: 'IMPORT STUDENTS',
                  borderRaduis: 4,
                  width: w * 0.52,
                  height: 40,
                  gradient: false,
                  color: AppColors.kThemePinkColor,
                  onPress: () {
                    String title = 'Import Students';
                    String firstText = 'IMPORT FROM EXCEL';
                    String secondText = 'IMPORT FROM CLASS';
                    showImportDialog(
                        context, title, firstText, secondText, () {}, () {});
                  },
                ),
              ),
            ),
            Positioned(
              top: h * 0.56,
              left: 0,
              right: 0,
              child: Text(
                'Click on the + button to add students in this class',
                style: AppStyles().defaultStyleWithHt(
                  16,
                  AppColors.kTextBlackColor.withOpacity(0.5),
                  FontWeight.normal,
                  3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: w,
                height: 50,
                decoration: const BoxDecoration(
                    gradient: AppColors.kPrimaryLinearGradient),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'PREVIOUS',
                        style: AppStyles()
                            .defaultStyle(18, Colors.white, FontWeight.normal),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteName.homePage);
                        },
                        child: Text(
                          'FINISH',
                          style: AppStyles().defaultStyle(
                              18, Colors.white, FontWeight.normal),
                        )),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: kPadding20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    String title = 'Add Students';
                    String firstButton = 'ADD ANOTHER';
                    String secondButton = 'SAVE & CLOSE';
                    addStudentDialog(
                      context,
                      widget.data['classId'],
                      widget.data['subject'],
                      title,
                      firstButton,
                      secondButton,
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.kThemePinkColor),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: AppColors.kWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
