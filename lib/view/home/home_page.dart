import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/component/custom_list_tile.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/delete_confirmations.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view/class_input/class_update/update_class_dialog.dart';
import 'package:attendance_manager/view_model/add_students/students_controller.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/component/common.dart';
import '../../utils/component/custom_shimmer_effect.dart';
import '../../utils/component/user_profile_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoginController _loginController = LoginController();
  final ClassController _classController = ClassController();
  final StudentController _studentController = StudentController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.kBgColor,
      appBar: AppBar(
        title: Text(
          "Attendance Manager",
          style: AppStyles().defaultStyle(
            20,
            AppColor.kTextWhiteColor,
            FontWeight.w600,
          ),
        ),

      ),
      drawer: const UserProfile(),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _classController.getClassData(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: ShimmerLoadingEffect(),
                );
              } else if (snapshot.hasError) {
                return const ErrorClass();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'Click on the + button to add new Class',
                    style: TextStyle(color: AppColor.kTextGreyColor),
                  ),
                );
              } else {
                List<ClassInputModel> snap = snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return ClassInputModel.fromMap(data);
                }).toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: snap.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        title: snap[index].subjectName.toString(),
                        keyValue: snap[index].subjectId.toString(),
                        subtitle:
                            "${snap[index].departmentName} - ${snap[index].batchName}",
                        trailingFirstText: snap[index].totalClasses.toString(),
                        trailingSecondText: 'Classes',
                        onPress: () {
                          Navigator.pushNamed(context, RouteName.myTabBar,
                              arguments: {
                                'data': snap[index].toMap(),
                              });
                        },
                        onLongPress: () {
                          updateClassValueDialog(context, snap[index]);
                        },
                        onDismiss: () {
                          showDeleteClassConfirmationDialog(
                              context, snap[index]);
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, RouteName.classInputPage);
        },
        backgroundColor: AppColor.kButtonColor,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: AppColor.kWhite,
        ),
      ),
    );
  }
}


