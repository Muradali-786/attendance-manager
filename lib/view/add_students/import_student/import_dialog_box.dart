import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/view/add_students/import_student/import_student_from_classes_dialog.dart';
import 'package:flutter/material.dart';
import 'import_excel_sheet_dialpg.dart';

Future<void> showImportDialog(
  BuildContext context,String currentClassId
) async {
  SizeConfig().init(context);
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColor.kSecondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kBorderRadius15),
                  topRight: Radius.circular(kBorderRadius15),
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
                    'Import Students',
                    style: AppStyles().defaultStyle(
                        22, AppColor.kTextWhiteColor, FontWeight.w400),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: AppColor.kWhite,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.020,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:SizeConfig.screenWidth! * 0.14),
                  child: CustomRoundButton(
                      height: 35,
                      title: 'IMPORT FROM EXCEL',
                      onPress: () async{
                        Navigator.pop(context);
                        await importExcelSheetDialog(context,currentClassId);
                      },
                      buttonColor: AppColor.kSecondaryColor),
                ),
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.54,
                  child: const Divider(
                    color: AppColor.kSecondaryColor,
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:SizeConfig.screenWidth! * 0.14),
                  child: CustomRoundButton(
                      height: 35,
                      title: 'IMPORT FROM CLASS',
                      onPress: ()async {
                        Navigator.pop(context);
                        importStudentFromClassesDialog(context, null,currentClassId);
                      },
                      buttonColor: AppColor.kSecondaryColor),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.020,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
