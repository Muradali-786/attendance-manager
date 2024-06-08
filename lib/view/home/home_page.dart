import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/component/custom_list_tile.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/delete_confirmations.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/utils/utils.dart';
import 'package:attendance_manager/view/class_input/class_update/update_class_dialog.dart';
import 'package:attendance_manager/view_model/class_input/class_controller.dart';
import 'package:attendance_manager/view_model/services/navigation/navigation_services.dart';
import 'package:attendance_manager/view_model/sign_up/sign_up_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../utils/component/common.dart';
import '../../utils/component/custom_shimmer_effect.dart';
import '../../utils/component/user_profile_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ClassController _classController = ClassController();
  final SignUpController _controller = SignUpController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
          bool isAllowed = await _controller
              .checkForAccessPermission(_auth.currentUser!.uid);
          if (isAllowed) {
            // Navigator.pushNamed(context, RouteName.classInputPage);
            NavigationService().navigateToRoute(RouteName.classInputPage);
          } else {
            EasyLoading.showError('Access not allowed', duration: const Duration(seconds: 2));
          }
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
