import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'import_student_from_classes_dialog.dart';

Future<void> showAllAvailableClassesDialog(BuildContext context,currentClassId) async {
  final ClassController classController = ClassController();
  SizeConfig().init(context);
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    }else {
                      List<ClassInputModel> snap =
                          snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        return ClassInputModel.fromMap(data);
                      }).toList();

                      return ListView.builder(
                        itemCount: snap.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // this will not show  the current register class

                          if(snap[index].subjectId!=currentClassId){
                            return GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                await importStudentFromClassesDialog(
                                    context, snap[index],currentClassId);
                              },

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${snap[index].subjectName}(${snap[index].departmentName}-${snap[index].batchName})",
                                        style: const TextStyle(fontSize: 20),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),),
                            );
                          }else{
                            return const SizedBox();
                          }

                        },
                      );
                    }
                  },
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
