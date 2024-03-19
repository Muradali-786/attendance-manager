import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/view/myTabBar/attendance/attendance_tab.dart';
import 'package:attendance_manager/view/myTabBar/history/history_tab.dart';
import 'package:attendance_manager/view/myTabBar/student/students_tab.dart';

import 'package:flutter/material.dart';

class MyTabBar extends StatefulWidget {
  final Map data;
  const MyTabBar({Key? key, required this.data}) : super(key: key);

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
                    padding: const EdgeInsets.only(left: 22, top: 16),
                    child: Text(
                      "$subName ($batch-$depName)",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles().defaultStyle(
                          20, AppColor.kTextWhiteColor, FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.015,
                  ),
                  TabBar(
                      padding: EdgeInsets.zero,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: AppColor.kSecondaryColor,
                      controller: _tabController,

                      labelColor: AppColor.kTextWhiteColor,
                      labelStyle: AppStyles().defaultStyle(
                          13, AppColor.kTextWhiteColor, FontWeight.w500),
                      unselectedLabelColor:
                          AppColor.kTextWhiteColor.withOpacity(0.8),
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
                  HistoryTab(subjectId: subId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
