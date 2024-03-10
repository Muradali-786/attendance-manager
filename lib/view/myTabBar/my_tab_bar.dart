import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/model/class_model.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/view/myTabBar/attendance/attendance_tab.dart';
import 'package:attendance_manager/view/myTabBar/history/history_tab.dart';
import 'package:attendance_manager/view/myTabBar/student/students_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class MyTabBar extends StatefulWidget {
//   var data;
//   MyTabBar({Key? key, required this.data}) : super(key: key);
//
//   @override
//   _MyTabBarState createState() => _MyTabBarState();
// }
//
// class _MyTabBarState extends State<MyTabBar>
//     with SingleTickerProviderStateMixin {
//   late final TabController _tabController =
//       TabController(length: 3, vsync: this);
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   final fireStoreRef =
//       FirebaseFirestore.instance.collection('Class').snapshots();
//   @override
//   Widget build(BuildContext context) {
//     double h = MediaQuery.sizeOf(context).height;
//     double w = MediaQuery.sizeOf(context).width;
//     print('how is this');
//     print(widget.data.toString());
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration:
//             const BoxDecoration(gradient: AppColors.kPrimaryLinearGradient),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                     gradient: AppColors.kPrimaryLinearGradient),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: kPadding27, top: kPadding16),
//                       child: Text(
//                         widget.data['subject'].toUpperCase() +
//                             ' ' +
//                             '(${widget.data['batch'].toUpperCase() + '-' + widget.data['department'].toUpperCase()})',
//                         style: AppStyles().defaultStyle(
//                             20, AppColors.kTextWhiteColor, FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(
//                       height: h * 0.026,
//                     ),
//                     TabBar(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: kPadding16),
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         indicatorColor: AppColors.kThemePinkColor,
//                         controller: _tabController,
//                         labelColor: AppColors.kTextWhiteColor,
//                         labelStyle: AppStyles().defaultStyle(
//                             12, AppColors.kTextWhiteColor, FontWeight.bold),
//                         unselectedLabelColor:
//                             AppColors.kTextWhiteColor.withOpacity(0.8),
//                         tabs: const [
//                           Tab(
//                             child: Text('ATTENDANCE'),
//                           ),
//                           Tab(
//                             child: Text('STUDENTS'),
//                           ),
//                           Tab(
//                             child: Text('HISTORY'),
//                           ),
//                         ]),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     AttendanceTab(
//                       classId: widget.data['classId'],
//                       subject: widget.data['subject'],
//                     ),
//                     StudentTab(
//                       classId: widget.data['classId'],
//                       subject: widget.data['subject'],
//                     ),
//                     HistoryTab(
//                       classId: widget.data['classId'],
//                       subject: widget.data['subject'],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MyTabBar extends StatefulWidget {
  final Map data;
  MyTabBar({Key? key, required this.data}) : super(key: key);

  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String subName = widget.data['data']['subjectName'];
    String batch = widget.data['data']['batchName'];
    String depName = widget.data['data']['departmentName'];
    String subId = widget.data['data']['subjectId'];

    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColor.kPrimaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 27, top: 16),
                      child: Text(
                        "$subName ($batch-$depName)",
                        style: AppStyles().defaultStyle(
                            20, AppColors.kTextWhiteColor, FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.026,
                    ),
                    TabBar(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: AppColor.kSecondaryColor,
                        controller: _tabController,
                        labelColor: AppColor.kTextWhiteColor,
                        labelStyle: AppStyles().defaultStyle(
                            13, AppColor.kTextWhiteColor, FontWeight.bold),
                        unselectedLabelColor:
                            AppColors.kTextWhiteColor.withOpacity(0.8),
                        tabs: const [
                          Tab(
                            child: Text('ATTENDANCE'),
                          ),
                          Tab(
                            child: Text('STUDENTS'),
                          ),
                          Tab(
                            child: Text('HISTORY'),
                          ),
                        ]),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    AttendanceTab(subjectId: subId),
                    StudentTab(subjectId: subId),
                    Text('CLASS2'),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
