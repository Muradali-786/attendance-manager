import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/utils/component/custom_list_tile.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view_model/class_input/class_input_controller.dart';
import 'package:attendance_manager/view_model/login/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/component/custom_shimmer_effect.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoginController _loginController = LoginController();
  final ClassController _classController = ClassController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.kAppBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Attendance Manager",
          style: AppStyles().defaultStyle(
            20,
            AppColor.kTextWhiteColor,
            FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _loginController.logOutAsTeacher();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _classController.getSubjectData(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: ShimmerLoadingEffect(),
                );
              } else if (snapshot.hasError) {
                return const ErrorClass();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Click on the + button to add new Class'),
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
                    itemBuilder: (context, index) {
                      return CustomListTile(
                        title: snap[index].subjectName.toString(),
                        subtitle:
                            "${snap[index].departmentName} - ${snap[index].batchName}",
                        trailingFirstText: snap[index].percentage.toString(),
                        trailingSecondText: 'Classes',
                        onPress: () {
                          Navigator.pushNamed(context, RouteName.myTabBar,
                              arguments: {
                                'data': snap[index].toMap(),
                              });
                        },
                        onLongPress: () {},
                      );
                    },
                  ),
                );
              }
            },
          ),
          // StreamBuilder<QuerySnapshot>(
          //   stream: fireStoreRef,
          //   builder:
          //       (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       // Show shimmer loading effect while data is loading
          //       return const Expanded(
          //         child: ShimmerLoadingEffect(),
          //       );
          //     } else if (snapshot.hasError) {
          //       return Center(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             const Icon(
          //               Icons.error_outline,
          //               color: AppColors.kAlertColor,
          //               size: 45,
          //             ),
          //             Text(
          //               'Oops..!',
          //               style: AppStyles().defaultStyle(
          //                   23, AppColors.kTextBlackColor, FontWeight.w600),
          //             ),
          //             const SizedBox(
          //               height: 8,
          //             ),
          //             Text(
          //               'Sorry, Something went wrong',
          //               style: AppStyles().defaultStyle(
          //                   16, AppColors.kTextBlackColor, FontWeight.w400),
          //             )
          //           ],
          //         ),
          //       );
          //     } else if (snapshot.hasData) {
          //       return Expanded(
          //         child: ListView.builder(
          //           physics: const BouncingScrollPhysics(),
          //           itemCount: snapshot.data!.docs.length,
          //           itemBuilder: (context, index) {
          //             final data = snapshot.data!.docs[index];
          //             final classId =
          //                 snapshot.data!.docs[index]['classId'].toString();
          //             return CustomListTile(
          //               title: data['subject'],
          //               subtitle: data['department'] + '-' + data['batch'],
          //               trailingFirstText: data['percentage'].toString(),
          //               trailingSecondText: 'Classes',
          //               onPress: () {
          //                 Navigator.pushNamed(context, RouteName.myTabBar,
          //                     arguments: {
          //                       'classId': classId.toString(),
          //                       'subject': data['subject'],
          //                       'batch': data['batch'],
          //                       'department': data['department']
          //                     });
          //                 // updateClassDialog(context, 'Edit Class');
          //               },
          //               onLongPress: () {
          //                 String title = 'Edit Class';
          //                 String firstText = 'UPDATE CLASS';
          //                 String secondText = 'DELETE CLASS';
          //                 showImportDialog(
          //                   context,
          //                   title,
          //                   firstText,
          //                   secondText,
          //                   () {
          //                     // first tap function
          //                     Navigator.pop(context);
          //                     updateClassValueDialog(
          //                       context,
          //                       classId,
          //                       data['subject'],
          //                       data['department'],
          //                       data['batch'],
          //                       int.parse(data['percentage']),
          //                     );
          //                   },
          //                   () {
          //                     // second onTap button
          //
          //                     ClassInputController()
          //                         .deleteClass(classId)
          //                         .then((value) {
          //                       Navigator.pop(context);
          //                     });
          //                   },
          //                 );
          //               },
          //             );
          //           },
          //         ),
          //       );
          //     } else {
          //       return const Center(
          //           child: Text('Click on the + button to add new class'));
          //     }
          //   },
          // ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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

class ErrorClass extends StatelessWidget {
  const ErrorClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.kAlertColor,
            size: 45,
          ),
          Text(
            'Oops..!',
            style: AppStyles()
                .defaultStyle(23, AppColor.kTextBlackColor, FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Sorry, Something went wrong',
            style: AppStyles()
                .defaultStyle(16, AppColor.kTextBlackColor, FontWeight.w400),
          )
        ],
      ),
    );
  }
}
