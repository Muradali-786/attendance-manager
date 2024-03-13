import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailingFirstText;
  final String trailingSecondText;
  final VoidCallback onPress;
  final VoidCallback onLongPress;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.trailingFirstText,
    required this.trailingSecondText,
    required this.onPress,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onPress,
        child: Container(
          height: 97,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 11, right: 21),
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
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppStyles().defaultStyle(
                        22, AppColor.kTextBlackColor, FontWeight.w400),
                  ),
                  Text(
                    subtitle,
                    style: AppStyles().defaultStyleWithHt(
                      16,
                      AppColor.kTextGrey54Color,
                      FontWeight.normal,
                      2,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trailingFirstText,

                    style: AppStyles().defaultStyle(
                      28,
                      AppColor.kPrimaryTextColor,
                      FontWeight.w700,
                    ),
                  ),
                  Text(
                    trailingSecondText,
                    style: AppStyles().defaultStyleWithHt(
                        16, AppColor.kTextGreyColor, FontWeight.normal, 1.5),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
