import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:flutter/material.dart';

class DialogInputTextField extends StatelessWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;

  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final bool obsecureText;
  final String hint, labelText;
  final Color cursorColor;
  final bool enable, autoFocus;
  const DialogInputTextField({
    Key? key,
    this.cursorColor = AppColors.kBlack,
    required this.myController,
    required this.focusNode,
    required this.onFieldSubmittedValue,
    required this.hint,
    required this.labelText,
    required this.onValidator,
    required this.keyBoardType,
    this.obsecureText = false,
    this.enable = true,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmittedValue,
      validator: onValidator,
      keyboardType: keyBoardType,
      cursorColor: cursorColor,
      enabled: enable,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: AppStyles()
          .defaultStyle(18, AppColor.kPrimaryTextColor, FontWeight.w400),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.all(kPadding16),
        hintStyle: AppStyles().defaultStyle(
          20,
          AppColor.kTextGreyColor,
          FontWeight.w400,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.kFocusBorderColor),
        ),
        labelText: labelText,
        labelStyle: AppStyles().defaultStyle(
          14,
          AppColor.kSecondaryTextColor,
          FontWeight.normal,
        ),
      ),
    );
  }
}
