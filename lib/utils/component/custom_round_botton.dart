import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:flutter/material.dart';

class CustomRoundButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback onPress;
  final Color buttonColor;
  final bool loading;

  const CustomRoundButton({
    Key? key,
    required this.title,
    required this.onPress,
    required this.buttonColor,
    this.width = double.infinity,
    this.height = 50,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.kWhite,
                ),
              )
            : Center(
                child: Text(
                  title,
                  style: AppStyles().defaultStyle(
                    14,
                    AppColor.kWhite,
                    FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }
}
