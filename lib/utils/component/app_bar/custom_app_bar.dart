
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:flutter/material.dart';
import 'package:attendance_manager/constant/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final double preferredHeight;
  final TextStyle? textStyle;
  final bool automaticallyImplyLeading,showLeading;

  const CustomAppBar({
    Key? key,
    required this.titleText,
    required this.preferredHeight,
    this.textStyle,
    this.automaticallyImplyLeading=false,
    this.showLeading=false,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kTransparentColor,
      elevation: 0,
      centerTitle: true,
      leading: showLeading
          ? Padding(
        padding: const EdgeInsets.only(left: kPadding8),
        child: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.kWhite),
        ),
      )
          : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      flexibleSpace: PreferredSize(
        preferredSize: Size.fromHeight(preferredHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.kPrimaryLinearGradient,
          ),
          child: Center(
            child: Text(
              titleText,
              style: textStyle ??
                   AppStyles().defaultStyleWithHt(24, AppColors.kTextWhiteColor, FontWeight.w700,3.5),
            ),
          ),
        ),
      ),
    );
  }
}
