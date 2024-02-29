import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFieldSubmittedValue;

  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final bool obsecureText;
  final String hint;
  final Color cursorColor;
  final bool enable, autoFocus;
  const InputTextField({
    Key? key,
    this.cursorColor = AppColors.kBlack,
    required this.myController,
    required this.focusNode,
    required this.onFieldSubmittedValue,
    required this.hint,
    required this.onValidator,
    required this.keyBoardType,
    this.obsecureText = false,
    this.enable = true,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kPadding20),
      child: TextFormField(
        controller: myController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmittedValue,
        validator: onValidator,
        keyboardType: keyBoardType,
        cursorColor: cursorColor,
        enabled: enable,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: AppStyles().defaultStyle(18, AppColors.kTextSkyColor, FontWeight.normal)
            .copyWith(height: 0, fontSize: 19),
        decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.all(kPadding16),
            hintStyle:
            AppStyles().defaultStyle(20, AppColors.kTextBlackColor.withOpacity(0.5), FontWeight.w400),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.kBorderGreyColor.withOpacity(0.6),  width: 1.3),
                borderRadius: BorderRadius.circular(kBorderRadius8)),
            focusedBorder: OutlineInputBorder(
                borderSide:const BorderSide(color: AppColors.kFocusBorderPinkColor,  width: 1.3),
                borderRadius: BorderRadius.circular(kBorderRadius8)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.kAlertColor,
                width: 1.3
                ),
                borderRadius: BorderRadius.circular(kBorderRadius8)),
            enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: AppColors.kBorderGreyColor.withOpacity(0.6),  width: 1.3),
                borderRadius: BorderRadius.circular(kBorderRadius8))),
      ),
    );
  }
}



class CustomTextField2 extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  final Color cursorColor;
  final bool enabled;
  final bool autoFocus;

  const CustomTextField2({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    required this.keyboardType,
    this.obscureText = false,
    required this.hintText,
    this.cursorColor = Colors.black,
    this.enabled = true,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: cursorColor,
        enabled: enabled,
        autofocus: autoFocus,
        onTapOutside:   (event) => FocusScope.of(context).unfocus(),
        style:AppStyles().defaultStyle(18, AppColors.kTextSkyColor, FontWeight.normal),
        decoration: InputDecoration(
          labelText: hintText,
          contentPadding: const EdgeInsets.all(16.0),
         labelStyle: AppStyles().defaultStyle(20, AppColors.kTextBlackColor.withOpacity(0.5), FontWeight.w400),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1.3),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink, width: 1.3),
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.3),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.6), width: 1.3),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
