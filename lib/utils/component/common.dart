import 'package:flutter/material.dart';

import '../../constant/app_style/app_colors.dart';
import '../../constant/app_style/app_styles.dart';
import '../../size_config.dart';

class ReUsableText extends StatelessWidget {
  final String title, value;

  const ReUsableText({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppStyles().defaultStyle(
            32,
            AppColor.kPrimaryTextColor,
            FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: AppStyles().defaultStyleWithHt(
              18, AppColor.kTextGreyColor, FontWeight.w400, 1.5),
        ),
      ],
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
            color: AppColor.kAlertColor,
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

class AddStudentButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddStudentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: getProportionalHeight(60),
        width: getProportionalHeight(60),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.kSecondaryColor,
        ),
        child: const Icon(
          Icons.add,
          size: 30,
          color: AppColor.kWhite,
        ),
      ),
    );
  }
}