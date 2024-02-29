import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
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
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onPress,
      child: Container(
        height: 97,
        width: double.infinity,
        padding: const EdgeInsets.only(top: kPadding16, left: 11, right: 21),
        margin: const EdgeInsets.only(top: kPadding15, left: 11, right: 11),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: AppColors.kBlack.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 1.5,
              offset: const Offset(0, 1), // controls the shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles().defaultStyle(
                      22, AppColors.kTextBlackColor, FontWeight.w400),
                ),
                Text(
                  subtitle,
                  style: AppStyles().defaultStyleWithHt(
                      16,
                      AppColors.kTextBlackColor.withOpacity(0.5),
                      FontWeight.normal,
                      2),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                 trailingFirstText,
                  style: AppStyles().defaultStyle(
                    28,
                    AppColors.kTextSkyColor,
                    FontWeight.w900,
                  ),
                ),
                Text(
                  trailingSecondText,
                  style: AppStyles().defaultStyle(
                    16,
                    AppColors.kTextBlackColor.withOpacity(0.5),
                    FontWeight.normal,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
