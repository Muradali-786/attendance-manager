import 'package:flutter/material.dart';

import '../../constant/app_style/app_colors.dart';
import '../../constant/app_style/app_styles.dart';
import '../../size_config.dart';

class CustomAttendanceList extends StatelessWidget {
  final String stdName, stdRollNo, attendanceStatus;
  final VoidCallback onTap;

  const CustomAttendanceList({
    super.key,
    required this.stdName,
    required this.stdRollNo,
    required this.attendanceStatus,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 20),
        width: double.infinity,
        height: getProportionalHeight(88),
        decoration: BoxDecoration(
          color: AppColor.kWhite,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: AppColor.kBlack.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 1.5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stdName,
                  style: AppStyles().defaultStyle(
                    22,
                    AppColor.kTextBlackColor,
                    FontWeight.w400,
                  ),
                ),
                Text(
                  stdRollNo,
                  style: AppStyles().defaultStyleWithHt(
                    17,
                    AppColor.kTextGreyColor,
                    FontWeight.normal,
                    1.5,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    height: 53,
                    width: 65,
                    decoration: BoxDecoration(
                      color: getStatusColor(attendanceStatus),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Text(
                        attendanceStatus,
                        style: AppStyles().defaultStyle(
                          32,
                          AppColor.kTextWhiteColor,
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'A':
        return AppColor.kSecondaryColor;
      case 'L':
        return AppColor.kSecondary54Color;
      default:
        return AppColor.kPrimaryTextColor;
    }
  }
}

class CustomAttendanceList2 extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool showDelete;
  final VoidCallback? onPressDelete;
  const CustomAttendanceList2(
      {super.key,
      required this.title,
      this.showDelete = false,
      required this.onTap,
      this.onPressDelete});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
        child: Container(
          height: getProportionalHeight(47),
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: AppColor.kWhite,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: AppColor.kBlack.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 1.5,
                  offset: const Offset(
                    0,
                    1,
                  ), // controls the shadow position
                )
              ]),
          child: Row(
            children: [
              Container(
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                  color: AppColor.kPrimaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: SizeConfig.screenWidth! * 0.05),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles().defaultStyle(getProportionalWidth(18),
                      AppColor.kTextBlackColor, FontWeight.w400),
                ),
              ),
              if (showDelete)
                IconButton(
                  onPressed: onPressDelete,
                  icon: const Icon(
                    Icons.delete,
                    color: AppColor.kSecondaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAttendanceList3 extends StatelessWidget {
  final String dateTime, attendanceStatus;
  const CustomAttendanceList3(
      {super.key, required this.dateTime, required this.attendanceStatus});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: Container(
        height: SizeConfig.screenHeight! * 0.08,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: AppColor.kWhite,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: AppColor.kBlack.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 1.5,
                offset: const Offset(
                  0,
                  1,
                ), // controls the shadow position
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateTime,
              style: AppStyles()
                  .defaultStyle(12, AppColor.kTextGrey54Color, FontWeight.w400),
            ),
            Text(
              getStatusValue(attendanceStatus),
              style: AppStyles().defaultStyleWithHt(
                  16, AppColor.kTextBlackColor, FontWeight.w400, 1.5),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusValue(String input) {
    switch (input) {
      case 'A':
        return 'ABSENT';
      case 'L':
        return 'LEAVE';
      default:
        return 'PRESENT';
    }
  }
}
