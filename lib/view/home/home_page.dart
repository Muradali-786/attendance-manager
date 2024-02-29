import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/app_bar/custom_app_bar.dart';
import 'package:attendance_manager/utils/component/custom_list_tile.dart';
import 'package:attendance_manager/utils/component/dialoge_boxes/import_dialog_box.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view/class_input/class_update/update_class_dialog.dart';
import 'package:attendance_manager/view_model/class_input/class_input_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fireStoreRef =
      FirebaseFirestore.instance.collection('Class').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.kAppBackgroundColor,
      appBar: const CustomAppBar(
        titleText: 'Attendance Manager',
        preferredHeight: 58,
      ),
      body: SafeArea(
          child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: fireStoreRef,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show shimmer loading effect while data is loading
                return const Expanded(
                  child: ShimmerLoadingEffect(),
                );
              } else if (snapshot.hasError) {
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
                        style: AppStyles().defaultStyle(
                            23, AppColors.kTextBlackColor, FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Sorry, Something went wrong',
                        style: AppStyles().defaultStyle(
                            16, AppColors.kTextBlackColor, FontWeight.w400),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      final classId =
                          snapshot.data!.docs[index]['classId'].toString();
                      return CustomListTile(
                        title: data['subject'],
                        subtitle: data['department'] + '-' + data['batch'],
                        trailingFirstText: data['percentage'].toString(),
                        trailingSecondText: 'Classes',
                        onPress: () {
                          Navigator.pushNamed(context, RouteName.myTabBar,
                              arguments: {
                                'classId': classId.toString(),
                                'subject': data['subject'],
                                'batch': data['batch'],
                                'department': data['department']
                              });
                          // updateClassDialog(context, 'Edit Class');
                        },
                        onLongPress: () {
                          String title = 'Edit Class';
                          String firstText = 'UPDATE CLASS';
                          String secondText = 'DELETE CLASS';
                          showImportDialog(
                            context,
                            title,
                            firstText,
                            secondText,
                            () {
                              // first tap function
                              Navigator.pop(context);
                              updateClassValueDialog(
                                context,
                                classId,
                                data['subject'],
                                data['department'],
                                data['batch'],
                                int.parse(data['percentage']),
                              );
                            },
                            () {
                              // second onTap button

                              ClassInputController()
                                  .deleteClass(classId)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                    child: Text('Click on the + button to add new class'));
              }
            },
          ),
        ],
      )),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.classInputPage);
        },
        backgroundColor: AppColors.kThemePinkColor,
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: AppColors.kWhite,
        ),
      ),
    );
  }
}

class ShimmerLoadingEffect extends StatelessWidget {
  final double height;
  const ShimmerLoadingEffect({Key? key, this.height = 84}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
        itemCount: 6, // Number of shimmer items you want to show
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.only(
              left: 10,
              right: kPadding20,
              top: kPadding15,
              bottom: 12,
            ),
            height: height,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
