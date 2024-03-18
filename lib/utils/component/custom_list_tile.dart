import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String keyValue;
  final String trailingFirstText;
  final String trailingSecondText;
  final VoidCallback onPress;
  final VoidCallback onLongPress;
  final VoidCallback onDismiss;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.keyValue,
    required this.subtitle,
    required this.trailingFirstText,
    required this.trailingSecondText,
    required this.onPress,
    required this.onLongPress,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Dismissible(
        key: Key(keyValue),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 40),
          color: AppColor.kSecondaryColor,
          child: const Icon(
            Icons.delete,
            color: AppColor.kWhite,
          ),
        ),
        onDismissed: (direction) {
          onDismiss();
        },
        child: GestureDetector(
          onLongPress: onLongPress,
          onTap: onPress,
          child: Container(
            height: 85,
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
      ),
    );
  }
}
