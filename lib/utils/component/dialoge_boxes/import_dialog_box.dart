import 'package:attendance_manager/constant/app_colors.dart';
import 'package:attendance_manager/constant/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/utils/component/custom_round_botton.dart';
import 'package:flutter/material.dart';


Future<void> showImportDialog(
    BuildContext context,
    String title,
    String firstText,
    String secondText,
    VoidCallback firstOnTap, // First onTap function
    VoidCallback secondOnTap) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius15),
        ),
        child: SizedBox(
          width: 300,
          height: 173,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                    color: AppColors.kThemePinkColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kBorderRadius15),
                      topRight: Radius.circular(kBorderRadius15),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: kPadding4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: AppStyles().defaultStyle(24,
                            AppColors.kTextWhiteColor, FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: AppColors.kWhite,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomRoundButton(
                      title: firstText,
                      borderRaduis: 4,

                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.58,
                      gradient: false,
                      color: AppColors.kThemePinkColor,
                      onPress: firstOnTap),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.62,
                    child: const Divider(
                      color: AppColors.kThemePinkColor,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: CustomRoundButton(
                        title: secondText,
                        height: 40,
                        borderRaduis: 4,
                        width: MediaQuery.of(context).size.width * 0.58,
                        gradient: false,
                        color: AppColors.kThemePinkColor,
                        onPress: secondOnTap),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
