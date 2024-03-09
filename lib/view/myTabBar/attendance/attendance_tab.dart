import 'package:attendance_manager/constant/app_style/app_colors.dart';
import 'package:attendance_manager/constant/app_style/app_styles.dart';
import 'package:attendance_manager/constant/constant_size.dart';
import 'package:attendance_manager/size_config.dart';
import 'package:attendance_manager/utils/routes/route_name.dart';
import 'package:attendance_manager/view_model/std_attendance/student_attendance_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/component/custom_round_botton.dart';
import '../../../utils/component/custom_shimmer_effect.dart';

// class AttendanceTab extends StatefulWidget {
//   final String classId, subject;
//
//   const AttendanceTab({Key? key, this.classId = '', this.subject = ''})
//       : super(key: key);
//
//   @override
//   State<AttendanceTab> createState() => _AttendanceTabState();
// }
//
// class _AttendanceTabState extends State<AttendanceTab> {
//   final CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime today = DateTime.now();
//   DateTime? _selectedDay;
//
//   @override
//   void initState() {
//     super.initState();
//     // Lock the orientation to portrait mode
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//   }
//
//   @override
//   void dispose() {
//     // Remember to allow all orientations when the page is disposed
//     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     super.dispose();
//   }
//
//   DateTime? _selectedDate;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kAppBackgroundColor,
//       resizeToAvoidBottomInset: true,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TableCalendar(
//             headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//                 titleTextStyle: AppStyles().defaultStyle(
//                     16, AppColors.kTextGreyColor, FontWeight.bold)),
//             focusedDay: today,
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             firstDay: DateTime(2015),
//             lastDay: DateTime(2099),
//             onDaySelected: (selectedDay, focusDay) {
//               if (!isSameDay(_selectedDay, selectedDay)) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _selectedDate = selectedDay;
//                   today = focusDay;
//                 });
//               }
//             },
//             calendarFormat: _calendarFormat,
//             startingDayOfWeek: StartingDayOfWeek.monday,
//             daysOfWeekStyle: DaysOfWeekStyle(
//               weekdayStyle: TextStyle(
//                   color: AppColors.kTextGreyColor.withOpacity(0.8),
//                   fontSize: 13),
//               weekendStyle: const TextStyle(color: AppColors.kThemePinkColor),
//             ),
//             calendarStyle: const CalendarStyle(
//               defaultTextStyle: TextStyle(fontSize: 13),
//               weekendTextStyle: TextStyle(color: AppColors.kThemePinkColor),
//               todayDecoration: BoxDecoration(
//                 color: AppColors.kTextSkyColor,
//                 shape: BoxShape.circle,
//               ),
//               selectedDecoration: BoxDecoration(
//                 color: AppColors.kThemePinkColor,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             rowHeight: 40,
//             calendarBuilders: CalendarBuilders(
//               outsideBuilder: (context, day, dayOfWeek) {
//                 return const SizedBox.shrink(); // Hide days outside the current month
//               },
//             ),
//           ),
//           const SizedBox(height: 15),
//           StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('Class')
//                   .doc(widget.classId)
//                   .collection('AttendanceRecords')
//                   .orderBy('Time')
//                   .snapshots(),
//               builder: (BuildContext context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   // Show shimmer loading effect while data is loading
//                   return const Expanded(child: ShimmerLoadingEffect());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.error_outline,
//                           color: AppColors.kAlertColor,
//                           size: 45,
//                         ),
//                         Text(
//                           'Oops..!',
//                           style: AppStyles().defaultStyle(
//                               23, AppColors.kTextBlackColor, FontWeight.w600),
//                         ),
//                         const SizedBox(
//                           height: 8,
//                         ),
//                         Text(
//                           'Sorry, Something went wrong',
//                           style: AppStyles().defaultStyle(
//                               16, AppColors.kTextBlackColor, FontWeight.w400),
//                         )
//                       ],
//                     ),
//                   );
//                 } else if (snapshot.hasData) {
//                   return Expanded(
//                     child: ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           final data = snapshot.data!.docs[index];
//                           final recordsId = snapshot.data!.docs[index].id;
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.pushNamed(context, RouteName.updateAttendance,
//                               arguments: {
//                               'classId':widget.classId,
//                               'attendanceRecordId':recordsId.toString(),
//                               'time':data['Time'],
//                               }
//                               );
//
//                               },
//                             child: Container(
//                               height: 45,
//                               width: double.infinity,
//                               padding: const EdgeInsets.only(left: 10),
//                               margin: const EdgeInsets.only(
//                                   left: 20, right: 20, top: 14),
//                               decoration: BoxDecoration(
//                                   color: AppColors.kWhite,
//                                   borderRadius: BorderRadius.circular(2),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: AppColors.kBlack.withOpacity(0.3),
//                                       spreadRadius: 0,
//                                       blurRadius: 1.5,
//                                       offset: const Offset(
//                                           0, 1), // controls the shadow position
//                                     )
//                                   ]),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         height: 17,
//                                         width: 17,
//                                         decoration: BoxDecoration(
//                                             color: AppColors.kGreenColor
//                                                 .withOpacity(0.5),
//                                             shape: BoxShape.circle),
//                                       ),
//                                       const SizedBox(
//                                         width: 15,
//                                       ),
//                                       Text(
//                                         data['Time'],
//                                         style: AppStyles().defaultStyle(
//                                             24,
//                                             AppColors.kTextBlackColor,
//                                             FontWeight.w400),
//                                       ),
//                                     ],
//                                   ),
//                                   IconButton(
//                                       onPressed: () {
//
//                                         StudentAttendanceController()
//                                             .deleteAttendanceRecordById(
//                                                 widget.classId, recordsId);
//
//                                       },
//                                       icon: const Icon(
//                                         Icons.delete,
//                                         color: AppColors.kThemePinkColor,
//                                       ))
//                                 ],
//                               ),
//                             ),
//                           );
//                         }),
//                   );
//                 } else {
//                   return const Center(child: Text('Nothing to show '));
//                 }
//               }),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding:
//             const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
//         child: CustomRoundButton(
//           title: 'TAKE ATTENDANCE',
//           gradient: false,
//           width: 155,
//           height: 40,
//           textStyle: AppStyles()
//               .defaultStyle(15, AppColors.kTextWhiteColor, FontWeight.bold),
//           borderRaduis: kBorderRadius5,
//           color: AppColors.kThemePinkColor,
//           onPress: () {
//             _selectedDate ??=
//                 today; //if selected day is null then assign it today
//
//
//             Navigator.pushNamed(context, RouteName.studentAttendancePage,
//                 arguments: {
//                   'classId': widget.classId,
//                   'subject': widget.subject,
//                   'selectedDate': _selectedDate.toString(),
//                 });
//           },
//         ),
//       ),
//     );
//   }
// }

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({Key? key}) : super(key: key);

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime today = DateTime.now();
  DateTime? _selectedDay;

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: AppStyles().defaultStyle(
                    16, AppColors.kTextGreyColor, FontWeight.bold)),
            focusedDay: today,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            firstDay: DateTime(2015),
            lastDay: DateTime(2099),
            onDaySelected: (selectedDay, focusDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _selectedDate = selectedDay;
                  today = focusDay;
                });
              }
            },
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  color: AppColors.kTextGreyColor.withOpacity(0.8),
                  fontSize: 13),
              weekendStyle: const TextStyle(color: AppColors.kThemePinkColor),
            ),
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(fontSize: 13),
              weekendTextStyle: TextStyle(color: AppColors.kThemePinkColor),
              todayDecoration: BoxDecoration(
                color: AppColors.kTextSkyColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.kThemePinkColor,
                shape: BoxShape.circle,
              ),
            ),
            rowHeight: 40,
            calendarBuilders: CalendarBuilders(
              outsideBuilder: (context, day, dayOfWeek) {
                return const SizedBox
                    .shrink(); // Hide days outside the current month
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(left: 100, right: 100, bottom: kPadding16),
          child: CustomRoundButton2(
            height: getProportionalHeight(38),
            title: 'TAKE ATTENDANCE',
            onPress: () {},
            buttonColor: AppColor.kSecondaryColor,
          )),
    );
  }
}
