import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/component/common.dart';
import 'show_all_available_classes_dialog.dart';

Future<void> importStudentFromClassesDialog(
    BuildContext context, ClassInputModel? e, String currentClassID) async {
  final ClassController classController = ClassController();

  await showDialog(
    context: context,
    builder: (context) {
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
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: classController.getClassData(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColor.kSecondaryColor,
                      ));
                    } else {
                      Map data = snapshot.data!.docs.first.data() as Map;
                      if (data['subjectId'] == currentClassID) {
                        data = snapshot.data!.docs.last.data() as Map;
                      }

                      ClassInputModel model =
                          e ?? ClassInputModel.fromMap(data);
                      if (model.subjectId != currentClassID) {
                        return GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            await showAllAvailableClassesDialog(
                                context, currentClassID);
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 33),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${model.subjectName}(${model.departmentName}-${model.batchName})",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down_sharp)
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 0, 25, 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: CustomRoundButton(
                                          title: 'CLOSE',
                                          height: 32,
                                          onPress: () {
                                            Navigator.pop(context);
                                          },
                                          buttonColor:
                                              AppColor.kSecondaryColor),
                                    ),
                                    const SizedBox(width: 5),
                                    Consumer<StudentController>(
                                        builder: (context, provider, _) {
                                      return Expanded(
                                        child: CustomRoundButton(
                                            title: 'IMPORT',
                                            loading: provider.loading,
                                            height: 32,
                                            onPress: () {
                                              provider
                                                  .migrateStudentsToClass(
                                                      model.subjectId
                                                          .toString(),
                                                      currentClassID)
                                                  .then((value) {
                                                Navigator.pop(context);
                                              });
                                            },
                                            buttonColor:
                                                AppColor.kSecondaryColor),
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const ErrorImportStudentClass();
                      }
                    }
                  },
                )
              ],
            ),
          ],
        ),
      );
    },
  );
}
