import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:flutter/material.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;

  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final bool obsecureText;
  final String labelText;
  final Color cursorColor;
  final bool enable, autoFocus;
  const CustomInputTextField({
    Key? key,
    this.cursorColor = AppColor.kSecondaryColor,
    required this.myController,
    required this.focusNode,
    required this.onFieldSubmittedValue,
    required this.labelText,
    required this.onValidator,
    required this.keyBoardType,
    this.obsecureText = false,
    this.enable = true,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kPadding16),
      child: TextFormField(
        controller: myController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmittedValue,
        validator: onValidator,
        keyboardType: keyBoardType,
        cursorColor: cursorColor,
        enabled: enable,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: AppStyles().defaultStyle(
          16,
          AppColor.kPrimaryTextColor,
          FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: AppColor.kWhite,
          labelStyle: AppStyles().defaultStyle(
            18,
            focusNode.hasFocus
                ? AppColor.kSecondaryTextColor
                : AppColor.kTextGreyColor,
            FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.kBorderColor,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.kFocusBorderColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.kAlertColor,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.kBorderColor,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
