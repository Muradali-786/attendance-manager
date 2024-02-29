import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:flutter/material.dart';

Future<TimeOfDay> showTimePickerDialog(BuildContext context) async {
  final selectedTime=TimeOfDay.now();

  final timePickerTheme = TimePickerThemeData(
    backgroundColor: AppColors.kAppBackgroundColor,
    // hourMinuteShape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.all(Radius.circular(8)),
    //   side: BorderSide(color: Colors.orange, width: 4),
    // ),
    // dayPeriodBorderSide: const BorderSide(color: Colors.orange, width: 4),
    dayPeriodColor:  MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected) ?  AppColors.kThemePinkColor.withOpacity(0.8):AppColors.kThemePinkColor ,),
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.all(Radius.circular(4)),
    //   // side: BorderSide(color: Colors.orange, width: 4),
    // ),
    // shape: const RoundedRectangleBorder(
    //   side: BorderSide(color: AppColors.kSecondaryThemePinkColor,width: 3)
    // ),
    dayPeriodTextColor: AppColors.kTextWhiteColor,
    // dayPeriodShape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.all(Radius.circular(4)),
    //   side: BorderSide(color:  AppColors.kBlack, width: 8),
    // ),
    hourMinuteColor: MaterialStateColor.resolveWith((states) =>
    states.contains(MaterialState.selected) ?  AppColors.kThemePinkColor.withOpacity(0.8):AppColors.kThemePinkColor ,),
    hourMinuteTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? AppColors.kTextWhiteColor : Colors.orange),
    dialHandColor: AppColors.kThemePinkColor,
    dialBackgroundColor: AppColors.kGrey.withOpacity(0.4),
    hourMinuteTextStyle: AppStyles().defaultStyle(32, AppColors.kTextBlackColor, FontWeight.bold),
    dayPeriodTextStyle:  AppStyles().defaultStyle( 16, Colors.black, FontWeight.bold),
    helpTextStyle:
    AppStyles().defaultStyle( 22,  AppColors.kThemePinkColor, FontWeight.bold),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      contentPadding: EdgeInsets.all(0),
    ),
    dialTextColor: MaterialStateColor.resolveWith(
            (states) => states.contains(MaterialState.selected) ? AppColors.kWhite : AppColors.kBlack ),
    entryModeIconColor: AppColors.kGreenColor,
  );
  TimeOfDay? pickedTime= await showTimePicker(
    context: context,

    initialTime: selectedTime,
    builder: (context,child){
      return Theme(
        data: Theme.of(context).copyWith(
          // This uses the _timePickerTheme defined above
          timePickerTheme: timePickerTheme,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              // backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.kSecondaryThemePinkColor),
              foregroundColor: MaterialStateColor.resolveWith((states) =>AppColors.kThemePinkColor),
              // overlayColor: MaterialStateColor.resolveWith((states) => AppColors.kDefaultGreenColor),
            ),
          ),
        ),
        child:    child!,
      );
    },
  );
  return pickedTime ?? selectedTime;
}

